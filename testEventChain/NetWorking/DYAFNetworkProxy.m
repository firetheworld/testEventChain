//
//  AFNetworkProxy.m
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/21.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import "DYAFNetworkProxy.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation DYAFNetworkProxy {
	AFHTTPSessionManager *_manager;
	AFJSONResponseSerializer *_jsonResponseSerializer;
	AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
	NSIndexSet *_allStatusCodes;
}

#pragma mark - Serializer
- (AFJSONResponseSerializer *)jsonResponseSerializer {
	if (!_jsonResponseSerializer) {
		_jsonResponseSerializer = [AFJSONResponseSerializer serializer];
		_jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
		
	}
	return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
	if (!_xmlParserResponseSerialzier) {
		_xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
		_xmlParserResponseSerialzier.acceptableStatusCodes = _allStatusCodes;
	}
	return _xmlParserResponseSerialzier;
}

#pragma mark - ProxyProtocol
- (NSURLSessionTask *)sessionTaskForRequest:(DYBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
	return nil;
}

@end
