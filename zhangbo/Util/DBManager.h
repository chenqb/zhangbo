//
//  DBManager.h
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/6.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface DBManager : NSObject

@property(nonatomic) AppDelegate *appDelegate;

+(instancetype) sharedInstance;

- (void)insertContactWithName:(NSString *)name;
- (void)deleteContactWithName:(NSString *)name;
- (NSArray *)queryAllContact;
- (NSArray *)queryContactWithName:(NSString *)name;


- (void)insertRecordWithName:(NSString *)name andDate:(NSDate *)date andAmount:(int)amount andChannel:(int)channel andDesc:(NSString *)desc;
- (void)deleteRecordWithName:(NSString *)name andId:(NSManagedObjectID *)mID;
- (void)editRecordWithId:(NSManagedObjectID *)mID;
// - (void)deleteRecordsWithName:(NSString *)name;
- (NSArray *)queryRecordWithName:(NSString *)name;
@end
