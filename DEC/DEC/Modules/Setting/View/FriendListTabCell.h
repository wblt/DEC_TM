//
//  FriendListTabCell.h
//  cc
//
//  Created by wy on 2018/4/22.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfoModel.h"

@interface FriendListTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (nonatomic,strong)FriendInfoModel *model;

@end
