//
//  SetLoginPwdVC.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SetLoginPwdVC.h"

@interface SetLoginPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *usertextField;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *PwdTextField;

@end

@implementation SetLoginPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"登录密码";
    
}
- (IBAction)submitAction:(id)sender {
    
    if (_usertextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"用户名不能为空"];
        return;
    }
    
    
    if (_oldPwdTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"当前密码不能为空"];
        return;
    }
    
    
    if (_PwdTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"新密码不能为空"];
        return;
    }
    
    
    if (_PwdTextField.text.length < 6 ||  _PwdTextField.text.length >15) {
        [SVProgressHUD showInfoWithStatus:@"请设置6-15位数字、字母密码"];
        return;
    }
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_CGPASSWORD];
    [params addParameter:@"USER_NAME" value:_usertextField.text];
    [params addParameter:@"OLD_PAS" value:_oldPwdTextField.text];
    [params addParameter:@"NEW_PAS" value:_PwdTextField.text];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SPUtil setObject:_PwdTextField.text forKey:k_app_security];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
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
