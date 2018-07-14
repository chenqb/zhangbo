//
//  CBDiscoveryViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBDiscoveryViewController.h"
#import "CBConst.h"
#import "UIColor+ColorChange.h"

@interface CBDiscoveryViewController ()

@end

@implementation CBDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
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
