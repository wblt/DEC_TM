//
//  ExtraRecordTabCell.m
//  DEC
//
//  Created by wy on 2018/6/2.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ExtraRecordTabCell.h"

@implementation ExtraRecordTabCell
- (NSString *)getDate:(NSString *)jsonDate

{
    
    //jsonDate类似这种/Date(1447659630000)/
    
   // NSArray *strArray = [jsonDate componentsSeparatedByString:@"("];
    
    double timestampval =  [jsonDate doubleValue]/1000;
    
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    
    NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:updatetimestamp];
    
    return dateString;
    
}

- (void)setModel:(ExtraModel *)model {
    _model = model;
    self.nameLab.text = model.USER_NAME;
   // self.timeLab.text = model.CREATE_TIME;
    
    self.timeLab.text =  [self getDate:model.CREATE_TIME];
    
    self.numLab.text = model.S_CURRENCY;
    self.addresslab.text = model.W_ADDRESS;
    
    self.cancelBtn.hidden = YES;
    if ([model.STATUS isEqualToString:@"0"]) {
        self.typeLab.text = @"待审核";
        self.cancelBtn.hidden = NO;
    } else if ([model.STATUS isEqualToString:@"1"]) {
        self.typeLab.text = @"提币成功";
    }else if ([model.STATUS isEqualToString:@"2"]) {
        self.typeLab.text = @"提币失败";
    }else if ([model.STATUS isEqualToString:@"9"]) {
        self.typeLab.text = @"已取消";
    }
}
- (IBAction)cancelAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelExtraModel:)]) {
        [self.delegate cancelExtraModel:self.model];
    }
}

// 在cell 的视线文件中重写该方法
- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为5; 自定义
    //修改cell的Y值下移5;
    //修改cell的高度减少5;
    //未测试UICollectionViewCell    ps：应该是一样的，不过没必要，可以自己设置间距
    static CGFloat margin = 5;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += margin;
    frame.size.height -= margin;
    
    [super setFrame:frame];
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
