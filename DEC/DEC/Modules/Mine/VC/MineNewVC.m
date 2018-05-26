//
//  MineNewVC.m
//  DEC
//
//  Created by wy on 2018/5/26.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineNewVC.h"
#import "MindeInfoVC.h"
#import "SGQRCode.h"
#import "MindeInfoVC.h"
#import "ReceiveAddressViewController.h"
#import "ReleaseRecordViewController.h"
#import "SendChangeVC.h"
#import "PowerCGVC.h"
#import "DECExchangeVC.h"
#import "SettingVC.h"
#import "ReceiveAddressViewController.h"
#import "SetFuLiVC.h"
#import "InviteFriendsVC.h"
#import "MybuyOrderVC.h"


@interface MineNewVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;
@property (weak, nonatomic) IBOutlet UIView *bgView7;
@property (weak, nonatomic) IBOutlet UIView *bgView8;
@property (weak, nonatomic) IBOutlet UIView *bgView9;
@property (weak, nonatomic) IBOutlet UILabel *suanliLab;
@property (weak, nonatomic) IBOutlet UILabel *decLab;
@property (weak, nonatomic) IBOutlet UILabel *lingqianLab;
@property (weak, nonatomic) IBOutlet UILabel *powerLab;

@end

@implementation MineNewVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    [self addViewTap];
}

// 获取首页数据
- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_HOMEPAGE];
    
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        NSDictionary *dic = data[@"pd"];
        UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dic];
        [[BeanManager shareInstace] setBean:model path:UserModelPath];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
       
        if (![model.S_CURRENCY isEqualToString:@"0.00"]) {
            _suanliLab.text = [NSString stringWithFormat:@"%@",model.S_CURRENCY];
        }
        
        if (![model.QK_CURRENCY isEqualToString:@"0.00"] ) {
            _decLab.text = [NSString stringWithFormat:@"%@",model.QK_CURRENCY];
        }
        
        if (![model.D_CURRENCY isEqualToString:@"0.00"] ) {
            _lingqianLab.text = model.D_CURRENCY;
        }
        
        if (![model.W_ENERGY isEqualToString:@"0.00"] ) {
            _powerLab.text = [NSString stringWithFormat:@"%@",model.W_ENERGY];
        }
        
        _nameLab.text = model.NICK_NAME;
        
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
    
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    if (![model.S_CURRENCY isEqualToString:@"0.00"]) {
        _suanliLab.text = [NSString stringWithFormat:@"%@",model.S_CURRENCY];
    }
    
    if (![model.QK_CURRENCY isEqualToString:@"0.00"] ) {
         _decLab.text = [NSString stringWithFormat:@"%@",model.QK_CURRENCY];
    }
    
    if (![model.D_CURRENCY isEqualToString:@"0.00"] ) {
        _lingqianLab.text = model.D_CURRENCY;
    }
    
    if (![model.W_ENERGY isEqualToString:@"0.00"] ) {
          _powerLab.text = [NSString stringWithFormat:@"%@",model.W_ENERGY];
    }
    
    _nameLab.text = model.NICK_NAME;
}


- (void)addViewTap {
    UITapGestureRecognizer *imgTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction)];
    _headImgView.userInteractionEnabled = YES;
    [_headImgView addGestureRecognizer:imgTap];
    
    
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
    
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView7 addGestureRecognizer:tap7];
    
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView8 addGestureRecognizer:tap8];
    
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView9 addGestureRecognizer:tap9];
}

- (void)imgTapAction {
    MindeInfoVC *vc = [[MindeInfoVC alloc] initWithNibName:@"MindeInfoVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 101:
        {
            ReleaseRecordViewController *vc = [[ReleaseRecordViewController alloc] initWithNibName:@"ReleaseRecordViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
        {
            DECExchangeVC *vc = [[DECExchangeVC alloc] initWithNibName:@"DECExchangeVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103:
        {
            SendChangeVC *vc = [[SendChangeVC alloc] initWithNibName:@"SendChangeVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 104:
        {
            PowerCGVC *vc = [[PowerCGVC alloc] initWithNibName:@"PowerCGVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 105:
        {
            ReceiveAddressViewController *vc = [[ReceiveAddressViewController alloc] initWithNibName:@"ReceiveAddressViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 106:
        {
            SetFuLiVC *vc = [[SetFuLiVC alloc] initWithNibName:@"SetFuLiVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 107:
        {
            InviteFriendsVC *vc = [[InviteFriendsVC alloc] initWithNibName:@"InviteFriendsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 108:
        {
            
        }
            break;
        case 109:
        {
            SettingVC *vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
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
