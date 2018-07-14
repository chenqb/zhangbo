//
//  CBContactDetailViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/3.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBContactDetailViewController.h"
#import "Record+CoreDataClass.h"
#import "Record+CoreDataProperties.h"
#import "RecordTableViewCell.h"
#import "CBConst.h"
#import "UIColor+ColorChange.h"
#import "DBManager.h"
#import "Util.h"


@interface CBContactDetailViewController ()

@property(nonatomic, weak) UITableView *recordTableView;//绿色view
@property(nonatomic) NSMutableArray *recordList;
@end

@implementation CBContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    // Do any additional setup after loading the view.
    

    [self refreshData];
    
    UITableView *recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-100) style:UITableViewStylePlain];
    recordTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    recordTableView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    self.recordTableView = recordTableView;
    
    [self.view addSubview:self.recordTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRecordChangedNotification) name:@"kRecordChangedAddNotification" object:nil];
}

-(void)receiveRecordChangedNotification{
    [self refreshData];
    [self.recordTableView reloadData];
}

- (void)refreshData{
    NSArray *array = [[DBManager sharedInstance]queryRecordWithName:self.name];
    [self.recordList removeAllObjects];
    [self.recordList addObjectsFromArray:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"RecodeTableVeiwCell";
    Record *record = [self.recordList objectAtIndex:indexPath.row];
    
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    [cell.dateLbl setText:[Util getDateStringFromDate:record.date]];
    UIImage *img;
    NSString *channelStr = @"";
    switch (record.channel) {
        case 1:
        	img = [UIImage imageNamed:@"alipay"];
            channelStr = @"支付宝";
            break;
        case 2:
            img = [UIImage imageNamed:@"wechat"];
            channelStr = @"微信";
        	break;
        case 3:
            img = [UIImage imageNamed:@"bankcard"];
            channelStr = @"银行卡";
            break;
        case 4:
            img = [UIImage imageNamed:@"cash"];
            channelStr = @"现金";
        default:
            break;
    };
    cell.dateLbl.text = [Util getDateStringFromDate:record.date];
    cell.descLbl.text = record.desc;
    [cell.channelImg setImage:img];
    [cell.channeLbl setText:channelStr];
    [cell.amountLbl setText:[NSString stringWithFormat:@"%d",record.amount]];
    if(record.amount < 0){
        cell.amountLbl.textColor = [UIColor colorWithHexString:kRedColor];
    }else {
        cell.amountLbl.textColor = [UIColor colorWithHexString:kGreenColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *confirmVC = [UIAlertController alertControllerWithTitle:@"确认删除?" message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消删除");
        }];
        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            Record *record = [self.recordList objectAtIndex:indexPath.row];
            NSManagedObjectID *cur_mID = [record objectID];
            [[DBManager sharedInstance] deleteRecordWithName:self.name andId:cur_mID];
            [self refreshData];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRecordChangedAddNotification" object:nil];
            
        }];
        
        [confirmVC addAction:ac1];
        [confirmVC addAction:ac2];
        [self presentViewController:confirmVC animated:YES completion:^{
            
        }];
        
    }];
    return @[action2,action1];
}

- (NSMutableArray *)recordList{
    if(_recordList == nil){
        _recordList = [NSMutableArray arrayWithCapacity:0];
    }
    return _recordList;
    
}

- (NSString *)name{
    if(_name == nil){
        _name = @"";
    }
    return _name;
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
