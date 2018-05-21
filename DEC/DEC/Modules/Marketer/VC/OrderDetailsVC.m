//
//  OrderDetailsVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "SetAQPwdVC.h"
#import <IQKeyboardManager.h>
#import "PasswordAlertView.h"
#import "XLPhotoBrowser.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadPic.h"

@interface OrderDetailsVC ()<PasswordAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *namLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *bankUserLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;
@property (weak, nonatomic) IBOutlet UILabel *alipayLab;
@property (weak, nonatomic) IBOutlet UILabel *weixinLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *surebtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property(nonatomic,copy) NSString *url;
@property(nonatomic,strong)UIImage *img;
@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic,strong) PasswordAlertView *alertView;
@property (nonatomic,strong) NSString *urlType; // 1 取消订单  2 确认收款（卖单）  3确认付款（买单）
@end

@implementation OrderDetailsVC

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//TODO: 页面appear 禁用
	[[IQKeyboardManager sharedManager] setEnable:NO];
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO; // 控制点击背景是否收起键盘
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	//TODO: 页面Disappear 启用
	[[IQKeyboardManager sharedManager] setEnable:YES];
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	if ([self.type isEqualToString:@"0"]) {
		self.navigationItem.title = @"买单详情";
	}else {
		self.navigationItem.title = @"卖单详情";
	}
	[self setup];
	[self requestData];
	
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_orderDetail];
	[params addParameter:@"TRADE_ID" value:self.model.TRADE_ID];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"订单详情" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSDictionary *pd = data[@"pd"];
		_orderIdLab.text = [NSString stringWithFormat:@"%@",pd[@"TRADE_ID"]];
		_weixinLab.text = [NSString stringWithFormat:@"%@",pd[@"WCHAT"]];
		_alipayLab.text = [NSString stringWithFormat:@"%@",pd[@"ALIPAY"]];
		_totalLab.text = [NSString stringWithFormat:@"%@",pd[@"TOTAL_MONEY"]];
		_namLab.text = [NSString stringWithFormat:@"%@",pd[@"USER_NAME"]];
		_priceLab.text = [NSString stringWithFormat:@"%@",pd[@"BUSINESS_PRICE"]];
		_timeLab.text = [NSString stringWithFormat:@"%@",pd[@"CREATE_TIME"]];
		_numLab.text = [NSString stringWithFormat:@"%@",pd[@"BUSINESS_COUNT"]];
		_bankNumLab.text =  [NSString stringWithFormat:@"%@",pd[@"BANK_NO"]];
		_bankNameLab.text = [NSString stringWithFormat:@"%@",pd[@"BANK_NAME"]];
		_bankUserLab.text = [NSString stringWithFormat:@"%@",pd[@"BANK_USERNAME"]];
		_zhiLab.text =  [NSString stringWithFormat:@"%@",pd[@"BANK_ADDR"]];
		[_imgView sd_setImageWithURL:[NSURL URLWithString:pd[@"IMAGE_NOTE"]] placeholderImage:[UIImage imageNamed:@"addimg"]];
		
		NSString *status = [NSString stringWithFormat:@"%@",pd[@"STATUS"]];
		
		if ([status isEqualToString:@"0"]) {
			_orderStatusLab.text = @"待审核";
			_surebtn.hidden = YES;
			
		}else if ([status isEqualToString:@"1"])  {
			_orderStatusLab.text = @"审核通过";
			_surebtn.hidden = YES;
			
		}else if ([status isEqualToString:@"2"])  {
			_orderStatusLab.text = @"部分成交";
			_surebtn.hidden = YES;
			
		}else if ([status isEqualToString:@"3"])  {
			_orderStatusLab.text = @"待付款";
			if ([_type isEqualToString:@"0"]) {//买单
				[_surebtn setTitle:@"确认付款" forState:UIControlStateNormal];
				[self addTapView];
			}else {// 卖单
				_surebtn.hidden = YES;
				_cancelBtn.hidden = YES;
			}
			
		}else if ([status isEqualToString:@"4"])  {
			_orderStatusLab.text = @"已付款";
			if ([_type isEqualToString:@"0"]) {//买单
				_surebtn.hidden = YES;
				_cancelBtn.hidden = YES;
			}else {// 卖单
				_cancelBtn.hidden = YES;
				[_surebtn setTitle:@"确认收款" forState:UIControlStateNormal];
			}
			
		}else if ([status isEqualToString:@"5"])  {
			_orderStatusLab.text = @"已成交";
			_surebtn.hidden = YES;
			_cancelBtn.hidden = YES;
			
		}else if ([status isEqualToString:@"6"])  {
			_orderStatusLab.text = @"已取消";
			_surebtn.hidden = YES;
			_cancelBtn.hidden = YES;
		}
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)setup {
	// 图片放大
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImgTap)];
	[_imgView addGestureRecognizer:tap];
}

- (void)addTapView {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_bgView addGestureRecognizer:tap];
}

- (void)tapAction {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择照片", @"拍照片", nil];
	[actionSheet showInView:self.view];
}

- (IBAction)sureAction:(UIButton *)sender {
	
	if ([sender.titleLabel.text isEqualToString:@"确认收款"]) {
		_urlType = @"2";
		UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
		if ([model.IFPAS isEqualToString:@"1"]) {
			[self.alertView show];
		}else {
			[SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				SetAQPwdVC *vc = [[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
				[self.navigationController pushViewController:vc animated:YES];
			});
		}
	}else {
		// 确认付款
		if (self.url.length == 0) {
			[SVProgressHUD showInfoWithStatus:@"请上传付款凭证"];
			return ;
		}
		// 确认付款
		_urlType = @"3";
		UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
		if ([model.IFPAS isEqualToString:@"1"]) {
			[self.alertView show];
			
		}else {
			[SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				SetAQPwdVC *vc = [[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
				[self.navigationController pushViewController:vc animated:YES];
			});
		}
	}
}
- (IBAction)cancelAction:(UIButton *)sender {
	_urlType = @"1";
	UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	if ([model.IFPAS isEqualToString:@"1"]) {
		[self.alertView show];
	}else {
		[SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			SetAQPwdVC *vc = [[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		});
	}
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	_imagePicker = [[UIImagePickerController alloc] init];
	_imagePicker.delegate = self;
	if (buttonIndex == 0) {/**<相册库选取照片*/
		PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
		if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
		{
			UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"相册访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
			[self presentViewController:alertC animated:YES completion:nil];
			UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
				[self dismissViewControllerAnimated:YES completion:nil];
			}];
			[alertC addAction:action];
			return;
		}else {
			_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
	}else if (buttonIndex == 1){/**<拍照选取照片*/
		/// 用户是否允许摄像头使用
		NSString * mediaType = AVMediaTypeVideo;
		AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
		/// 不允许弹出提示框
		if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
			
			UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
			[self presentViewController:alertC animated:YES completion:nil];
			UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
				[self dismissViewControllerAnimated:YES completion:nil];
			}];
			[alertC addAction:action];
			return ;
		}else {
			_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
	}else if (buttonIndex == 2){
		
		return ;
	}
	_imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	_imagePicker.allowsEditing = YES;
	[self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
//相册处理，获取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {/**<选中照片回调*/
	self.img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		UIImageWriteToSavedPhotosAlbum(
									   self.img, nil, nil, nil);
	}
	_imgView.image = self.img;
	[self dismissViewControllerAnimated:YES completion:nil];
	// 上传照片
	NSString *photoPath = [[UploadPic sharedInstance] photoSavePathForURL:info[UIImagePickerControllerReferenceURL]];
	NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage],1.0);
	if ((float)imageData.length/1024 > 100) {//需要测试
		imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1024*100.0/(float)imageData.length);
	}
	[imageData writeToFile:photoPath atomically:YES];
	NSString *fileName = [NSString stringWithFormat:@"%f_%d.jpg", [[NSDate date] timeIntervalSince1970], arc4random()%1000];
	[[UploadPic sharedInstance] uploadFileMultipartWithPath:photoPath fileName:fileName callback:^(NSString *url) {
		NSLog(@"%@",url);
		_url = url;
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {/**<不选照片点击取消回调*/
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scaleImgTap {
	if ([_type isEqualToString:@"0"]) {
		// 是买单，并且没有隐藏  就是上传图片
		
	}else {
		[XLPhotoBrowser showPhotoBrowserWithImages:@[_imgView.image] currentImageIndex:0];
	}
}

- (void)cancelOrderAction:(OrderModel *)order {
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_orderCancle];
	[params addParameter:@"TRADE_ID" value:order.TRADE_ID];
	if ([_type isEqualToString:@"0"]) {
		[params addParameter:@"TYPE" value:@"0"]; // 取消买单
	}else {
		[params addParameter:@"TYPE" value:@"1"]; // 取消卖单
	}
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"订单取消" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		[SVProgressHUD showSuccessWithStatus:@"取消成功"];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.navigationController popViewControllerAnimated:YES];
		});
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)payOrder:(OrderModel *)order {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_pay];
	[params addParameter:@"TRADE_ID" value:order.TRADE_ID];
	[params addParameter:@"STATUS" value:@"4"];
	[params addParameter:@"IMAGE_NOTE" value:_url];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"确认付款" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		[SVProgressHUD showSuccessWithStatus:@"确认付款成功"];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.navigationController popViewControllerAnimated:YES];
		});
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}
//确认收款
- (void)sureGetMoney:(OrderModel *)order {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_surePay];
	[params addParameter:@"TRADE_ID" value:order.TRADE_ID];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"确认收款" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		[SVProgressHUD showSuccessWithStatus:@"确认收款成功"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.navigationController popViewControllerAnimated:YES];
		});
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
		if ([model.PASSW isEqualToString:password]) {
			[_alertView passwordCorrect];
			
			if ([_urlType isEqualToString:@"1"]) { //取消订单
				[self cancelOrderAction:self.model];
			}else if ([_urlType isEqualToString:@"2"]){ //确认收款
				[self sureGetMoney:self.model];
			}else {//3 确认付款
				[self payOrder:self.model];
			}
			
		}else {
			[_alertView passwordError];
		}
		
	});
}

-(void)PasswordAlertViewDidClickCancleButton{
	NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
	NSLog(@"点击了忘记密码按钮");
	SetAQPwdVC *vc = [[SetAQPwdVC alloc] initWithNibName:@"SetAQPwdVC" bundle:nil];
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
