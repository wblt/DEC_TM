//
//  SetAQPwdNextVC.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SetAQPwdNextVC.h"

@interface SetAQPwdNextVC ()
@property (weak, nonatomic) IBOutlet UITextField *pwdtextField;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTextField;

@end

@implementation SetAQPwdNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"安全密码";
}


- (IBAction)sumbitAction:(id)sender {
    if (_pwdtextField.text.length != 6) {
        [SVProgressHUD showInfoWithStatus:@"请输入6位数字"];
        return;
    }
    
    if (![_pwdtextField.text isEqualToString:_surePwdTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
        return;
    }

    RequestParams *params = [[RequestParams alloc] initWithParams:API_ANPASSW];
    [params addParameter:@"USER_NAME" value:self.user];
    [params addParameter:@"SJYZM" value:self.code];
    [params addParameter:@"NEW_PAS" value:_surePwdTextField.text];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"修改安全密码" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
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
