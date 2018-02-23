//
//  TestService.m
//  testEventChain
//
//  Created by 郑良凯 on 2018/1/20.
//  Copyright © 2018年 liangkai.zheng. All rights reserved.
//

#import "TestService.h"


@implementation TestService

- (void)getFakeDataWithResult:(DYInterfaceResultBlock)result {
	
	WS(weakSelf);
	[FakeDatasource requestWithResult:^(id data, NSError *error) {
		NSLog(@"TestService get Result:%@",data);
		
		// 判断成功
		// 判断失败
		
		if (result) {
			result(data, nil);
		}
	}];
}

- (void)getFakeDataWithDelegate {
	WS(weakSelf);
	[FakeDatasource requestWithResult:^(id data, NSError *error) {
		if ([weakSelf.delegate respondsToSelector:@selector(networkFinishWithSuccess: AndError:)]) {
			NSLog(@"TestDataManager get Result:%@",data);
			[weakSelf.delegate networkFinishWithSuccess:data AndError:nil];
		}
	}];
}

- (void)dealloc {
	NSLog(@"TestDataManager dealloc");
}

@end
