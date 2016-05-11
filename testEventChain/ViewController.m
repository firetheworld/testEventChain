//
//  ViewController.m
//  testEventChain
//
//  Created by liangkai.zheng on 16/5/11.
//  Copyright © 2016年 liangkai.zheng. All rights reserved.
//

#import "ViewController.h"
#import "TouchView.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TouchView *bgView = [[TouchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    bgView.backgroundColor = [UIColor cyanColor];
    bgView.name = @"bgView";
    self.view = bgView;
    
    
    TouchView *blueView = [[TouchView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.name = @"blueView";
    [self.view addSubview:blueView];

    
    TouchView *redView = [[TouchView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    redView.name = @"redView";
    [blueView addSubview:redView];
    
    
    TouchView *blueView1 = [[TouchView alloc] initWithFrame:CGRectMake(100, 400, 200, 200)];
    blueView1.backgroundColor = [UIColor blueColor];
    blueView1.name = @"blueView1";
    [self.view addSubview:blueView1];
    
    
    TouchView *redView1 = [[TouchView alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    redView1.backgroundColor = [UIColor redColor];
    redView1.name = @"redView1";
    [self.view addSubview:redView1];
    
    UITapGestureRecognizer *tapG =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tapG.delegate = self;
#if TARGET_IPHONE_SIMULATOR//模拟器
    tapG.numberOfTapsRequired = 2;
    tapG.numberOfTouchesRequired = 1;
#elif TARGET_OS_IPHONE//真机
    tapG.numberOfTapsRequired = 4;
    tapG.numberOfTouchesRequired = 3;
#endif
    
    [blueView addGestureRecognizer:tapG];
    [blueView1 addGestureRecognizer:tapG];
    [redView addGestureRecognizer:tapG];
    [redView1 addGestureRecognizer:tapG];
//    [self.view addGestureRecognizer:tapG];

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"ViewController touchesBegan");
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"ViewController touchesMoved");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"ViewController touchesMoved");
}

- (void)tapClick:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"ViewController UITapGestureRecognizer,%@",sender.view);
}

@end
