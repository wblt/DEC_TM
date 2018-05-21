//
//  OrderModel.h
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property(nonatomic,copy)NSString *TRADE_ID;//订单ID
@property(nonatomic,copy)NSNumber *BUSINESS_COUNT;//数量
@property(nonatomic,copy)NSNumber *BUSINESS_PRICE;//单价
@property(nonatomic,copy)NSNumber *TOTAL_MONEY;//总计
@property(nonatomic,copy)NSString *CREATE_TIME;//下单时间
@property(nonatomic,copy)NSString *USER_NAME;//卖家

@property(nonatomic,copy)NSString *STATUS;//0-待审核;1审核通过;2部分成交;3代付款;4已付款5已成交;6已取消

@end
