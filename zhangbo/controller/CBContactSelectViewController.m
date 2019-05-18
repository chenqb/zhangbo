//
//  CBContactSelectViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/5.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBContactSelectViewController.h"
#import "CBConst.h"
#import "UIColor+ColorChange.h"
#import "Contact+CoreDataClass.h"
#import "Masonry.h"
#import "Contact+CoreDataProperties.h"
#import "DBManager.h"
#import "BMChineseSort.h"

@interface CBContactSelectViewController ()

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic)  NSMutableArray *contactList;
@property(nonatomic, strong) NSMutableArray *letterResultArr;
@property(nonatomic,strong)NSMutableArray *indexArray;


@end

@implementation CBContactSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *superView = self.view;
    
    UIView *navView = [[UIView alloc] init];
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    navView.frame = CGRectMake(0, 0, self.view.frame.size.width, statusBarHeight+44);
    navView.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    [self.view addSubview:navView];
    
    UILabel *title = [[UILabel alloc] init];
    [title setFont:[UIFont systemFontOfSize:18]];
    title.textColor = [UIColor whiteColor];
    title.text = @"联系人";
    [navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(navView);
        make.centerX.mas_equalTo(navView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:[UIColor colorWithHexString:@"555555"] forState:UIControlStateNormal];
    [dismissBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [dismissBtn addTarget:self action:@selector(dismissBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(title);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(44);
        make.right.equalTo(navView).with.offset(-10);
    }];

    [self refreshData];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight+44, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)refreshData{
    NSArray *datalist = [[DBManager sharedInstance] queryAllContact];
    [self.contactList removeAllObjects];
    [self.contactList addObjectsFromArray:datalist];
    self.indexArray = [BMChineseSort IndexWithArray:self.contactList Key:@"name"];
    self.letterResultArr = [BMChineseSort sortObjectArray:self.contactList Key:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CBContactSelectTableVeiwCell";
    Contact * contact = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = contact.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",contact.totalAmount];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:^{
        Contact *contact = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.contactSelectDelegate passValue:contact.name];
    }];
}

- (void) dismissBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)contactList{
    if(_contactList==nil){
        _contactList = [[NSMutableArray alloc] init];
    }
    return _contactList;
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
