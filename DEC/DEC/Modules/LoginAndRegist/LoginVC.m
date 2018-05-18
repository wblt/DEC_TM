//
//  LoginVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "LoginVC.h"
#import "MQVerCodeImageView.h"
#import "MainTabBarController.h"
#import "ForgetPwdVC.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property(nonatomic,strong)MQVerCodeImageView *codeImageView;
@property(nonatomic,copy)NSString *imageCodeStr;

@end

@implementation LoginVC
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_userTextField.text = [SPUtil objectForKey:k_app_userNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"登录DEC";
	[self setup];
}

- (void)setup {
	_codeImageView = [[MQVerCodeImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
	_codeImageView.bolck = ^(NSString *imageCodeStr){
		//打印生成的验证码
		_imageCodeStr = imageCodeStr;
		DLog(@"imageCodeStr = %@",imageCodeStr)
	};
	//验证码字符是否可以斜着
	_codeImageView.isRotation = YES;
	[_codeImageView freshVerCode];
	[_codeBgView addSubview: _codeImageView];
	//点击刷新
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
	[_codeImageView addGestureRecognizer:tap];
	
	_userTextField.text = [SPUtil objectForKey:k_app_userNumber];
	_pwdTextField.text = [SPUtil objectForKey:k_app_passNumber];
	
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
	[_codeImageView freshVerCode];
}

- (IBAction)loginAction:(id)sender {
	if (_userTextField.text.length <= 0 || _pwdTextField.text.length <=0 ) {
		[SVProgressHUD showInfoWithStatus:@"请填写账号密码"];
		return;
	}
	//    if (_pwdTextField.text.length <6) {
	//        [SVProgressHUD showInfoWithStatus:@"请输入6位以上密码"];
	//        return;
	//    }
	if (_codeTextField.text.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"请输入验证码"];
		return;
	}
	
	if (![_imageCodeStr.uppercaseString isEqualToString:_codeTextField.text.uppercaseString]) {
		[SVProgressHUD showErrorWithStatus:@"验证码错误"];
		[_codeImageView freshVerCode];
		return;
	}
	
	// wb wb6174784
	RequestParams *params = [[RequestParams alloc] initWithParams:API_LOGIN];
	
	[params addParameter:@"USER_NAME" value:_userTextField.text];
	[params addParameter:@"PASSWORD" value:_pwdTextField.text];
	
	[SVProgressHUD showWithStatus:@"请稍后"];
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"登陆" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		// 保存配置信息
		[SPUtil setObject:_pwdTextField.text forKey:k_app_passNumber];
		[SPUtil setObject:_userTextField.text forKey:k_app_userNumber];
		[SPUtil setBool:YES forKey:k_app_autologin];
		// 进入页面
		MainTabBarController *mainTabbar = [[MainTabBarController alloc] init];
		mainTabbar.selectIndex = 0;
		[UIApplication sharedApplication].keyWindow.rootViewController = mainTabbar;
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];

}
- (IBAction)forgetPwdAction:(id)sender {
	ForgetPwdVC *vc = [[ForgetPwdVC alloc] initWithNibName:@"ForgetPwdVC" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
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
