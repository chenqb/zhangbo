//
//  CBStatisticsViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBStatisticsViewController.h"
#import "CBConst.h"
#import "RecordTableViewCell.h"

@interface CBStatisticsViewController ()

@property (nonatomic,weak) UISegmentedControl *segment;//类别
@property(nonatomic, weak) UITableView *recordTableView;//绿色view
@property(nonatomic)  NSMutableArray *dataList;

@end

@implementation CBStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:kGrayColor];
    
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"借入",@"借出"] ];
    [segment setSelectedSegmentIndex:0];
    [segment setTintColor:[UIColor colorWithHexString:kThemeColor]];
    segment.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-120, 26, 240, 34);//设置segment
    
	self.segment = segment;
    [self.view addSubview:self.segment];
    
    

    
//    self.tabBarItem.title=@"统计";
//    self.tabBarItem.image=[UIImage imageNamed:@"statistics"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"RecodeTableVeiwCell";
    
    UITableViewCell *cell = nil;
    return cell;
}

- (NSMutableArray *)dataList{
    if(_dataList == nil){
        _dataList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataList;
            
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
