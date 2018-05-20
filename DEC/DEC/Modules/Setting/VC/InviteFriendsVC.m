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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_bgView addGestureRecognizer:tap];
}

- (void)tapAction {
    MyFriendsViewController *vc = [[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
        
        self.leftLab.attributedText = [Util setAllText:self.leftLab.text andSpcifiStr:data[@"pd"][@"L_TOTAL"] withColor:[UIColor redColor] specifiStrFont:Font_13];
        self.rightLab.attributedText = [Util setAllText:self.rightLab.text andSpcifiStr:data[@"pd"][@"R_TOTAL"] withColor:[UIColor redColor] specifiStrFont:Font_13];
        
        self.leftUrlLab.text = data[@"pd"][@"LEFT_URL"];
        self.rightUrlLab.text = data[@"pd"][@"RIGHT_URL"];
        self.appUrlLab.text = data[@"pd"][@"APP_URL"];
        // 下划线
        NSDictionary *attribtDic1 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString:self.leftUrlLab.text attributes:attribtDic1];
        self.leftUrlLab.attributedText = attribtStr1;
        
        NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:self.rightUrlLab.text attributes:attribtDic2];
        self.rightUrlLab.attributedText = attribtStr2;
        
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
        self.friendsNumLab.attributedText = [Util setAllText:[NSString stringWithFormat:@"已邀请好友 %ld 人",pd.count] andSpcifiStr:[NSString stringWithFormat:@"%ld",pd.count] withColor:[UIColor redColor] specifiStrFont:Font_14];
        
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
