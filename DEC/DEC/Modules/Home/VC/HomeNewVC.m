//
//  HomeNewVC.m
//  DEC
//
//  Created by wy on 2018/5/26.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "HomeNewVC.h"
#import "AAChartKit.h"
#import "MoneyTransferVC.h"
#import "ReceiveAddressViewController.h"
#import "PowerCGVC.h"


@interface HomeNewVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
@property (weak, nonatomic) IBOutlet UIView *chartBgView1;


@property (nonatomic,strong)AAChartView *aaChartView;
@property (nonatomic,strong)NSMutableArray *xArray;
@property (nonatomic,strong)NSMutableArray *valueArray;

// 释放k线
@property (nonatomic,strong)AAChartView *aaChartView1;
@property (nonatomic,strong)NSMutableArray *xArray1;
@property (nonatomic,strong)NSMutableArray *valueArray1;

@end

@implementation HomeNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	//获取与当前设备匹配的启动图片名称
	if (screenHeight == 480){ //4，4S
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS56_320x480pt"]];
	}
	else if (screenHeight == 568){ //5, 5C, 5S, iPod
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS56_320x568pt"]];
	}
	else if (screenHeight == 667){ //6, 6S
		
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS89_375x667pt"]];
	}
	else if (screenHeight == 736){ // 6Plus, 6SPlus
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhonePortraitiOS89_414x736pt"]];
	}else if (screenHeight == 812){
		self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_tt_bg 2iPhoneXPortraitiOS11_375x812pt"]];
	}
	
    self.navigationItem.title = @"释放";
    self.xArray = [NSMutableArray array];
    self.valueArray = [NSMutableArray array];
    self.xArray1 = [NSMutableArray array];
    self.valueArray1 = [NSMutableArray array];
    
    [self setup];
    [self addChartView];
    [self addChartView1];
    [self addViewTap];
    [self requesKData];
    [self requesKKData];
}

- (void)setup {
    UILabel *tipsLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, KScreenWidth, 20)];
    tipsLab1.text = @"■ 日线走势图";
    tipsLab1.textColor = UIColorFromHex(0xCBAE86);
    tipsLab1.textAlignment = NSTextAlignmentCenter;
    tipsLab1.font = Font_12;
    [self.chartBgView addSubview:tipsLab1];
 
    UILabel *tipsLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, KScreenWidth, 20)];
    tipsLab2.text = @"■ 算力释放报表";
    tipsLab2.textColor = UIColorFromHex(0xCBAE86);
    tipsLab2.textAlignment = NSTextAlignmentCenter;
    tipsLab2.font = Font_12;
    [self.chartBgView1 addSubview:tipsLab2];
    
}

- (void)requesKData {
    
    [self.xArray removeAllObjects];
    [self.valueArray removeAllObjects];
    RequestParams *params = [[RequestParams alloc] initWithParams:API_depth];
    [params addParameter:@"TYPE" value:@"0"];
    [params addParameter:@"NUM" value:@"7"];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
        if (pd.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"暂无k线数据"];
            return;
        }
        for (NSDictionary *dic in pd) {
            NSString *str = dic[@"DEAL_TIME"];
            [self.xArray addObject:[str substringWithRange:NSMakeRange(5, 5 )]];
            [self.valueArray addObject:dic[@"BUSINESS_PRICE"]];
        }
        self.xArray =  (NSMutableArray *)[[self.xArray reverseObjectEnumerator] allObjects];
        self.valueArray =  (NSMutableArray *)[[self.valueArray reverseObjectEnumerator] allObjects];
        AAMarker *marker = AAObject(AAMarker)
        .fillColorSet(@"#FFFFFF");
        
        AAChartModel *aaChartModel= AAObject(AAChartModel)
        .chartTypeSet(AAChartTypeLine)//设置图表的类型
        .backgroundColorSet(@"#020919")
        .symbolSet(AAChartSymbolTypeCircle)
        .titleSet(@"")//设置图表标题
        .subtitleSet(@"单位¥")//设置图表副标题
		.subtitleFontColorSet(@"#CBAE86")
        .subtitleFontSizeSet(@13)
        .subtitleAlignSet(AAChartSubtitleAlignTypeRight)
        .categoriesSet(self.xArray)//图表横轴的内容
        .yAxisTitleSet(@"")//设置图表 y 轴的单位
        .dataLabelEnabledSet(YES)
        .yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
        .yAxisMaxSet(@10)
        .yAxisMinSet(@0)
        .yAxisLabelsFontColorSet(@"#CBAE86")
        .xAxisLabelsFontColorSet(@"#CBAE86")
		.dataLabelFontColorSet(@"#CBAE86")
        .legendEnabledSet(NO)
        .seriesSet(@[
                     AAObject(AASeriesElement)
                     .nameSet(@"走势图")
                     .colorSet(@"#CBAE86")
                     .negativeColorSet(@"#AFAg01")
                     .dataSet(self.valueArray)
                     .markerSet(marker),
                     ])
        ;
        
        [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}


- (void)addChartView {
    CGFloat chartViewWidth  = KScreenWidth;
    CGFloat chartViewHeight = 200;
    self.aaChartView = [[AAChartView alloc]init];
    
    self.aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    ////禁用 AAChartView 滚动效果(默认不禁用)
    self.aaChartView.scrollEnabled = NO;
    [self.chartBgView addSubview:self.aaChartView];
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    
    AAMarker *marker = AAObject(AAMarker)
    .fillColorSet(@"#FFFFFF");
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeLine)//设置图表的类型
    .backgroundColorSet(@"#020919")
    .symbolSet(AAChartSymbolTypeCircle)
    .titleSet(@"")//设置图表标题
    .subtitleSet(@"单位¥")//设置图表副标题
	.subtitleFontColorSet(@"#CBAE86")
    .subtitleFontSizeSet(@13)
    .subtitleAlignSet(AAChartSubtitleAlignTypeRight)
    .categoriesSet(@[@"4.22",@"4.23",@"4.24",@"4.25", @"4.26",@"4.27",@"4.28"])//图表横轴的内容
    .yAxisTitleSet(@"")//设置图表 y 轴的单位
    .dataLabelEnabledSet(YES)
    .yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
    .yAxisMaxSet(@10)
    .yAxisMinSet(@0)
    .yAxisLabelsFontColorSet(@"#CBAE86")
    .xAxisLabelsFontColorSet(@"#CBAE86")
	.dataLabelFontColorSet(@"#CBAE86")
	.legendEnabledSet(NO)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"走势图")
                 .colorSet(@"#CBAE86")
                 .negativeColorSet(@"#CBAE86")
                 //.dataSet(@[@1.0, @3.9, @2.5, @9, @4, @8, @2])
                 .markerSet(marker),
                 ])
    ;
    [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
}

- (void)requesKKData {
    
    [self.xArray1 removeAllObjects];
    [self.valueArray1 removeAllObjects];
    RequestParams *params = [[RequestParams alloc] initWithParams:API_releaseDepth];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
 //   [params addParameter:@"TYPE" value:self.TYPE];
 //   [params addParameter:@"NUM" value:@"7"];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
        if (pd.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"暂无k线数据"];
            return;
        }
        for (NSDictionary *dic in pd) {
            NSString *str = dic[@"CREATE_TIME"];
            [self.xArray1 addObject:[str substringWithRange:NSMakeRange(5, 5 )]];
            [self.valueArray1 addObject:dic[@"CALCULATE_MONEY"]];
        }
        self.xArray1 =  (NSMutableArray *)[[self.xArray reverseObjectEnumerator] allObjects];
        self.valueArray1 =  (NSMutableArray *)[[self.valueArray reverseObjectEnumerator] allObjects];
        AAMarker *marker = AAObject(AAMarker)
        .fillColorSet(@"#FFFFFF");
        
        AAChartModel *aaChartModel= AAObject(AAChartModel)
        .chartTypeSet(AAChartTypeLine)//设置图表的类型
        .backgroundColorSet(@"#020919")
        .symbolSet(AAChartSymbolTypeCircle)
        .titleSet(@"")//设置图表标题
        .subtitleFontSizeSet(@13)
        .subtitleAlignSet(AAChartSubtitleAlignTypeRight)
        .subtitleFontColorSet(@"#FFFFFF")
        .categoriesSet(self.xArray)//图表横轴的内容
        .yAxisTitleSet(@"")//设置图表 y 轴的单位
        .dataLabelEnabledSet(YES)
        .yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
        .yAxisMaxSet(@10)
        .yAxisMinSet(@0)
        .yAxisLabelsFontColorSet(@"#CBAE86")
        .xAxisLabelsFontColorSet(@"#CBAE86")
		.dataLabelFontColorSet(@"#CBAE86")
        .legendEnabledSet(NO)
        .seriesSet(@[
                     AAObject(AASeriesElement)
                     .nameSet(@"算力释放报表")
                     .colorSet(@"#CBAE86")
                     .negativeColorSet(@"#CBAE86")
                     .dataSet(self.valueArray)
                     .markerSet(marker),
                     ])
        ;
        
        [self.aaChartView1 aa_drawChartWithChartModel:aaChartModel];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}


- (void)addChartView1 {
    CGFloat chartViewWidth  = KScreenWidth;
    CGFloat chartViewHeight = 200;
    self.aaChartView1 = [[AAChartView alloc]init];
    
    self.aaChartView1.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    ////禁用 AAChartView 滚动效果(默认不禁用)
    self.aaChartView1.scrollEnabled = NO;
    [self.chartBgView1 addSubview:self.aaChartView1];
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView1.isClearBackgroundColor = YES;
    
    AAMarker *marker = AAObject(AAMarker)
    .fillColorSet(@"#FFFFFF");
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeLine)//设置图表的类型
    .backgroundColorSet(@"#020919")
    .symbolSet(AAChartSymbolTypeCircle)
    .titleSet(@"")//设置图表标题
    .subtitleFontSizeSet(@13)
    .subtitleAlignSet(AAChartSubtitleAlignTypeRight)
    .subtitleFontColorSet(@"#FFFFFF")
    .categoriesSet(@[@"4.22",@"4.23",@"4.24",@"4.25", @"4.26",@"4.27",@"4.28"])//图表横轴的内容
    .yAxisTitleSet(@"")//设置图表 y 轴的单位
    .dataLabelEnabledSet(YES)
    .yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
    .yAxisMaxSet(@10)
    .yAxisMinSet(@0)
    .yAxisLabelsFontColorSet(@"#CBAE86")
    .xAxisLabelsFontColorSet(@"#CBAE86")
	.dataLabelFontColorSet(@"#CBAE86")
	.legendEnabledSet(NO)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"走势图")
                 .colorSet(@"#CBAE86")
                 .negativeColorSet(@"#CBAE86")
                 //.dataSet(@[@1.0, @3.9, @2.5, @9, @4, @8, @2])
                 .markerSet(marker),
                 ]);
    [self.aaChartView1 aa_drawChartWithChartModel:aaChartModel];
}

- (void)addViewTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView1 addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView3 addGestureRecognizer:tap3];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 100:
        {
            MoneyTransferVC *vc = [[MoneyTransferVC alloc] initWithNibName:@"MoneyTransferVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 101:
        {
            ReceiveAddressViewController *vc = [[ReceiveAddressViewController alloc] initWithNibName:@"ReceiveAddressViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
        {
            PowerCGVC *vc = [[PowerCGVC alloc] initWithNibName:@"PowerCGVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
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
