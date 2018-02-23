//
//  NextViewController.m
//  testEventChain
//
//  Created by 郑良凯 on 2017/12/28.
//  Copyright © 2017年 liangkai.zheng. All rights reserved.
//

#import "NextViewController.h"
#import "TestService.h"

@interface NextViewController () <NetWorkDelegate>

@property (nonatomic, strong) TestService *service;

@property (nonatomic, strong) id data;

@property (nonatomic, strong) NSString *testAutoRelease;
@property (nonatomic, weak) NSString *weakTestAutoRelease;

@end

@implementation NextViewController

__weak NSString *string_weak_ = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"NextViewController";
	self.view.backgroundColor = [UIColor blueColor];
	[self testBlock];
//	[self testDelegate];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"viewDidAppear");
}

- (void)dealloc {
	NSLog(@"NextViewController dealloc");
}

#pragma mark - Test Fuction
- (void)testBlock {
	__block id blockData = nil;
	WS(weakSelf);
	self.service = [[TestService alloc] init];
	[self.service getFakeDataWithResult:^(id data, NSError *error) {
		NSLog(@"NextViewController get Result from Block:%@",data);
		weakSelf.data = data;
		NSLog(@"weakSelf: %@,data: %@",weakSelf, weakSelf.data);
		blockData = data;
		NSLog(@"weakSelf: %@,blockData: %@",weakSelf, blockData);
		
		// 分页经常会有的处理逻辑
//		NSMutableArray *muteArray = [NSMutableArray array];
//		[muteArray addObject:weakSelf.data];
		// convert code
		// ...
	}];
	self.service = nil;
}

- (void)testDelegate {
	self.service = [[TestService alloc] init];
	[self.service getFakeDataWithDelegate];
	self.service.delegate = self;
//	self.service = nil;
}

#pragma mark - Network Delegate
- (void)networkFinishWithSuccess:(id)data AndError:(NSError *)error {
	NSLog(@"NextViewController get Result from Delegate:%@",data);
}

@end
