//
//  MybuyOrderVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/21.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MybuyOrderVC.h"
#import "OrderModel.h"
#import "OrderListTabCell.h"
#import "OrderDetailsVC.h"

static NSString *Identifier = @"cell";

@interface MybuyOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,copy)NSString *QUERY_ID;//如果QUERY_ID = 0，则获取最新数据.
@property (nonatomic,copy)NSString *TYPE; //1：向下拉；QUERY_ID =0,该值没意义2：向上拉(必填)
@property (nonatomic,strong)OrderModel *currentModel;
@property (nonatomic,strong)NSString *orderType; // 订单类型 1 买单  2 卖单

@end

@implementation MybuyOrderVC

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_QUERY_ID = @"0";
	_TYPE = @"1";
	[self.data removeAllObjects];
	[self.tableView reloadData];
    if ([_orderType isEqualToString:@"1"]) {
        [self requetBuyData];
    }else {
        [self requetSellData];
    }
	
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"订单";
	self.data = [NSMutableArray array];
    
    _orderType = @"1";
    
	_QUERY_ID = @"0";
	_TYPE = @"1";
	[self setup];
}
- (IBAction)buyOrderAction:(id)sender {
    if (_buyBtn.selected) {
        return;
    }
    
    _buyBtn.selected = YES;
    _sellBtn.selected = NO;
    _lineView1.hidden = NO;
    _lineView2.hidden = YES;
    _orderType = @"1";
    [self refreshData];
}

- (IBAction)SellOrderAction:(id)sender {
    if (_sellBtn.selected) {
        return;
    }
    
    _sellBtn.selected = YES;
    _buyBtn.selected = NO;
    _lineView2.hidden = NO;
    _lineView1.hidden = YES;
    
    _orderType = @"2";
    [self refreshData];
}


- (void)refreshData {
	[self.data removeAllObjects];
	[self.tableView reloadData];
	_QUERY_ID = @"0";
	_TYPE = @"1";
    
    if ([_orderType isEqualToString:@"1"]) {
       [self requetBuyData];
    }else {
       [self requetSellData];
    }

}

- (void)requetBuyData {
	[super refreshData];
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_buyList];
	[params addParameter:@"QUERY_ID" value:_QUERY_ID];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	[params addParameter:@"TYPE" value:_TYPE];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSArray *pd = data[@"pd"];
		if (pd.count == 0 && [_QUERY_ID isEqualToString:@"0"]) {
			[self showImagePage:YES withIsError:NO];
			return;
		}
		for (NSDictionary *dic in pd) {
			OrderModel *model = [OrderModel mj_objectWithKeyValues:dic];
			[self.data addObject:model];
			if (pd.lastObject == dic) {
				_QUERY_ID = [NSString stringWithFormat:@"%@",model.TRADE_ID];
			}
		}
		[self.tableView reloadData];
		
	} failureBlock:^(NSError *error) {
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)requetSellData {
    [super refreshData];
    RequestParams *params = [[RequestParams alloc] initWithParams:API_sellList];
    [params addParameter:@"QUERY_ID" value:_QUERY_ID];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"TYPE" value:_TYPE];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
        if (pd.count == 0 && [_QUERY_ID isEqualToString:@"0"]) {
            [self showImagePage:YES withIsError:NO];
            return;
        }
        for (NSDictionary *dic in pd) {
            OrderModel *model = [OrderModel mj_objectWithKeyValues:dic];
            [self.data addObject:model];
            if (pd.lastObject == dic) {
                _QUERY_ID = [NSString stringWithFormat:@"%@",model.TRADE_ID];
            }
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}


- (void)setup {
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerNib:[UINib nibWithNibName:@"OrderListTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
	
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		// 进入刷新状态后会自动调用这个block
		_QUERY_ID = @"0";
		_TYPE = @"1";
        
		[self refreshData];
		
	}];
	
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		// 进入刷新状态后会自动调用这个 block
		_TYPE = @"2";
        
        if ([_orderType isEqualToString:@"1"]) {
            [self requetBuyData];
        }else {
            [self requetSellData];
        }
	}];
	

	
}

# pragma mark tableView delegate dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	OrderListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	ViewRadius(cell.contentView, 6);
	cell.order = self.data[indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	OrderDetailsVC *vc =[[OrderDetailsVC alloc] initWithNibName:@"OrderDetailsVC" bundle:nil];
	vc.type = _orderType;
	vc.model = self.data[indexPath.row];
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
