//
//  BaseViewController.m
//  Keepcaring
//
//  Created by mac on 2017/12/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic,strong) UIImageView* noDataView;
@property(nonatomic,strong)ErrorView *errorView;

@end

@implementation BaseViewController


- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_main_tt_bg"] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**<设置导航栏背景颜色*/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
//	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//	
//	//获取与当前设备匹配的启动图片名称
//	if (screenHeight == 480){ //4，4S
//		  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS56_320x480pt"]];
//	}
//	else if (screenHeight == 568){ //5, 5C, 5S, iPod
//		  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS56_320x568pt"]];
//	}
//	else if (screenHeight == 667){ //6, 6S
//		
//		  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS89_375x667pt"]];
//	}
//	else if (screenHeight == 736){ // 6Plus, 6SPlus
//		  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS89_414x736pt"]];
//	}else if (screenHeight == 812){
//		 self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhoneXPortraitiOS11_375x812pt"]];
//	}
	
//    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg"]];
	
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :UIColorFromHex(0xCBAE86), NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    [self.view addSubview:self.errorView];
}

- (void)refreshData {
    
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            obj.hidden = YES;
            obj.hidden = NO;
            self.errorView.hidden = YES;
        }
    }];
}

-(void)showImagePage:(BOOL)show withIsError:(BOOL)error {

    self.errorView.isError = error;
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            obj.hidden = YES;
            self.errorView.frame = obj.frame;
            self.errorView.hidden = NO;
        }
    }];
    if (error) {
        self.errorView.backgroudImageView.image = [UIImage imageNamed:@"loaderror_icon"];
    }else{
        self.errorView.backgroudImageView.image = [UIImage imageNamed:@"loaderror"];
    }
    
}

- (ErrorView *)errorView {
    if (_errorView == nil) {
        _errorView = [[ErrorView alloc] initWithFrame:CGRectZero];
        _errorView.backgroudImageView.image = [UIImage imageNamed:@"loaderror"];
        _errorView.contentMode = UIViewContentModeScaleAspectFit;
        _errorView.hidden = YES;
        typeof(self) weekSelf = self;
        _errorView.block = ^(NSInteger tag){
            weekSelf.errorView.hidden = YES;
            [weekSelf refreshData];
        };
    }
    return _errorView;
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
