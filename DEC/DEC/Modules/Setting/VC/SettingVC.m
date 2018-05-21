//
//  SettingVC.m
//  DEC
//
//  Created by wy on 2018/5/19.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SettingVC.h"
#import "SetPhoneNumberVC.h"
#import "SetLoginPwdVC.h"
#import "SetAQPwdVC.h"
#import "SetPayInfoVC.h"
#import "SetFuLiVC.h"
#import "InviteFriendsVC.h"
#import "LoginVC.h"
#import "WelcomeVC.h"
#import "BaseNavViewController.h"
@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;
@property (weak, nonatomic) IBOutlet UILabel *visionLab;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    [self setup];
    [self addViewTap];
}

- (void)setup {
    // 获取系统版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow(CFBridgingRetain(infoDictionary));
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _visionLab.text = app_Version;
}

- (void)addViewTap {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView4 addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView5 addGestureRecognizer:tap5];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView6 addGestureRecognizer:tap6];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 100:
        {
            SetPhoneNumberVC *vc =[[SetPhoneNumberVC alloc] initWithNibName:@"SetPhoneNumberVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:
        {
            SetLoginPwdVC *vc =[[SetLoginPwdVC alloc] initWithNibName:@"SetLoginPwdVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
        {
            SetAQPwdVC *vc =[[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103:
        {
            SetPayInfoVC *vc =[[SetPayInfoVC alloc] initWithNibName:@"SetPayInfoVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 104:
        {
            InviteFriendsVC *vc =[[InviteFriendsVC alloc] initWithNibName:@"InviteFriendsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 105:
        {
            SetFuLiVC *vc =[[SetFuLiVC alloc] initWithNibName:@"SetFuLiVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (IBAction)logOutAction:(id)sender {
    [self AlertWithTitle:@"温馨提示" message:@"退出登录" andOthers:@[@"确定",@"取消"] animated:YES action:^(NSInteger index) {
        
        if (index == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 退出登录
                [SPUtil setBool:NO forKey:k_app_login];
                
                WelcomeVC *vc = [[WelcomeVC alloc] initWithNibName:@"WelcomeVC" bundle:nil];
                BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            });
            
        }
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
