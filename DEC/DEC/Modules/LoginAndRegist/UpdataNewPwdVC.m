//
//  UpdataNewPwdVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/18.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "UpdataNewPwdVC.h"

@interface UpdataNewPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTextField;

@end

@implementation UpdataNewPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"修改密码";
	
}

- (IBAction)submitAction:(id)sender {
	if (_surePwdTextField.text.length == 0 || _pwdTextField.text.length == 0 ) {
		 [SVProgressHUD showErrorWithStatus:@"请输入密码"];
		return;
	}
	
	if (_pwdTextField.text.length < 5 || _pwdTextField.text.length > 15) {
		[SVProgressHUD showInfoWithStatus:@"请输入6到15位数字、字母密码"];
		return;
	}
	
	if (![_pwdTextField.text isEqualToString:_surePwdTextField.text]) {
		 [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
		return;
	}
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_FGPWD];
	[params addParameter:@"USER_NAME" value:self.userName];
	[params addParameter:@"SJYZM" value:self.code];
	[params addParameter:@"PASSWORD" value:_pwdTextField.text];
	[SVProgressHUD showWithStatus:@"请稍后"];
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"忘记密码" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		//保存用户信息
		[SPUtil setObject:self.userName forKey:k_app_userNumber];
		// 回到登录界面、 或者直接进入
		[self.navigationController popToRootViewControllerAnimated:YES];
		
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
