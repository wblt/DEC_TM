//
//  MarketVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/18.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MarketVC.h"
#import "AAChartKit.h"
#import "MarketListVC.h"
#import "SellVC.h"
#import "MybuyOrderVC.h"
#import "MySellOrderVC.h"


@interface MarketVC ()
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;

@property (nonatomic,strong)AAChartView *aaChartView;
@property (nonatomic,strong)UIButton *dayBtn;
@property (nonatomic,strong)UIButton *weekBtn;
@property (nonatomic,strong)NSMutableArray *xArray;
@property (nonatomic,strong)NSMutableArray *valueArray;
@property (nonatomic,copy)NSString *TYPE; //k线类型

@end

@implementation MarketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"交易";
	self.edgesForExtendedLayout = UIRectEdgeTop;
	
	self.xArray = [NSMutableArray array];
	self.valueArray = [NSMutableArray array];
	self.TYPE = @"0";
	
	[self setup];
	[self addChartView];
	[self addViewTap];
	[self requesKData];
}

- (void)setup {
	self.dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.dayBtn.frame = CGRectMake(20, 0, 40, 30);
	[self.dayBtn setTitle:@"日线" forState:UIControlStateNormal];
	[self.dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.dayBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
	self.dayBtn.selected = YES;
	self.dayBtn.titleLabel.font = Font_13;
	[self.chartBgView addSubview:self.dayBtn];
	MJWeakSelf
	[self.dayBtn addTapBlock:^(UIButton *btn) {
		weakSelf.dayBtn.selected = YES;
		weakSelf.weekBtn.selected = NO;
		weakSelf.TYPE = @"0";
		[weakSelf requesKData];
	}];
	
	
	self.weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.weekBtn.frame = CGRectMake(70, 0, 40, 30);
	[self.weekBtn setTitle:@"周线" forState:UIControlStateNormal];
	[self.weekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.weekBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
	self.weekBtn.titleLabel.font = Font_13;
	self.weekBtn.selected = NO;
	[self.chartBgView addSubview:self.weekBtn];
	
	[self.weekBtn addTapBlock:^(UIButton *btn) {
		weakSelf.dayBtn.selected = NO;
		weakSelf.weekBtn.selected = YES;
		weakSelf.TYPE = @"1";
		[weakSelf requesKData];
	}];
}

- (void)requesKData {
	
	[self.xArray removeAllObjects];
	[self.valueArray removeAllObjects];
	RequestParams *params = [[RequestParams alloc] initWithParams:API_depth];
	[params addParameter:@"TYPE" value:self.TYPE];
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
		.subtitleFontSizeSet(@13)
		.subtitleAlignSet(AAChartSubtitleAlignTypeRight)
		.subtitleFontColorSet(@"#FFFFFF")
		.categoriesSet(self.xArray)//图表横轴的内容
		.yAxisTitleSet(@"")//设置图表 y 轴的单位
		.dataLabelEnabledSet(YES)
		.yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
		.yAxisMaxSet(@10)
		.yAxisMinSet(@0)
		.yAxisLabelsFontColorSet(@"#FFFFFF")
		.xAxisLabelsFontColorSet(@"#FFFFFF")
		.legendEnabledSet(NO)
		.seriesSet(@[
					 AAObject(AASeriesElement)
					 .nameSet(@"走势图")
					 .colorSet(@"#C0A225")
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
	
	self.aaChartView.frame = CGRectMake(0, 30, chartViewWidth, chartViewHeight);
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
	.subtitleFontSizeSet(@13)
	.subtitleAlignSet(AAChartSubtitleAlignTypeRight)
	.subtitleFontColorSet(@"#FFFFFF")
	.categoriesSet(@[@"4.22",@"4.23",@"4.24",@"4.25", @"4.26",@"4.27",@"4.28"])//图表横轴的内容
	.yAxisTitleSet(@"")//设置图表 y 轴的单位
	.dataLabelEnabledSet(YES)
	.yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
	.yAxisMaxSet(@10)
	.yAxisMinSet(@0)
	.yAxisLabelsFontColorSet(@"#FFFFFF")
	.xAxisLabelsFontColorSet(@"#FFFFFF")
	.seriesSet(@[
				 AAObject(AASeriesElement)
				 .nameSet(@"走势图")
				 .colorSet(@"#51B24D")
				 .negativeColorSet(@"#AFAg01")
				 //.dataSet(@[@1.0, @3.9, @2.5, @9, @4, @8, @2])
				 .markerSet(marker),
				 ])
	
	;
	[self.aaChartView aa_drawChartWithChartModel:aaChartModel];
	
}


- (void)addViewTap {
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	
	[_bgView1 addGestureRecognizer:tap1];
	
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	
	[_bgView2 addGestureRecognizer:tap2];
	
	UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	[_bgView3 addGestureRecognizer:tap3];
	
	UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	[_bgView4 addGestureRecognizer:tap4];
	
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
	
	switch (tap.view.tag) {
		case 100:
		{
			MarketListVC *vc = [[MarketListVC alloc] initWithNibName:@"MarketListVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 101:
		{
			SellVC *vc = [[SellVC alloc] initWithNibName:@"SellVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 102:
		{
			MybuyOrderVC *vc = [[MybuyOrderVC alloc] initWithNibName:@"MybuyOrderVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 103:
		{
			MySellOrderVC *vc = [[MySellOrderVC alloc] initWithNibName:@"MySellOrderVC" bundle:nil];
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
