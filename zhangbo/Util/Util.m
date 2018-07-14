//
//  Util.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/7.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "Util.h"

@implementation Util

+(NSString *)getDateStringFromDate:(NSDate *)date{
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSWeekdayCalendarUnit  fromDate:date];
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    NSInteger week =[components weekday]-1;
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4ld年%2ld月%ld日 %@",year,month,day,[arrWeek objectAtIndex:week]];
    //格式在这里拼装
    return nsDateString;
}
@end
