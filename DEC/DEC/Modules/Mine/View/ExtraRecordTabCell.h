//
//  ExtraRecordTabCell.h
//  DEC
//
//  Created by wy on 2018/6/2.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtraModel.h"
@protocol ExtraRecordTabCellDelegate<NSObject>

- (void)cancelExtraModel:(ExtraModel *)model;

@end

@interface ExtraRecordTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addresslab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property(weak,nonatomic)id<ExtraRecordTabCellDelegate>delegate;
@property(nonatomic,strong)ExtraModel *model;

@end
