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
    
    [self testView];
}

- (void)testView
{
    
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
    tapG.numberOfTapsRequired = 2;
    tapG.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapG2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tapG2.delegate = self;
    tapG2.numberOfTapsRequired = 3;
    tapG2.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *tapG3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tapG2.delegate = self;
    tapG2.numberOfTapsRequired = 1;
    tapG2.numberOfTouchesRequired = 1;

    
    [blueView addGestureRecognizer:tapG2];
//    [blueView1 addGestureRecognizer:tapG];
    [redView addGestureRecognizer:tapG3];
//    [redView1 addGestureRecognizer:tapG];
    [self.view addGestureRecognizer:tapG];
    
//    redView.userInteractionEnabled = NO;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesBegan, and I am ViewController,%@", self);
    NSLog(@"my next responder:%@", [self nextResponder]);
    NSLog(@"----------------------------------------------");
    [[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesMoved, and I am ViewController,%@", self);
    NSLog(@"my next responder:%@", [self nextResponder]);
    NSLog(@"----------------------------------------------");
    [[self nextResponder] touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesEnded, and I am ViewController,%@", self);
    NSLog(@"my next responder:%@", [self nextResponder]);
    NSLog(@"----------------------------------------------");
    [[self nextResponder] touchesMoved:touches withEvent:event];

}

- (void)tapClick:(UITapGestureRecognizer *)sender
{
    TouchView *view = (TouchView *)sender.view;
    NSLog(@"tapClick UITapGestureRecognizer,%@",view.name);
    NSLog(@"----------------------------------------------");

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    TouchView *view = (TouchView *)gestureRecognizer.view;
    NSLog(@"shouldReceiveTouch,%@",view.name);
    NSLog(@"----------------------------------------------");
//    if ([view.name isEqualToString:@"redView"]) {
//        return YES;
//    }else{
//        return NO;
//    }
    return YES;
}

@end
