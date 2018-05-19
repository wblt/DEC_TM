//
//  ReleaseModel.h
//  DEC
//
//  Created by wy on 2018/5/19.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *USER_NAME;//用户名
@property(nonatomic,copy)NSString *CALCULATE_MONEY;//今日释放
@property(nonatomic,copy)NSString *BIG_CURRENCY;//大区算力
@property(nonatomic,copy)NSString *SMALL_CURRENCY;//小区算力
@property(nonatomic,copy)NSString *STATIC_CURRENCY;//智能算力
@property(nonatomic,copy)NSString *JD_CURRENCY;//接点算力
@property(nonatomic,copy)NSString *STEP_CURRENCY;//运动算力
@property(nonatomic,copy)NSString *CREATE_TIME;//时间
@end
