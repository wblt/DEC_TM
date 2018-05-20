//
//  MyFriendsViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "FriendListTabCell.h"
#import "FriendInfoModel.h"
static NSString *Identifier = @"cell";

@interface MyFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;

@end

@implementation MyFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"我的好友";
    self.data = [NSMutableArray array];
    [self setup];
    [self requestData];
}
// 重新获取数据
- (void)refreshData {
    
    [self.data removeAllObjects];
    [self requestData];
    
}

- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_MY_FRIENDS];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"我的好友" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
        if (pd.count == 0) {
            [self showImagePage:YES withIsError:NO];
            return;
        }
        for (NSDictionary *dic in pd) {
            FriendInfoModel *model = [FriendInfoModel mj_objectWithKeyValues:dic];
            [self.data addObject:model];
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)setup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      [self.tableView registerNib:[UINib nibWithNibName:@"FriendListTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
}

# pragma mark tableView delegate dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
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
    FriendListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.data[indexPath.row];
    
    
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
