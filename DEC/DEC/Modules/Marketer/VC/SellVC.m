//
//  SellVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SellVC.h"

@interface SellVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *guideLab;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *chargeLab;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@end

@implementation SellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"我要挂单";
	[self setup];
	[self requestPrice];
}

- (void)setup {
	_numTextField.delegate = self;
	_priceTextField.delegate = self;
}

- (void)requestPrice {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_price];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]
	 ];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"获取指导价" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSDictionary *pd = data[@"pd"];
		_guideLab.text = [NSString stringWithFormat:@"%@",pd[@"BUSINESS_PRICE"]];
		_tipsLab.text = [NSString stringWithFormat:@"本次可挂卖最多%@个",pd[@"D_CURRENCY"]];
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_numTextField.text.length >0 && _priceTextField.text.length > 0 && ![_priceTextField.text isEqualToString:@"."]) {
		
		float money =   [_numTextField.text floatValue] * [_priceTextField.text floatValue];
		_totalLab.text = [NSString stringWithFormat:@"总价:%.02f",money];
		_chargeLab.text = [NSString stringWithFormat:@"手续费:%@能量",_numTextField.text];
	}else {
		_totalLab.text = @"总价:0";
		_chargeLab.text = @"手续费:0";
	}
	
}


- (IBAction)submitAction:(id)sender {
	if (_numTextField.text.length == 0 || [_numTextField.text isEqualToString:@"0"]) {
		[SVProgressHUD showInfoWithStatus:@"请输入数量"];
		return;
	}
	if (_priceTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入单价"];
		return ;
	}
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_sell];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	[params addParameter:@"PRICE" value:_priceTextField.text];
	[params addParameter:@"D_CURRENCY" value:_numTextField.text];
	
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		[SVProgressHUD showSuccessWithStatus:@"提交成功"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.navigationController popViewControllerAnimated:YES];
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
