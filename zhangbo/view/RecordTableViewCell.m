//
//  RecordTableViewCell.m
//  zhangbo
//
//  Created by 陈权斌 on 2018/7/2.
//  Copyright © 2018年 陈权斌. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "Masonry.h"
#import "UIColor+ColorChange.h"
#import "CBConst.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UILabel *dateLbl = [[UILabel alloc] init];
        [dateLbl setTextColor:[UIColor colorWithHexString:@"505050"]];//848484
        [dateLbl setFont:[UIFont systemFontOfSize:12]];
        self.dateLbl = dateLbl;
        [self addSubview:dateLbl];
        [dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15);
//            make.right.equalTo(self.mas_right).with.offset(15);
            make.width.mas_equalTo(150);
            make.top.equalTo(self.mas_top).with.offset(10);
            make.height.mas_equalTo(15);
        }];
        
        UILabel *descLbl = [[UILabel alloc] init];
        [descLbl setTextColor:[UIColor colorWithHexString:@"555555"]];//
        [descLbl setFont:[UIFont systemFontOfSize:16]];
        [descLbl setTextAlignment:NSTextAlignmentRight];
        self.descLbl = descLbl;
        [self addSubview:descLbl];
        [descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLbl.mas_right).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.top.equalTo(self.mas_top).with.offset(10);
            make.height.mas_equalTo(20);
        }];
        
        UIView *containerView = [[UIView alloc] init];
    	[self addSubview:containerView];
        [containerView setBackgroundColor:[UIColor whiteColor]];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dateLbl.mas_left).with.offset(15);
            make.right.mas_equalTo(self.mas_right).with.offset(-20);
            make.top.mas_equalTo(dateLbl.mas_bottom).with.offset(15);
            make.height.mas_equalTo(60);
        }];
        
        
        UIImageView *channelImg = [[UIImageView alloc] init];
        self.channelImg = channelImg;
        [self addSubview:channelImg];
        [channelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView.mas_left).with.offset(10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(containerView.mas_top).with.offset(15);
        }];
        
        UILabel *channelLbl = [[UILabel alloc] init];
        [channelLbl setTextColor:[UIColor blackColor]];
        self.channeLbl = channelLbl;
        [self addSubview:channelLbl];
        [channelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(channelImg);
            make.height.equalTo(channelImg);
            make.left.equalTo(channelImg.mas_right).with.offset(10);
            make.width.mas_equalTo(60);
        }];
        
    
        UILabel *amountlLbl = [[UILabel alloc] init];
        [amountlLbl setTextColor:[UIColor blackColor]];
        [amountlLbl setFont:[UIFont boldSystemFontOfSize:16]];
        [amountlLbl setTextAlignment:NSTextAlignmentRight];
        self.amountLbl = amountlLbl;
        [self addSubview:amountlLbl];
        [amountlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(channelImg);
            make.height.equalTo(channelImg);
            make.right.equalTo(self.mas_right).with.offset(-40);
            make.width.mas_equalTo(60);
        }];
        
    }
    return self;
}

@end
