//
//  CBTextField.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/8.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "CBTextField.h"

@implementation CBTextField


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
