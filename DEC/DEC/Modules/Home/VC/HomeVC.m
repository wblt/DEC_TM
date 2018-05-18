//
//  HomeVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "HomeVC.h"
#import "NewsTabCell.h"
#import "NoticeModel.h"
#import "NewsDetailsViewController.h"

static NSString *Identifier = @"cell";

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.navigationItem.title = @"首页";
	self.data = [NSMutableArray array];
	[self setup];
	[self requestData];
}

- (void)setup {
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
	imgView.image = [UIImage imageNamed:@"personinfo_bg"];
	
	self.tableView.tableHeaderView = imgView;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerNib:[UINib nibWithNibName:@"NewsTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
	
	MJWeakSelf
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		// 进入刷新状态后会自动调用这个block
		
		[weakSelf.data removeAllObjects];
		[weakSelf.tableView reloadData];
		[weakSelf requestData];
	}];
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_NOTICE];
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"公告" successBlock:^(id data) {
		NSString *code = data[@"code"];
		[self.tableView.mj_header endRefreshing];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:@"message"];
			return ;
		}
		NSArray *pdAry = data[@"pd"];
		if (pdAry.count == 0) {
			[self showImagePage:YES withIsError:NO];
			return;
		}
		
		for (NSDictionary *dic in pdAry) {
			NoticeModel *model = [NoticeModel mj_objectWithKeyValues:dic];
			[self.data addObject:model];
		}
		[self.tableView reloadData];
	} failureBlock:^(NSError *error) {
		[self.tableView.mj_header endRefreshing];
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

# pragma mark tableView delegate dataSourse
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 85;
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
	NewsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.model = self.data[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NewsDetailsViewController *vc =[[NewsDetailsViewController alloc] initWithNibName:@"NewsDetailsViewController" bundle:nil];

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
