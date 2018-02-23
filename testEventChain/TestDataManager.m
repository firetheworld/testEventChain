//
//  TestDataManager.m
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/20.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import "TestService.h"


@implementation TestService

- (void)getFakeDataWithResult:(DYInterfaceResultBlock)result {
	[FakeDatasource requestWithResult:^(id data, NSError *error) {
		NSLog(@"TestDataManager get Result:%@",data);
	}];
}

- (void)dealloc {
	NSLog(@"TestDataManager dealloc");
}

@end
