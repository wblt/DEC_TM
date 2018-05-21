//
//  RegsitNextStepVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "RegsitNextStepVC.h"

@interface RegsitNextStepVC ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *sureTextField;

@end

@implementation RegsitNextStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		self.navigationItem.title = @"欢迎注册DEC";
}
- (IBAction)sumbitAction:(id)sender {
	if (_sureTextField.text.length == 0 || _pwdTextField.text.length == 0 ) {
		[SVProgressHUD showErrorWithStatus:@"请输入密码"];
		return;
	}
	
	if (_pwdTextField.text.length < 5 || _pwdTextField.text.length > 15) {
		[SVProgressHUD showInfoWithStatus:@"请输入6到15位数字、字母密码"];
		return;
	}
	
	if (![_pwdTextField.text isEqualToString:_sureTextField.text]) {
		[SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
		return;
	}
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_REGIST];
	[params addParameter:@"USER_NAME" value:self.userName];
	[params addParameter:@"PASSWORD" value:_pwdTextField.text];
	[params addParameter:@"ACCOUNT" value:self.phone];
	[params addParameter:@"SJYZM" value:self.code];
	[params addParameter:@"YQ_CODE" value:self.invite];
	
	[SVProgressHUD showWithStatus:@"请稍后"];
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		//保存用户信息
		[SPUtil setObject:self.userName forKey:k_app_userNumber];
		// 回到登录界面、 或者直接进入
		[SVProgressHUD showSuccessWithStatus:@"注册成功"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.navigationController popToRootViewControllerAnimated:YES];
		});
		
		
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
