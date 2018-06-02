//
//  MineNewVC.m
//  DEC
//
//  Created by wy on 2018/5/26.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineNewVC.h"
#import "MindeInfoVC.h"
#import "SGQRCode.h"
#import "MindeInfoVC.h"
#import "ReceiveAddressViewController.h"
#import "ReleaseRecordViewController.h"
#import "SendChangeVC.h"
#import "PowerCGVC.h"
#import "DECExchangeVC.h"
#import "SettingVC.h"
#import "ReceiveAddressViewController.h"
#import "SetFuLiVC.h"
#import "InviteFriendsVC.h"
#import "MybuyOrderVC.h"
#import "WCQRCodeScanningVC.h"
#import "ExtractAppplyVC.h"
#import "ExtractRecordVC.h"

//首先导入头文件信息
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface MineNewVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *ipLab;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;
@property (weak, nonatomic) IBOutlet UIView *bgView7;
@property (weak, nonatomic) IBOutlet UIView *bgView8;
@property (weak, nonatomic) IBOutlet UIView *bgView9;
@property (weak, nonatomic) IBOutlet UILabel *suanliLab;
@property (weak, nonatomic) IBOutlet UILabel *decLab;
@property (weak, nonatomic) IBOutlet UILabel *lingqianLab;
@property (weak, nonatomic) IBOutlet UILabel *powerLab;

@end

@implementation MineNewVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    [self addViewTap];
    [self setup];
}

- (void)setup {
    UIImageView *saoyisaoImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    saoyisaoImgView.userInteractionEnabled = YES;
    saoyisaoImgView.image = [UIImage imageNamed:@"scan"];
    UIBarButtonItem *leftAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:saoyisaoImgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: leftAnotherButton,nil]];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saoyisaoAction)];
    [saoyisaoImgView addGestureRecognizer:leftTap];
}

- (void)saoyisaoAction {
    WCQRCodeScanningVC *vc = [[WCQRCodeScanningVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 获取首页数据
- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_HOMEPAGE];
    
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        NSDictionary *dic = data[@"pd"];
        UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dic];
        [[BeanManager shareInstace] setBean:model path:UserModelPath];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
       
        _suanliLab.text = [NSString stringWithFormat:@"%@",model.S_CURRENCY];
        _decLab.text = [NSString stringWithFormat:@"%@",model.QK_CURRENCY];
        _lingqianLab.text = model.D_CURRENCY;
        _powerLab.text = [NSString stringWithFormat:@"%@",model.W_ENERGY];
        _nameLab.text = model.NICK_NAME;
        
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
    
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    _suanliLab.text = [NSString stringWithFormat:@"%@",model.S_CURRENCY];
    _decLab.text = [NSString stringWithFormat:@"%@",model.QK_CURRENCY];
    _lingqianLab.text = model.D_CURRENCY;
    _powerLab.text = [NSString stringWithFormat:@"%@",model.W_ENERGY];
    _nameLab.text = model.NICK_NAME;
    _ipLab.text = [NSString stringWithFormat:@"登录IP %@",[self getIPAddress:YES]];
}


- (void)addViewTap {
    UITapGestureRecognizer *imgTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction)];
    _headImgView.userInteractionEnabled = YES;
    [_headImgView addGestureRecognizer:imgTap];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView2 addGestureRecognizer:tap2];

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView4 addGestureRecognizer:tap4];

    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView5 addGestureRecognizer:tap5];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView6 addGestureRecognizer:tap6];
    
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView7 addGestureRecognizer:tap7];
    
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView8 addGestureRecognizer:tap8];
    
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgView9 addGestureRecognizer:tap9];
}

- (void)imgTapAction {
    MindeInfoVC *vc = [[MindeInfoVC alloc] initWithNibName:@"MindeInfoVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 101:
        {
//            ReleaseRecordViewController *vc = [[ReleaseRecordViewController alloc] initWithNibName:@"ReleaseRecordViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
        {
//            DECExchangeVC *vc = [[DECExchangeVC alloc] initWithNibName:@"DECExchangeVC" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103:
        {
           
        }
            break;
        case 104:
        {
//            PowerCGVC *vc = [[PowerCGVC alloc] initWithNibName:@"PowerCGVC" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 105:
        {
            ReceiveAddressViewController *vc = [[ReceiveAddressViewController alloc] initWithNibName:@"ReceiveAddressViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 106:
        {
			InviteFriendsVC *vc = [[InviteFriendsVC alloc] initWithNibName:@"InviteFriendsVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
			
//			SendChangeVC *vc = [[SendChangeVC alloc] initWithNibName:@"SendChangeVC" bundle:nil];
//			[self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 107:
        {
            [SVProgressHUD showInfoWithStatus:@"开发中"];
//            ExtractAppplyVC *vc = [[ExtractAppplyVC alloc] initWithNibName:@"ExtractAppplyVC" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 108:
        {
            [SVProgressHUD showInfoWithStatus:@"开发中"];
            
//            ExtractRecordVC *vc = [[ExtractRecordVC alloc] initWithNibName:@"ExtractRecordVC" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 109:
        {
            SettingVC *vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
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
