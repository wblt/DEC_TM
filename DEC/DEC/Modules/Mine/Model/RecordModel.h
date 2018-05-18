//
//  RecordModel.h
//  cc
//
//  Created by yanghuan on 2018/4/25.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property(nonatomic,copy)NSString *CREATE_TIME;
@property(nonatomic,copy)NSNumber *ID;
@property(nonatomic,copy)NSString *W_ADDRESS;
@property(nonatomic,copy)NSString *CURRENCY_TYPE;
//接收记录
@property(nonatomic,copy)NSString *RECEIVE_MONEY;
//发送记录
@property(nonatomic,copy)NSString *SEND_MONEY;
//步数
@property(nonatomic,copy)NSNumber *USER_STEP;

@end
