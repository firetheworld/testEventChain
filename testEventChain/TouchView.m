//
//  TouchView.m
//  testEventChain
//
//  Created by liangkai.zheng on 16/5/11.
//  Copyright © 2016年 liangkai.zheng. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesBegan,%@",self.name);
    [[self nextResponder] touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesMoved,%@",self.name);
    [[self nextResponder] touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesMoved,%@",self.name);
    [[self nextResponder] touchesEnded:touches withEvent:event];

}

@end
