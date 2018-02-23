//
//  DYSelfStockItem.h
//  AIInvest
//
//  Created by 郑良凯 on 2017/12/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"


@interface DYSelfStockItem : NSObject

@property (nonatomic, strong) NSString *exchangeCD;
@property (nonatomic, strong) NSString *ticker;
@property (nonatomic, assign) long timestamp;
@property (nonatomic, assign) double openPrice;
@property (nonatomic, assign) double lastPrice;
@property (nonatomic, strong) NSString *shortNM;
@property (nonatomic, assign) double changePct;
@property (nonatomic, assign) double prevClosePrice;
@property (nonatomic, assign) double highPrice;
@property (nonatomic, assign) double lowPrice;
@property (nonatomic, assign) double volume;
@property (nonatomic, assign) int suspension;
@property (nonatomic, assign) double value;
@end
