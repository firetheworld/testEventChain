//
//  FakeNetManager.m
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/20.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import "FakeDatasource.h"

@implementation FakeDatasource

+(void)requestWithResult:(DYInterfaceResultBlock)result {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSString *resultData = @"get result from network";
		if (result) {
			result(resultData, nil);
		}
	});
}

@end
