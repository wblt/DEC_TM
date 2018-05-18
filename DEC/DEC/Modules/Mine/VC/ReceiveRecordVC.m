//
//  ReceiveRecordVC.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReceiveRecordVC.h"
#import "ReceiveRecordTabCell.h"
#import "RecordModel.h"

static NSString *Identifier = @"cell";

@interface ReceiveRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,copy)NSString *QUERY_ID;//如果QUERY_ID = 0，则获取最新数据.
@property (nonatomic,copy)NSString *TYPE; //1：向下拉；QUERY_ID =0,该值没意义2：向上拉(必填)
@end

@implementation ReceiveRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"接收记录";
	[self setup];
	self.data = [NSMutableArray array];
	_QUERY_ID = @"0";
	_TYPE = @"1";
	[self requestData];
}

- (void)refreshData {
	[self.data removeAllObjects];
	[self.tableView reloadData];
	[self requestData];
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_RECEIVEDETAIL];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	[params addParameter:@"QUERY_ID" value:_QUERY_ID];
	[params addParameter:@"TYPE" value:_TYPE];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"接收记录" successBlock:^(id data) {
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		NSString *code = data[@"code"];
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
			RecordModel *model = [RecordModel mj_objectWithKeyValues:dic];
			[self.data addObject:model];
			if (pd.lastObject == dic) {
				_QUERY_ID = [NSString stringWithFormat:@"%@",model.ID];
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
	[self.tableView registerNib:[UINib nibWithNibName:@"ReceiveRecordTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
	
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		// 进入刷新状态后会自动调用这个block
		_QUERY_ID = @"0";
		_TYPE = @"1";
		[self refreshData];
	}];
	
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		// 进入刷新状态后会自动调用这个 block
		_TYPE = @"2";
		[self requestData];
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
	return 115;
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
	ReceiveRecordTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	ViewRadius(cell.contentView, 6);
	cell.recceiveModel = self.data[indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
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
