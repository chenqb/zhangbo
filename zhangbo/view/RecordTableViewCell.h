//
//  RecordTableViewCell.h
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/2.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property(nonatomic, weak) UILabel *dateLbl;
@property(nonatomic ,weak) UIImageView *channelImg;
@property(nonatomic, weak) UILabel *channeLbl;
@property(nonatomic, weak) UILabel *amountLbl;
@property(nonatomic, weak) UILabel *descLbl;


@end
