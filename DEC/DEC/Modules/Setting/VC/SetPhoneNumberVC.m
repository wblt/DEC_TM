//
//  SetPhoneNumberVC.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SetPhoneNumberVC.h"
#import "CQCountDownButton.h"

@interface SetPhoneNumberVC ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property(nonatomic,strong)CQCountDownButton *countDownButton;

@end

@implementation SetPhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"手机号码";
    [self setup];
}

- (void)setup {
    __weak __typeof__(self) weakSelf = self;
    
    self.countDownButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
        //------- 按钮点击 -------//
        if (_phoneTextField.text.length == 0 || ![Util valiMobile:_phoneTextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            weakSelf.countDownButton.enabled = YES;
            return ;
        }
                [SVProgressHUD showWithStatus:@"正在获取验证码..."];
                RequestParams *params = [[RequestParams alloc] initWithParams:API_REGIST_CODE];
                [params addParameter:@"ACCOUNT" value:_phoneTextField.text];
                [params addParameter:@"digestStr" value:[NSString stringWithFormat:@"%@shc",_phoneTextField.text].MD5Hash];
        
                [[NetworkSingleton shareInstace] httpPost:params withTitle:@"获取注册短信验证码" successBlock:^(id data) {
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
    [self.countDownButton setTitleColor:UIColorFromHex(0xCBAE86) forState:UIControlStateNormal];
    [self.countDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

- (IBAction)sumbitAction:(id)sender {
    if (_userTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }

    if (_phoneTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    
    if (_codeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (![Util valiMobile:_phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    // 提交
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_PHONECG];
    [params addParameter:@"USER_NAME" value:_userTextField.text];
    [params addParameter:@"TEL" value:_phoneTextField.text];
    [params addParameter:@"SJYZM" value:_codeTextField.text];
    
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
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
