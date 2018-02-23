//
//  FakeNetManager.h
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/20.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DYInterfaceResultBlock)(id data, NSError *error);
typedef void (^NetSuccessBlock)(id data); // 访问成功block
typedef void (^NetErrorBlock)(NSError *error); // 访问失败block

@protocol NetWorkDelegate <NSObject>
@required
- (void)networkFinishWithSuccess:(id)data AndError:(NSError *)error;

@end



#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface FakeDatasource : NSObject

+(void)requestWithResult:(DYInterfaceResultBlock)result;


@end
