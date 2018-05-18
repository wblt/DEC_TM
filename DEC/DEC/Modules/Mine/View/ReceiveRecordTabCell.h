//
//  ReceiveRecordTabCell.h
//  cc
//
//  Created by yanghuan on 2018/4/25.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"
@interface ReceiveRecordTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addresslab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property(nonatomic,strong)RecordModel *recceiveModel;
@property(nonatomic,strong)RecordModel *sendModel;

@end
