//
//  CBContactDetailViewController.h
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/3.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBNewItemViewController.h"

@interface CBContactDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSString *name;

@end
