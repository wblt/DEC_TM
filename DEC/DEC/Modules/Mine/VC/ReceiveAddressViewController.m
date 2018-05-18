//
//  ReceiveAddressViewController.m
//  cc
//
//  Created by wy on 2018/4/29.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "SGQRCode.h"
#import "UserInfoModel.h"
#import "ReceiveRecordVC.h"
#import "TransferRecordViewController.h"

@interface ReceiveAddressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;

@end

@implementation ReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from itsnib.
    self.navigationItem.title = @"收付款";
    [self setup];
	[self addViewTap];
}


- (void)setup {
    ViewRadius(_bgView, 10);
    
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
    _nameLab.text = model.NICK_NAME;
    _addressLab.text = model.W_ADDRESS;
    
    _codeImgView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:model.W_ADDRESS imageViewWidth:200];
}


- (void)addViewTap {
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	
	[_bgView1 addGestureRecognizer:tap1];
	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	
	[_bgView2 addGestureRecognizer:tap2];
	
	UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	[_bgView3 addGestureRecognizer:tap3];
	
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
	switch (tap.view.tag) {
		case 100:
			
			break;
		case 101:
		{
			TransferRecordViewController *vc = [[TransferRecordViewController alloc] initWithNibName:@"TransferRecordViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 102:
		{
			ReceiveRecordVC *vc = [[ReceiveRecordVC alloc] initWithNibName:@"ReceiveRecordVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		default:
			break;
	}
}


- (IBAction)copyAddressAction:(id)sender {
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:model.W_ADDRESS];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    
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
