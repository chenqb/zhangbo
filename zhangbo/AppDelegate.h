//
//  AppDelegate.h
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

