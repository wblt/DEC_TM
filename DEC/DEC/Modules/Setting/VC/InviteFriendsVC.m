//
//  InviteFriendsVC.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "InviteFriendsVC.h"
#import "MyFriendsViewController.h"

@interface InviteFriendsVC ()
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *leftUrlLab;
@property (weak, nonatomic) IBOutlet UILabel *rightUrlLab;
@property (weak, nonatomic) IBOutlet UILabel *appUrlLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *friendsNumLab;

@end

@implementation InviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"邀请好友";
    [self addViewTap];
    [self requesData];
    [self requesFriends];
}

- (void)addViewTap {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView addGestureRecognizer:tap];
	
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	_leftUrlLab.userInteractionEnabled = YES;
	[_leftUrlLab addGestureRecognizer:tap1];
	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	_rightUrlLab.userInteractionEnabled = YES;
	[_rightUrlLab addGestureRecognizer:tap2];
	
	UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	_appUrlLab.userInteractionEnabled = YES;
	[_appUrlLab addGestureRecognizer:tap3];
	
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
	switch (tap.view.tag) {
		case 100:
		{
			MyFriendsViewController *vc = [[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 101:
		{
			if (self.leftUrlLab.text.length >0) {
				UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
				[pasteboard setString:self.leftUrlLab.text];
				[SVProgressHUD showSuccessWithStatus:@"复制成功"];
			}else {
				[SVProgressHUD showErrorWithStatus:@"复制失败"];
			}
			
		}
			break;
		case 102:
		{
			
			if (self.rightUrlLab.text.length >0) {
				UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
				[pasteboard setString:self.rightUrlLab.text];
				[SVProgressHUD showSuccessWithStatus:@"复制成功"];
			}else {
				[SVProgressHUD showErrorWithStatus:@"复制失败"];
			}
		}
			break;
		case 103:
		{
			
			if (self.appUrlLab.text.length >0) {
				UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
				[pasteboard setString:self.appUrlLab.text];
				[SVProgressHUD showSuccessWithStatus:@"复制成功"];
			}else {
				[SVProgressHUD showErrorWithStatus:@"复制失败"];
			}
		}
			break;
		default:
			break;
	}
	
}

-(void)requesData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_INVITATION];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"TERMINAL" value:@"1"];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"邀请好友" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        /*
         "pd": {
         "LEFT_URL": "http://ala-1254340937.file.myqcloud.com/100000280.png",
         "RIGHT_URL": "http://ala-1254340937.file.myqcloud.com/100000281.png",
         "APP_URL": "http://shcunion.vip.img.800cdn.com/ala/fj/apple2.png"
         },
         */
        self.leftLab.text = [NSString stringWithFormat:@"左区业绩:%@",data[@"pd"][@"L_TOTAL"]];
        self.rightLab.text = [NSString stringWithFormat:@"右区业绩:%@",data[@"pd"][@"R_TOTAL"]];
        
//        self.leftLab.attributedText = [Util setAllText:self.leftLab.text andSpcifiStr:data[@"pd"][@"L_TOTAL"] withColor: specifiStrFont:Font_13];
//        self.rightLab.attributedText = [Util setAllText:self.rightLab.text andSpcifiStr:data[@"pd"][@"R_TOTAL"] withColor:[UIColor redColor] specifiStrFont:Font_13];
		
		self.leftUrlLab.text = [NSString stringWithFormat:@"1.左区邀请码:%@",data[@"pd"][@"LEFT_URL"]];
		self.rightUrlLab.text = [NSString stringWithFormat:@"2.右区邀请码:%@",data[@"pd"][@"RIGHT_URL"]];
		
        self.appUrlLab.text = data[@"pd"][@"APP_URL"];
        // 下划线
//        NSDictionary *attribtDic1 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString:self.leftUrlLab.text attributes:attribtDic1];
    //    self.leftUrlLab.attributedText = attribtStr1;
        
//        NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:self.rightUrlLab.text attributes:attribtDic2];
//        self.rightUrlLab.attributedText = attribtStr2;
        
        NSDictionary *attribtDic3 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr3 = [[NSMutableAttributedString alloc]initWithString:self.appUrlLab.text attributes:attribtDic3];
        self.appUrlLab.attributedText = attribtStr3;
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)requesFriends {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_MY_FRIENDS];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"我的好友" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
		self.friendsNumLab.text = [NSString stringWithFormat:@"已邀请好友 %ld 人",pd.count];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
