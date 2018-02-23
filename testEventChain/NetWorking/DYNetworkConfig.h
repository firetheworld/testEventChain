//
//  DYNetworkConfig.h
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/21.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYBaseRequest;

///  DYUrlFilterProtocol can be used to append common parameters to requests before sending them.
@protocol DYUrlFilterProtocol <NSObject>
///  Preprocess request URL before actually sending them.
///
///  @param originUrl request's origin URL, which is returned by `requestUrl`
///  @param request   request itself
///
///  @return A new url which will be used as a new `requestUrl`
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(DYBaseRequest *)request;
@end

///  DYCacheDirPathFilterProtocol can be used to append common path components when caching response results
@protocol DYCacheDirPathFilterProtocol <NSObject>
///  Preprocess cache path before actually saving them.
///
///  @param originPath original base cache path, which is generated in `DYRequest` class.
///  @param request    request itself
///
///  @return A new path which will be used as base path when caching.
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(DYBaseRequest *)request;
@end

///  DYNetworkConfig stored global network-related configurations, which will be used in `DYNetworkAgent`
///  to form and filter requests, as well as caching response.
@interface DYNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Return a shared config object.
+ (DYNetworkConfig *)sharedConfig;

///  Request base URL, such as "http://www.yuantiku.com". Default is empty string.
@property (nonatomic, strong) NSString *baseUrl;
///  Request CDN URL. Default is empty string.
@property (nonatomic, strong) NSString *cdnUrl;
///  URL filters. See also `DYUrlFilterProtocol`.
@property (nonatomic, strong, readonly) NSArray<id<DYUrlFilterProtocol>> *urlFilters;
///  Cache path filters. See also `DYCacheDirPathFilterProtocol`.
@property (nonatomic, strong, readonly) NSArray<id<DYCacheDirPathFilterProtocol>> *cacheDirPathFilters;

///  Security policy will be used by AFNetworking. See also `AFSecurityPolicy`.
//@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

///  Whether to log debug info. Default is NO;
@property (nonatomic) BOOL debugLogEnabled;
///  SessionConfiguration will be used to initialize AFHTTPSessionManager. Default is nil.
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;

///  Add a new URL filter.
- (void)addUrlFilter:(id<DYUrlFilterProtocol>)filter;
///  Remove all URL filters.
- (void)clearUrlFilter;
///  Add a new cache path filter
- (void)addCacheDirPathFilter:(id<DYCacheDirPathFilterProtocol>)filter;
///  Clear all cache path filters.
- (void)clearCacheDirPathFilter;

@end
