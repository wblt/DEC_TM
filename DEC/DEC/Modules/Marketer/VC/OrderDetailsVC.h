//
//  OrderDetailsVC.h
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface OrderDetailsVC : BaseViewController
@property(nonatomic,copy)NSString *type; // 0 买单进入， 1卖单进入
@property(nonatomic,strong)OrderModel *model;

@end
