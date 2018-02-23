//
//  DYNetworkProxyProtocol.h
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/21.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYBaseRequest.h"

@protocol DYNetworkProxyProtocol <NSObject>

@required
- (NSURLSessionTask *)sessionTaskForRequest:(DYBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error;

@end
