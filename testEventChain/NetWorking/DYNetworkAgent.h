//
//  DYNetworkAgent.h
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/21.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYBaseRequest;

@interface DYNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared agent.
+ (DYNetworkAgent *)sharedAgent;

///  Add request to session and start it.
- (void)addRequest:(DYBaseRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(DYBaseRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;

///  Return the constructed URL of request.
///
///  @param request The request to parse. Should not be nil.
///
///  @return The result URL.
- (NSString *)buildRequestUrl:(DYBaseRequest *)request;

@end
