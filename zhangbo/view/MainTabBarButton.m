//
//  MainTabBarButton.m
//  cmbfaeApp
//
//  Created by 余钦 on 16/4/7.
//  Copyright © 2016年 cmbfae Co.,Ltd. All rights reserved.
//

#import "MainTabBarButton.h"
#import "CBConst.h"
#import "UIColor+ColorChange.h"


//image ratio
#define TabBarButtonImageRatio 0.65


@implementation MainTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //只需要设置一次的放置在这里
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitleColor:[UIColor colorWithHexString:kThemeColor] forState:UIControlStateSelected];

        [self setTitleColor:[UIColor colorWithRed:117/255.0f green:117/255.0f blue:117/255.0f alpha:1.0] forState:UIControlStateNormal];

    }
    return self;
}


//重写该方法可以去除长按按钮时出现的高亮效果
- (void)setHighlighted:(BOOL)highlighted
{
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height*TabBarButtonImageRatio-5;
    
    return CGRectMake(0, 5, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height*TabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem
{
    _tabBarItem = tabBarItem;
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
}

@end
