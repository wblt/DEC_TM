//
//  WelcomeVC.m
//  DEC
//
//  Created by yanghuan on 2018/5/18.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "WelcomeVC.h"
#import "LoginVC.h"
#import "RegistVC.h"


@interface WelcomeVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setup];
}

- (void)setup {
	ViewBorderRadius(_loginBtn, 6, 1, [UIColor whiteColor]);
	ViewBorderRadius(_registBtn, 6, 1, [UIColor redColor]);
}

- (IBAction)loginAction:(id)sender {
	
	LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registAction:(id)sender {
	RegistVC *vc = [[RegistVC alloc] initWithNibName:@"RegistVC" bundle:nil];
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
