//
//  BuyVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "BuyVC.h"
#import "PasswordAlertView.h"
#import "SetAQPwdVC.h"
#import <IQKeyboardManager.h>

@interface BuyVC ()<UITextFieldDelegate,PasswordAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (nonatomic,strong) PasswordAlertView *alertView;

@end

@implementation BuyVC

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//TODO: 页面appear 禁用
	[[IQKeyboardManager sharedManager] setEnable:NO];
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO; // 控制点击背景是否收起键盘
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	//TODO: 页面Disappear 启用
	[[IQKeyboardManager sharedManager] setEnable:YES];
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"买单";
	[self setup];
}


- (void)setup {
	_numTextField.delegate = self;
	_priceLab.text = [NSString stringWithFormat:@"%.02f",[self.model.BUSINESS_PRICE floatValue]];
	_numLab.text = [NSString stringWithFormat:@"%@",self.model.BUSINESS_COUNT];
	
	_alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
	_alertView.delegate = self;
	_alertView.titleLable.text = @"请输入安全密码";
	_alertView.tipsLalbe.text = @"您输入的密码不正确！";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_numTextField.text.length >0 ) {
		
		float money =   [_numTextField.text floatValue] * [self.model.BUSINESS_PRICE floatValue];
		_totalLab.text = [NSString stringWithFormat:@"总价:%.02f",money];
	}else {
		_totalLab.text = @"总价:0";
	}
	
}

-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
	NSLog(@"完成了密码输入,密码为：%@",password);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[_alertView passwordCorrect];
		
		RequestParams *params = [[RequestParams alloc] initWithParams:API_buy];
		[params addParameter:@"TRADE_ID" value:self.model.TRADE_ID];
		[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
		[params addParameter:@"D_CURRENCY" value:_numTextField.text];
		[params addParameter:@"PASSW" value:password];
		
		[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
			NSString *code = data[@"code"];
			if (![code isEqualToString:@"1000"]) {
				[SVProgressHUD showErrorWithStatus:data[@"message"]];
				return ;
			}
			[SVProgressHUD showSuccessWithStatus:@"购买成功"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.navigationController popViewControllerAnimated:YES];
			});
			
		} failureBlock:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
		}];
	});
}

-(void)PasswordAlertViewDidClickCancleButton{
	NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
	NSLog(@"点击了忘记密码按钮");
	SetAQPwdVC *vc = [[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sumbitAction:(id)sender {
	if (_numTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入购买数量"];
		return;
	}
	
	if (_numTextField.text.integerValue > self.model.BUSINESS_COUNT.integerValue) {
		[SVProgressHUD showErrorWithStatus:@"超过可买数量"];
		return ;
	}
	
	UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	
	if ([model.IFPAS isEqualToString:@"1"]) {
		[_alertView show];
	}else {
		[SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			SetAQPwdVC *vc = [[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		});
		
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
