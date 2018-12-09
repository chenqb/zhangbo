//
//  CBSettingsViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBSettingsViewController.h"
#import "UIColor+ColorChange.h"
#import "CBConst.h"

@interface CBSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UITableView *tableview;

@end

@implementation CBSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-100) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    tableView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    self.tableview = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 1;
    if(section == 1) return 1;
    if(section == 2) return 2;
    else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor =[UIColor clearColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor =[UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SettingsTableVeiwCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"444444"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if(indexPath.section == 0 && indexPath.row ==0 ){
        cell.textLabel.text = @"推荐账簿大师给好友";
    }
    
    if (indexPath.section == 1 && indexPath.row == 0){
         cell.textLabel.text = @"iCloud备份";
    }
    if (indexPath.section == 2 && indexPath.row == 0){
        cell.textLabel.text = @"去App Store给我们评分";
    }
    if (indexPath.section == 2 && indexPath.row == 1){
        cell.textLabel.text = @"关于账簿大师";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row ==0 ){
        NSLog(@"0 0 推荐给朋友");
        NSString *textToShare = @"share string";
    	UIImage *imageToShare = [UIImage imageNamed:@"contact_selected"];
        NSURL *urlToShare = [NSURL URLWithString:@"http://www.163.com"];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare,urlToShare,imageToShare] applicationActivities:nil];
        
        // 根据需要指定不需要分享的平台
        activityVC.excludedActivityTypes = @[UIActivityTypePostToTwitter,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeSaveToCameraRoll];
        // >=iOS8.0系统用这个方法
        activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
            if (completed) { // 确定分享
            }else {
            }
        };
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
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
