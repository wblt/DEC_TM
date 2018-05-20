//
//  SetAQPwdVC.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SetAQPwdVC.h"
#import "CQCountDownButton.h"
#import "SetAQPwdNextVC.h"

@interface SetAQPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property(nonatomic,strong)CQCountDownButton *countDownButton;

@end

@implementation SetAQPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"安全密码";
    [self setup];
}

- (void)setup {
    __weak __typeof__(self) weakSelf = self;
    
    self.countDownButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
        if (_phoneTextField.text.length == 0 || ![Util valiMobile:_phoneTextField.text] || _userTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号及用户名"];
            weakSelf.countDownButton.enabled = YES;
        }else {
            [SVProgressHUD showWithStatus:@"正在获取验证码..."];
            RequestParams *params = [[RequestParams alloc] initWithParams:API_AQPWD_CODE];
            [params addParameter:@"USER_NAME" value:_userTextField.text];
            [params addParameter:@"ACCOUNT" value:_phoneTextField.text];
            [params addParameter:@"digestStr" value:[NSString stringWithFormat:@"%@shc",_phoneTextField.text].MD5Hash];
            
            [[NetworkSingleton shareInstace] httpPost:params withTitle:@"安全密码短信验证码" successBlock:^(id data) {
                NSString *code = data[@"code"];
                if (![code isEqualToString:@"1000"]) {
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                    weakSelf.countDownButton.enabled = YES;
                    return ;
                }
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                // 获取到验证码后开始倒计时
                [weakSelf.countDownButton startCountDown];
            } failureBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
                weakSelf.countDownButton.enabled = YES;
            }];
        }
        
    } countDownStart:^{
        //------- 倒计时开始 -------//
        NSLog(@"倒计时开始");
    } countDownUnderway:^(NSInteger restCountDownNum) {
        //------- 倒计时进行中 -------//
        [weakSelf.countDownButton setTitle:[NSString stringWithFormat:@"再次获取(%ld秒)", restCountDownNum] forState:UIControlStateNormal];
    } countDownCompletion:^{
        //------- 倒计时结束 -------//
        [weakSelf.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        NSLog(@"倒计时结束");
    }];
   
    [_codeBgView addSubview:self.countDownButton];
    self.countDownButton.frame = CGRectMake(0, 0, 100, 30);
    [self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.countDownButton.titleLabel.font = Font_14;
    self.countDownButton.backgroundColor = [UIColor clearColor];
    [self.countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

- (IBAction)submitAction:(id)sender {
    
    // 下一步
    if (_userTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
    
    if (_phoneTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![Util valiMobile:_phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (_codeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    SetAQPwdNextVC *vc = [[SetAQPwdNextVC alloc] initWithNibName:@"SetAQPwdNextVC" bundle:nil];
    vc.user = _userTextField.text;
    vc.code = _codeTextField.text;
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
