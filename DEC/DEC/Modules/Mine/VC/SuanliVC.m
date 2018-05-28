//
//  SuanliVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/28.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SuanliVC.h"
#import "ReleaseRecordViewController.h"

@interface SuanliVC ()
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UILabel *bigLab;
@property (weak, nonatomic) IBOutlet UILabel *smallLab;
@property (weak, nonatomic) IBOutlet UILabel *zhinengLab;
@property (weak, nonatomic) IBOutlet UILabel *jiedianLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SuanliVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"算力";
	[self requesData];
	[self addViewTap];
	
}

- (void)requesData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_RELEASE];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSDictionary *dic = data[@"pd"];
		_todayLab.text = [NSString stringWithFormat:@"%.02f", [dic[@"CALCULATE_MONEY"] floatValue]];
		_bigLab.text =  [NSString stringWithFormat:@"%.02f", [dic[@"BIG_CURRENCY"] floatValue]];
		_smallLab.text =  [NSString stringWithFormat:@"%.02f", [dic[@"SMALL_CURRENCY"] floatValue]];
		_zhinengLab.text =  [NSString stringWithFormat:@"%.02f", [dic[@"STATIC_CURRENCY"] floatValue]];
		_jiedianLab.text =  [NSString stringWithFormat:@"%.02f", [dic[@"JD_CURRENCY"] floatValue]];
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)addViewTap {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_bgView addGestureRecognizer:tap];
}

- (void)tapAction {
	ReleaseRecordViewController *vc = [[ReleaseRecordViewController alloc] initWithNibName:@"ReleaseRecordViewController" bundle:nil];
	
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
