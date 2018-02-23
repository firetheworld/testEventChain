//
//  DYNetworkAgent.m
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/21.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import "DYNetworkAgent.h"
#import "DYNetworkConfig.h"
#import "DYBaseRequest.h"
#import "DYBaseNetworkProxy.h"
#import "DYAFNetworkProxy.h"
#import "DYNetworkUtils.h"

#import <pthread/pthread.h>

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

#define kDYNetworkIncompleteDownloadFolderName @"Incomplete"

@implementation DYNetworkAgent  {
	DYNetworkConfig *_config;
	NSMutableDictionary<NSNumber *, DYBaseRequest *> *_requestsRecord;
	dispatch_queue_t _processingQueue;
	pthread_mutex_t _lock;
	NSIndexSet *_allStatusCodes;
	DYBaseNetworkProxy *_netProxy;
}

#pragma mark - Object Init
+ (DYNetworkAgent *)sharedAgent {
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_config = [DYNetworkConfig sharedConfig];
		_requestsRecord = [NSMutableDictionary dictionary];
		_processingQueue = dispatch_queue_create("com.datayes.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
		_allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
		pthread_mutex_init(&_lock, NULL);
		_netProxy = [[DYAFNetworkProxy alloc] init];
	}
	return self;
}

#pragma mark - 拼凑URL
- (NSString *)buildRequestUrl:(DYBaseRequest *)request {
	NSParameterAssert(request != nil);
	
	NSString *detailUrl = [request requestUrl];
	NSURL *temp = [NSURL URLWithString:detailUrl];
	// If detailUrl is valid URL
	if (temp && temp.host && temp.scheme) {
		return detailUrl;
	}
	// Filter URL if needed
	NSArray *filters = [_config urlFilters];
	for (id<DYUrlFilterProtocol> f in filters) {
		detailUrl = [f filterUrl:detailUrl withRequest:request];
	}
	
	NSString *baseUrl;
	if ([request useCDN]) {
		if ([request cdnUrl].length > 0) {
			baseUrl = [request cdnUrl];
		} else {
			baseUrl = [_config cdnUrl];
		}
	} else {
		if ([request baseUrl].length > 0) {
			baseUrl = [request baseUrl];
		} else {
			baseUrl = [_config baseUrl];
		}
	}
	// URL slash compability
	NSURL *url = [NSURL URLWithString:baseUrl];
	
	if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
		url = [url URLByAppendingPathComponent:@""];
	}
	
	return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}

#pragma mark - Manage Request
- (void)addRequest:(DYBaseRequest *)request {
	NSParameterAssert(request != nil);
	
	NSError * requestSerializationError = nil;
	
	request.requestTask = [_netProxy sessionTaskForRequest:request error:&requestSerializationError];
	
	if (requestSerializationError) {
		[self requestDidFailWithRequest:request error:requestSerializationError];
		return;
	}
	
	NSAssert(request.requestTask != nil, @"requestTask should not be nil");
	
	// Set request task priority
	// !!Available on iOS 8 +
	if ([request.requestTask respondsToSelector:@selector(priority)]) {
		switch (request.requestPriority) {
			case DYRequestPriorityHigh:
				request.requestTask.priority = NSURLSessionTaskPriorityHigh;
				break;
			case DYRequestPriorityLow:
				request.requestTask.priority = NSURLSessionTaskPriorityLow;
				break;
			case DYRequestPriorityDefault:
				/*!!fall through*/
			default:
				request.requestTask.priority = NSURLSessionTaskPriorityDefault;
				break;
		}
	}
	
	// Retain request
//	DYLog(@"Add request: %@", NSStringFromClass([request class]));
	[self addRequestToRecord:request];
	[request.requestTask resume];
}

- (void)cancelRequest:(DYBaseRequest *)request {
	NSParameterAssert(request != nil);
	
	if (request.resumableDownloadPath) {
		NSURLSessionDownloadTask *requestTask = (NSURLSessionDownloadTask *)request.requestTask;
		[requestTask cancelByProducingResumeData:^(NSData *resumeData) {
//		NSURL *localUrl = [self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath];
//		[resumeData writeToURL:localUrl atomically:YES];
		}];
	} else {
		[request.requestTask cancel];
	}
	
	[self removeRequestFromRecord:request];
}

- (void)cancelAllRequests {
	Lock();
	NSArray *allKeys = [_requestsRecord allKeys];
	Unlock();
	if (allKeys && allKeys.count > 0) {
		NSArray *copiedKeys = [allKeys copy];
		for (NSNumber *key in copiedKeys) {
			Lock();
			DYBaseRequest *request = _requestsRecord[key];
			Unlock();
			// We are using non-recursive lock.
			// Do not lock `stop`, otherwise deadlock may occur.
			[request stop];
		}
	}
}

- (void)requestDidSucceedWithRequest:(DYBaseRequest *)request {
	@autoreleasepool {
		[request requestCompletePreprocessor];
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		[request toggleAccessoriesWillStopCallBack];
		[request requestCompleteFilter];
		
		if (request.delegate != nil) {
			[request.delegate requestFinished:request];
		}
		[request toggleAccessoriesDidStopCallBack];
	});
}

- (void)requestDidFailWithRequest:(DYBaseRequest *)request error:(NSError *)error {
	request.error = error;
//	DYLog(@"Request %@ failed, status code = %ld, error = %@",
//		   NSStringFromClass([request class]), (long)request.responseStatusCode, error.localizedDescription);
	
	// Save incomplete download data.
	NSData *incompleteDownloadData = error.userInfo[NSURLSessionDownloadTaskResumeData];
//	if (incompleteDownloadData) {
//		[incompleteDownloadData writeToURL:[self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath] atomically:YES];
//	}
	
	// Load response from file and clean up if download task failed.
	if ([request.responseObject isKindOfClass:[NSURL class]]) {
		NSURL *url = request.responseObject;
		if (url.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
			request.responseData = [NSData dataWithContentsOfURL:url];
			request.responseString = [[NSString alloc] initWithData:request.responseData encoding:[DYNetworkUtils stringEncodingWithRequest:request]];
			
			[[NSFileManager defaultManager] removeItemAtURL:url error:nil];
		}
		request.responseObject = nil;
	}
	
	@autoreleasepool {
		[request requestFailedPreprocessor];
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		[request toggleAccessoriesWillStopCallBack];
		[request requestFailedFilter];
		
		if (request.delegate != nil) {
			[request.delegate requestFailed:request];
		}
		[request toggleAccessoriesDidStopCallBack];
	});
}

- (void)addRequestToRecord:(DYBaseRequest *)request {
	Lock();
	_requestsRecord[@(request.requestTask.taskIdentifier)] = request;
	Unlock();
}

- (void)removeRequestFromRecord:(DYBaseRequest *)request {
	Lock();
	[_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
//	DYLog(@"Request queue size = %zd", [_requestsRecord count]);
	Unlock();
}

@end
