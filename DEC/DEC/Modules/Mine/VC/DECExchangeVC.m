//
//  DECExchangeVC.m
//  DEC
//
//  Created by wy on 2018/5/19.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "DECExchangeVC.h"
#import "MQVerCodeImageView.h"


@interface DECExchangeVC ()
@property (weak, nonatomic) IBOutlet UILabel *decLab;
@property (weak, nonatomic) IBOutlet UILabel *lingqianLab;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@property(nonatomic,strong)MQVerCodeImageView *codeImageView;
@property(nonatomic,copy)NSString *imageCodeStr;

@end

@implementation DECExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationItem.title = @"转入区块DEC";
    [self setup];
}

- (void)setup {
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    _decLab.text = model.QK_CURRENCY;
    _lingqianLab.text = model.D_CURRENCY;
    _moneyTextField.placeholder = [NSString stringWithFormat:@"最多可转余额为%d",model.D_CURRENCY.intValue];
  //  _tipsLab.text = [NSString stringWithFormat:@"本次最多可转入%d至DEC钱包",model.D_CURRENCY.intValue];
	
	_tipsLab.attributedText = [Util setAllText:[NSString stringWithFormat:@"本次最多可转入%@至DEC钱包",model.D_CURRENCY] andSpcifiStr:model.D_CURRENCY withColor:[UIColor lightGrayColor] specifiStrFont:Font_13];
	
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
    
}

- (IBAction)sumbitAction:(id)sender {
    if (_moneyTextField.text.length == 0 ) {
        [SVProgressHUD showInfoWithStatus:@"请输入转入数量"];
        return;
    }
    
    if (_codeTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    if (![_codeTextField.text.uppercaseString isEqualToString:_imageCodeStr.uppercaseString]) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        [_codeImageView freshVerCode];
        return;
    }
    
    NSScanner* scan = [NSScanner scannerWithString:_codeTextField.text];
    int val;
    if (![scan scanInt:&val] && [scan isAtEnd]){
        [SVProgressHUD showErrorWithStatus:@"请输入整数数量"];
        return;
    }
    
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_TRANSFERRED];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"D_CURRENCY" value:_moneyTextField.text];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"零钱转入算力钱包" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"转入成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
    
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    [_codeImageView freshVerCode];
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
