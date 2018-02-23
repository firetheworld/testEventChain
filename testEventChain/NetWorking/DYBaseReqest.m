//
//  DYBaseReqest.m
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/21.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import "DYBaseRequest.h"
#import "DYNetworkAgent.h"

@interface DYBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation DYBaseRequest

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
	return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
	return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
	return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
	return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
	return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
	if (!self.requestTask) {
		return NO;
	}
	return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
	if (!self.requestTask) {
		return NO;
	}
	return self.requestTask.state == NSURLSessionTaskStateRunning;
}

#pragma mark - Request Configuration

- (void)addAccessory:(id<DYRequestAccessory>)accessory {
	if (!self.requestAccessories) {
		self.requestAccessories = [NSMutableArray array];
	}
	[self.requestAccessories addObject:accessory];
}

#pragma mark - Request Action

- (void)start {
//	[self toggleAccessoriesWillStartCallBack];
	[[DYNetworkAgent sharedAgent] addRequest:self];
}

- (void)stop {
//	[self toggleAccessoriesWillStopCallBack];
	self.delegate = nil;
	[[DYNetworkAgent sharedAgent] cancelRequest:self];
//	[self toggleAccessoriesDidStopCallBack];
}

#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {
}

- (void)requestCompleteFilter {
}

- (void)requestFailedPreprocessor {
}

- (void)requestFailedFilter {
}

- (NSString *)requestUrl {
	return @"";
}

- (NSString *)cdnUrl {
	return @"";
}

- (NSString *)baseUrl {
	return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
	return 60;
}

- (id)requestArgument {
	return nil;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
	return argument;
}

- (DYRequestMethod)requestMethod {
	return DYRequestMethodGET;
}

- (DYRequestSerializerType)requestSerializerType {
	return DYRequestSerializerTypeHTTP;
}

- (DYResponseSerializerType)responseSerializerType {
	return DYResponseSerializerTypeJSON;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
	return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
	return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
	return nil;
}

- (BOOL)useCDN {
	return NO;
}

- (BOOL)allowsCellularAccess {
	return YES;
}

- (id)jsonValidator {
	return nil;
}

- (BOOL)statusCodeValidator {
	NSInteger statusCode = [self responseStatusCode];
	return (statusCode >= 200 && statusCode <= 299);
}

- (id)mockData {
	return nil;
}

#pragma mark - NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.requestArgument];
}

@end
