//
//  AllRecodeTabCell.m
//  DEC
//
//  Created by wy on 2018/5/19.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "AllRecodeTabCell.h"

@implementation AllRecodeTabCell

- (void)setModel:(ReleaseModel *)model {
    _model = model;
    self.todayLab.text =  [NSString stringWithFormat:@"%.02f", [model.CALCULATE_MONEY floatValue]];
    self.leftLab.text = [NSString stringWithFormat:@"%.02f", [model.BIG_CURRENCY floatValue]];
    self.rightLab.text = [NSString stringWithFormat:@"%.02f", [model.SMALL_CURRENCY floatValue]];
    self.zhinengLab.text = [NSString stringWithFormat:@"%.02f", [model.STATIC_CURRENCY floatValue]];
    self.timeLab.text = model.CREATE_TIME;
    self.jdLab.text = [NSString stringWithFormat:@"%.02f",[model.JD_CURRENCY floatValue]];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
