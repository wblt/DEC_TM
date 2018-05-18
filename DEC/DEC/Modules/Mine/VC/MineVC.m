//
//  MineVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineVC.h"
#import "UserInfoModel.h"
#import "SGQRCode.h"
#import "MindeInfoVC.h"
#import "ReceiveAddressViewController.h"

@interface MineVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *suanliLab;
@property (weak, nonatomic) IBOutlet UILabel *lingqianLab;
@property (weak, nonatomic) IBOutlet UILabel *powerLab;
@property (weak, nonatomic) IBOutlet UILabel *decLab;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;

@end

@implementation MineVC

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
		_suanliLab.text = [NSString stringWithFormat:@"%@",model.S_CURRENCY];
		_decLab.text = [NSString stringWithFormat:@"%@",model.QK_CURRENCY];
		_lingqianLab.text = model.D_CURRENCY;
		_powerLab.text = [NSString stringWithFormat:@"%@",model.W_ENERGY];

		_nameLab.text = model.NICK_NAME;
		_addressLab.text = model.W_ADDRESS;
		
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
	
	UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	[_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
	_suanliLab.text = [NSString stringWithFormat:@"%@",model.S_CURRENCY];
	_decLab.text = [NSString stringWithFormat:@"%@",model.QK_CURRENCY];
	_lingqianLab.text = model.D_CURRENCY;
	_powerLab.text = [NSString stringWithFormat:@"%@",model.W_ENERGY];
	
	_nameLab.text = model.NICK_NAME;
	_addressLab.text = model.W_ADDRESS;
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
	
	UITapGestureRecognizer *imgTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction)];
	_headImgView.userInteractionEnabled = YES;
	[_headImgView addGestureRecognizer:imgTap];
	
	UITapGestureRecognizer *addressTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapAction)];
	_addressLab.userInteractionEnabled = YES;
	[_addressLab addGestureRecognizer:addressTap];
	
}

- (void)imgTapAction {
	MindeInfoVC *vc = [[MindeInfoVC alloc] initWithNibName:@"MindeInfoVC" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
	
}

- (void)addressTapAction {
	ReceiveAddressViewController *vc = [[ReceiveAddressViewController alloc] initWithNibName:@"ReceiveAddressViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
	
	switch (tap.view.tag) {
		case 100:
			
			break;
		case 101:
			
			break;
		case 102:
			
			break;
		case 103:
			
			break;
		case 104:
			
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
