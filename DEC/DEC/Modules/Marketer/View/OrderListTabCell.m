//
//  OrderListTabCell.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "OrderListTabCell.h"

@implementation OrderListTabCell


- (void)setOrder:(OrderModel *)order {
	_order = order;
	self.nameLab.text = order.USER_NAME;
	self.timeLab.text = order.CREATE_TIME;
	self.numLab.text = [NSString stringWithFormat:@"%.02f",[order.BUSINESS_COUNT floatValue]];
	self.priceLab.text = [NSString stringWithFormat:@"%.02f",[order.BUSINESS_PRICE floatValue]];
	self.totalLab.text = [NSString stringWithFormat:@"%.02f", [order.TOTAL_MONEY floatValue]];
	if ([order.STATUS isEqualToString:@"0"]) {
		self.statusLab.text = @"(待审核)";
	}else if ([order.STATUS isEqualToString:@"1"]) {
		self.statusLab.text = @"(审核通过)";
	}else if ([order.STATUS isEqualToString:@"2"]) {
		self.statusLab.text = @"(部分成交)";
	}else if ([order.STATUS isEqualToString:@"3"]) {
		self.statusLab.text = @"(待付款)";
	}else if ([order.STATUS isEqualToString:@"4"]) {
		self.statusLab.text = @"(已付款)";
	}else if ([order.STATUS isEqualToString:@"5"]) {
		self.statusLab.text = @"(已成交)";
	}else if ([order.STATUS isEqualToString:@"6"]) {
		self.statusLab.text = @"(已取消)";
	}
	
}

- (void)setMarketOrder:(OrderModel *)marketOrder {
	_marketOrder = marketOrder;
	self.statusLab.text = @"(可匹配)";
	self.nameLab.text = marketOrder.USER_NAME;
	self.timeLab.text = marketOrder.CREATE_TIME;
	self.numLab.text = [NSString stringWithFormat:@"%.02f",[marketOrder.BUSINESS_COUNT floatValue]];
	self.priceLab.text = [NSString stringWithFormat:@"%.02f",[marketOrder.BUSINESS_PRICE floatValue]];
	self.totalLab.text = [NSString stringWithFormat:@"%.02f", [marketOrder.TOTAL_MONEY floatValue]];
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
	frame.size.height -= margin*2;
	
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
