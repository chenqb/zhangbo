//
//  CBContactSelectViewController.h
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/5.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBNewItemViewController.h"

@interface CBContactSelectViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) id<ContactSelectDelegate> contactSelectDelegate;

@end
