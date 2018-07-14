//
//  DBManager.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/6.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "DBManager.h"
#import "Contact+CoreDataClass.h"
#import "Contact+CoreDataProperties.h"
#import "Record+CoreDataClass.h"
#import "BMChineseSort.h"
#import "Record+CoreDataProperties.h"

static id _instance;

@implementation DBManager

- (void)insertContactWithName:(NSString *)name{
    Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    contact.name = name;
    contact.totalAmount = 0;
    [self.appDelegate saveContext];
}


- (NSArray *)queryContactWithName:(NSString *)name{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                           error:nil];
    return resultArray;
}

- (NSArray *)queryAllContact{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                           error:nil];
    return resultArray;
}
-(void)deleteContactWithName:(NSString *)name{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    ///创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    //            [request setEntity:entity];
    
    ///创建条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [request setPredicate:predicate];
    
    ///获取符合条件的结果
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                           error:nil];
    if (resultArray.count>0) {
        for (Contact *contact in resultArray) {
            ///删除实体
            [self.appDelegate.persistentContainer.viewContext deleteObject:contact];
            NSLog(@"delete contact name:%@", contact.name);
            break;
        }
        [self.appDelegate saveContext];
        ///保存结果并且打印
    }
    //级联删除记录
    [self deleteRecordsWithName:name];
    
}


- (void)insertRecordWithName:(NSString *)name andDate:(NSDate *)date andAmount:(int)amount andChannel:(int)channel andDesc:(NSString *)desc{
    Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    record.name = name;
    record.amount = amount;
    record.channel = channel;
    record.date = date;
    record.desc = desc;
    [self.appDelegate saveContext];
    [self updateTotalAmountForContact:name];
}

-(void)deleteRecordsWithName:(NSString *)name{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record"
                                              inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    ///创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    //    [request setEntity:entity];
    
    ///创建条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [request setPredicate:predicate];
    
    ///获取符合条件的结果
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                           error:nil];
    if (resultArray.count>0) {
        for (Record *record in resultArray) {
            ///删除实体
            [self.appDelegate.persistentContainer.viewContext deleteObject:record];
            NSLog(@"delete record name:%@", record.name);
        }
    }
    [self.appDelegate saveContext];
        ///保存结果并且打印
}

- (void)deleteRecordWithName:(NSString *)name andId:(NSManagedObjectID *)mID{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record"
                                              inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    ///创建请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
//    [request setEntity:entity];

    ///创建条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [request setPredicate:predicate];
    
    ///获取符合条件的结果
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                           error:nil];
    if (resultArray.count>0) {
        for (Record *record in resultArray) {
            ///删除实体
            NSManagedObjectID *cur_mID = [record objectID];
            if (cur_mID == mID){
                [self.appDelegate.persistentContainer.viewContext deleteObject:record];
                NSLog(@"delete record name:%@", record.name);
                break;
            }
        }
        [self.appDelegate saveContext];
        ///保存结果并且打印
    }
    [self updateTotalAmountForContact:name];
    
}

- (void)updateTotalAmountForContact:(NSString *)name{
    NSArray *array = [self queryRecordWithName:name];
    int totalAmount = 0;
    for(Record *record in array){
        totalAmount = totalAmount + record.amount;
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                        error:nil];
    if(resultArray.count > 0){
    	for (Contact *contact in resultArray){
            contact.totalAmount = totalAmount;
		}
        [self.appDelegate saveContext];
    }
    
}

- (void)editRecordWithId:(NSManagedObjectID *)mID{
    
}

- (NSArray *)queryRecordWithName:(NSString *)name{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sort = [NSSortDescriptor  sortDescriptorWithKey:@"date" ascending:NO];
    [request setEntity:entity];
    [request setPredicate:predicate];
    //设置查找请求的排序描述器
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSArray *resultArray = [self.appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                           error:nil];
    return resultArray;
}

    

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[self alloc]init];
    }
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}


 -(instancetype)init{
     if(self = [super init]){
         self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     }
     return self;
 }
-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}


@end
