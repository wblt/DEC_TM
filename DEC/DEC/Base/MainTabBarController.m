//
//  MainTabBarController.m
//  ThankYou
//
//  Created by lizzy on 16/5/4.
//  Copyright © 2016年 2011-2013 湖南长沙阳环科技实业有限公司 @license http://www.yhcloud.com.cn. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavViewController.h"
#import "MainTabBarItem.h"
#import "BaseViewController.h"
#import "HomeVC.h"
#import "MineVC.h"
#import "MarketVC.h"
#import "HomeNewVC.h"
#import "MarketListVC.h"
#import "RecordVC.h"
#import "MineNewVC.h"
#import "SuanliVC.h"

@interface MainTabBarController ()
{
    MainTabBarItem *selectedItem;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewControllers];
	self.tabBar.backgroundImage =  [self imageWithColor:UIColorFromHex(0x424242)];
 //[UIImage imageNamed:@"tabbarImageView"];
    self.tabBar.shadowImage = [UIImage new];
    
  //  self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarBg"];
  //  self.tabBar.shadowImage = [[UIImage alloc]init];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSArray *subViews = self.tabBar.subviews;
    for (UIView *view in subViews) {
        //此函数能获取该字符串指代的类
        Class cla = NSClassFromString(@"UITabBarButton");
        //判断该视图的类型是否属于cla所指的类型
        if ([view isKindOfClass:cla]) {
            [view removeFromSuperview];
        }
    }
    [self createTabbar];
}

#pragma mark Private Method
-(void)addViewControllers {/**<添加二级控制器*/
    //HomeVC *releaseVC = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    HomeNewVC *releaseVC = [[HomeNewVC alloc] initWithNibName:@"HomeNewVC" bundle:nil];
 //   MarketVC *marketsVC = [[MarketVC alloc] initWithNibName:@"MarketVC" bundle:nil];
    SuanliVC *marketsVC = [[SuanliVC alloc] initWithNibName:@"SuanliVC" bundle:nil];
    RecordVC *recodeVc = [[RecordVC alloc] initWithNibName:@"RecordVC" bundle:nil];
	MineNewVC *mineVC = [[MineNewVC alloc] initWithNibName:@"MineNewVC" bundle:nil];
	
    NSArray *vcArray = @[releaseVC,marketsVC,recodeVc, mineVC];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:vcArray.count];
    for (int i = 0; i < vcArray.count; i++) {
         BaseNavViewController*navigationVC = [[BaseNavViewController alloc] initWithRootViewController:vcArray[i]];
		
        [viewControllers addObject:navigationVC];
    }
    self.viewControllers = viewControllers;
}

- (void)createTabbar {
	
    //self.tabBar.backgroundColor = [UIColor darkGrayColor]; //UIColorFromHex(0x303030);
    // 按钮的非循环中状态图片数组
    NSArray *normalImgArray = @[@"home_un", @"shichang_un", @"licai_un",@"user_un"];
    NSArray *selectedImgArray = @[@"home", @"shichang", @"licai",@"user"];
    
    // 按钮的标题数组
    NSArray *titleArray = @[@"首页", @"算力",@"记录",@"我的"];
    UIColor *normalTitleColor =  [UIColor whiteColor]; //UIColorFromHex(0x808080);
    UIColor *selectedTitleColor = UIColorFromHex(0xCBAE86);
    //UI_ColorWithRGBA(204, 177, 126, 1.0); //UIColorFromHex(0xCCB17E);
    
    // 按钮的宽、高
    CGFloat itemWidth = KScreenWidth / (float)normalImgArray.count;
    CGFloat itemHeight = self.tabBar.frame.size.height;
	
    for (int i = 0; i < normalImgArray.count; i++) {
        CGRect itemFrame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        //使用自定义的按钮样式
        MainTabBarItem *item = [[MainTabBarItem alloc] initWithFrame:itemFrame
                                                     normalImageName:normalImgArray[i]
                                                   selectedImageNemd:selectedImgArray[i]
                                                     normalFontColor:normalTitleColor
                                                   selectedFontColor:selectedTitleColor
                                                               title:titleArray[i]];
       // item.backgroundColor = UIColorFromHex(0x020919);
        item.backgroundColor = [UIColor clearColor];
        //[UIColor darkGrayColor];
        item.tag = i;
        item.isSelected = NO;
        if (i == self.selectedIndex) {
            item.isSelected = YES;
            selectedItem = item;
        }
		
		[item addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
		
        [self.tabBar addSubview:item];
    }
}

#pragma mark -
#pragma mark Event Response
//设置是否选中
- (void)selectAction:(MainTabBarItem *)item
{
    NSArray *subViews = self.tabBar.subviews;
    for (UIView *view in subViews) {
        //此函数能获取该字符串指代的类
        Class cla = NSClassFromString(@"UITabBarButton");
        //判断该视图的类型是否属于cla所指的类型
        if ([view isKindOfClass:cla]) {
            [view removeFromSuperview];
        }
    }
    if (item != selectedItem)
    {
        item.isSelected = YES;
        selectedItem.isSelected = NO;
        selectedItem = item;
        //跳转至对应的控制器
        self.selectedIndex = item.tag;
    }
}

/**<模块跳转识别*/
- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex !=_selectIndex) {
        _selectIndex = selectIndex;
    }
    self.selectedIndex = selectIndex;
}

@end
