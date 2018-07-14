//
//  CBContactViewController.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBContactViewController.h"
#import "CBConst.h"
#import "UIColor+ColorChange.h"
#import "CBContactDetailViewController.h"
#import "Contact+CoreDataClass.h"
#import "Contact+CoreDataProperties.h"
#import "BMChineseSort.h"
#import <MBProgressHUD.h>
#import "DBManager.h"

@interface CBContactViewController ()

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *contactList;
@property(nonatomic, strong) NSMutableArray *letterResultArr;
@property(nonatomic,strong) NSMutableArray *indexArray;

@end

@implementation CBContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [rightBtn setBackgroundImage: [UIImage imageNamed:@"add"]forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.titleLabel.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.view.backgroundColor=[UIColor colorWithHexString:kGrayColor];

    
    
    ///打印查询结果
    
	[self refreshDataList];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-100) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    tableView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    [self.view addSubview:self.tableView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRecordChangedNotification) name:@"kRecordChangedAddNotification" object:nil];

}

-(void)receiveRecordChangedNotification{
    [self refreshDataList];
    [self.tableView reloadData];
}

- (void) refreshDataList{
    NSArray *resultArray =  [[DBManager sharedInstance] queryAllContact];
    [self.contactList  removeAllObjects];
    [self.indexArray removeAllObjects];
    [self.letterResultArr removeAllObjects];
    [self.contactList addObjectsFromArray:resultArray];
    self.indexArray = [BMChineseSort IndexWithArray:self.contactList Key:@"name"];
    self.letterResultArr = [BMChineseSort sortObjectArray:self.contactList Key:@"name"];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.indexArray objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ContactTableVeiwCell";
    Contact * contact = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",contact.totalAmount];
	cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:18];
    if(contact.totalAmount > 0) {
        cell.detailTextLabel.textColor =  [UIColor colorWithHexString:kGreenColor];
    }else if (contact.totalAmount < 0){
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:kRedColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Contact *contact = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CBContactDetailViewController *detailVC = [[CBContactDetailViewController alloc] init];
    
    detailVC.name = contact.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
*/

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *confirmVC = [UIAlertController alertControllerWithTitle:@"确认删除?" message:@"删除联系人的同时也会删除相关的交易记录"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ///先读取这个类 这里有点像字典里面根据 key 查找 value 的意思
            Contact *contact = [[self.letterResultArr objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
            NSArray *resultArray = [[DBManager sharedInstance]queryContactWithName:contact.name];
            ///打印查询结果
            for (Contact *item in resultArray) {
                NSLog(@"[查询 result] name:%@ totalAmout:%d",item.name,item.totalAmount);
            }

            
        }];
        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            Contact *selectedContact = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            long num = [[self.letterResultArr objectAtIndex:indexPath.section] count];
            [[DBManager sharedInstance] deleteContactWithName:selectedContact.name];
            [self refreshDataList];
            if(num == 1){
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            
            
        }];
        
        [confirmVC addAction:ac1];
        [confirmVC addAction:ac2];
        [self presentViewController:confirmVC animated:YES completion:^{
            
        }];
        
    }];
    return @[action2,action1];
}

- (void)rightBtnClicked{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"新建联系人" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    

    //增加确定按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取第1个输入框；
        
        UITextField *userNameTextField = alertController.textFields.firstObject;
        
        NSLog(@"name = %@",userNameTextField.text);
        
        if( [userNameTextField.text isEqualToString:@""]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"姓名输入非法！";
            hud.label.textColor  = [UIColor whiteColor];
            hud.opaque = 0.75;
            hud.color = [UIColor blackColor];
        	[hud hideAnimated:YES afterDelay:1.5];
            return;
        }
        DBManager *dbMgr = [DBManager sharedInstance];
        [dbMgr insertContactWithName:userNameTextField.text];
        NSLog(@"right btn clicked");
        [self refreshDataList];
        [self.tableView reloadData];
        
    }]];
    
    
    
    //定义第一个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入联系人名称";
        
        textField.secureTextEntry = NO;
        
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
    

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
