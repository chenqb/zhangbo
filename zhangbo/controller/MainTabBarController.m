//
//  MainTabBarController.m
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 余钦 on 16/5/30.
//  Copyright © 2016年 yuqin. All rights reserved.
//

#import "MainTabBarController.h"
#import "CBContactViewController.h"
#import "CBStatisticsViewController.h"
#import "CBSettingsViewController.h"
#import "CBDiscoveryViewController.h"
#import "CBNewItemViewController.h"
#import "MainNavigationController.h"
#import "MainTabBar.h"


@interface MainTabBarController ()<MainTabBarDelegate>
@property(nonatomic, weak)MainTabBar *mainTabBar;
@property(nonatomic, strong)CBContactViewController *contactVC;
@property(nonatomic, strong)CBStatisticsViewController *statisticsVC;
@property(nonatomic, strong)CBDiscoveryViewController *discoveryVC;
@property(nonatomic, strong)CBSettingsViewController *settingsVC;
@end

@implementation MainTabBarController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self SetupMainTabBar];
    [self SetupAllControllers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)SetupMainTabBar{
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    [self.tabBar addSubview:mainTabBar];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    _mainTabBar = mainTabBar;
}

- (void)SetupAllControllers{
    NSArray *titles = @[@"联系人", @"统计", @"发现", @"设置"];
    NSArray *images = @[@"contact", @"statistics", @"discovery", @"settings"];
    NSArray *selectedImages =  @[@"contact_selected", @"statistics_selected", @"discovery_selected", @"settings_selected"];
    
    CBContactViewController *contactVC = [[CBContactViewController alloc] init];
    self.contactVC = contactVC;
    
    CBStatisticsViewController *statisticsVC  = [[CBStatisticsViewController alloc] init];
    self.statisticsVC = statisticsVC;
    
    CBDiscoveryViewController * discoveryVC = [[CBDiscoveryViewController alloc] init];
    self.discoveryVC = discoveryVC;
    
    CBSettingsViewController * settingsVC = [[CBSettingsViewController alloc] init];
    self.settingsVC = settingsVC;
    
    NSArray *viewControllers = @[contactVC, statisticsVC,discoveryVC,settingsVC];
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *childVc = viewControllers[i];
        [self SetupChildVc:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:nav];
}



#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    self.selectedIndex = toBtnTag;
}

- (void)tabBarClickWriteButton:(MainTabBar *)tabBar{
    CBNewItemViewController *newItemVC = [[CBNewItemViewController alloc] init];
//    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
    
    [self presentViewController:newItemVC animated:YES completion:nil];
}
@end
