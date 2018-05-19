//
//  AllRecodeTabCell.h
//  DEC
//
//  Created by wy on 2018/5/19.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseModel.h"

@interface AllRecodeTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *zhinengLab;
@property (weak, nonatomic) IBOutlet UILabel *jdLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property(nonatomic,strong)ReleaseModel *model;

@end
