//
//  TestDataManager.h
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/20.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FakeDatasource.h"

@interface TestService : NSObject

- (void)getFakeDataWithResult:(DYInterfaceResultBlock)result;

@end
