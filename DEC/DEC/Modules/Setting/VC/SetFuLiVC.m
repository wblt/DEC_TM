//
//  SetFuLiVC.m
//  DEC
//
//  Created by wy on 2018/5/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SetFuLiVC.h"

@interface SetFuLiVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;

@end

@implementation SetFuLiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"复利";
    [self requestData];
    [self addViewTap];
    
}
- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_IFFL];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSDictionary *dic = data[@"pd"];
        
        if ([dic[@"IFFL"] isEqualToString:@"1"]) {
            _imgView1.hidden = NO;
            _imgView2.hidden = YES;
        }else {
            _imgView1.hidden = YES;
            _imgView2.hidden = NO;
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}



- (void)addViewTap {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
    [_bgView1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
    [_bgView2 addGestureRecognizer:tap2];
}

- (void)tapAction1 {
    _imgView1.hidden = NO;
    _imgView2.hidden = YES;
}

- (void)tapAction2 {
    _imgView1.hidden = YES;
    _imgView2.hidden = NO;
}


- (IBAction)sumbitAction:(id)sender {
    NSString *iffl = @"";
    if (_imgView1.hidden) {
        //        [SVProgressHUD showSuccessWithStatus:@"停止复利"];
        iffl = @"0";
    }else {
        //        [SVProgressHUD showSuccessWithStatus:@"自动复利"];
        iffl = @"1";
    }
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_CGFl];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"IFFL" value:iffl];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"复利设置" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        NSDictionary *dic = data[@"pd"];
        
        if ([dic[@"IFFL"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"设置自动复利成功"];
        }else if ([dic[@"IFFL"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"设置停止复利成功"];
        }
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [self.navigationController popViewControllerAnimated:YES];
        //        });
        
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
