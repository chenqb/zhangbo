//
//  CBNewItemViewController.h
//  zhangbo
//
//  Created by 陈权斌 on 2018/6/30.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ContactSelectDelegate

- (void)passValue:(NSString *)name;

@end

@interface CBNewItemViewController : UIViewController  <UITextFieldDelegate, ContactSelectDelegate>

@end
