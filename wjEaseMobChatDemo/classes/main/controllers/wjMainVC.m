//
//  wjMainVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/2.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjMainVC.h"
#import "wjHistoryChatVC.h"
#import "wjContactsVC.h"
#import "wjMySettingsTableVC.h"

@interface wjMainVC ()

@end

@implementation wjMainVC

+ (void)initialize {
    // 显示颜色
    // 1.设置tabbar文字颜色
    [UITabBar appearance].tintColor = [UIColor colorWithRed:0 green:188/255.0f  blue:39/255.0f alpha:1.0f];
    // 2.设置导航栏背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_64"] forBarMetrics:UIBarMetricsDefault];
    // 3.设置导航栏的文字颜色
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : [UIColor whiteColor]
                           };
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    // 4.设置导航栏的item为白色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
}

// 在控制器实现此方式可以修改栏状态栏的颜色（在此位置是无效的，应该放置在此控制器的自控制器中有效->导航控制器
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildTabBarControllers:[[wjHistoryChatVC alloc] init] title:@"WeChat" normalImage:@"tabbar_mainframe" selectedImage:@"tabbar_mainframeHL"];
    wjContactsVC *wjContact = [[wjContactsVC alloc] init];
    [self addChildTabBarControllers:wjContact title:@"Contact" normalImage:@"tabbar_contacts" selectedImage:@"tabbar_contactsHL"];
    UIViewController *vc3 = [UIStoryboard storyboardWithName:@"wjMySettings" bundle:nil].instantiateInitialViewController;
    [self addChildTabBarControllers:vc3 title:@"MySettings" normalImage:@"tabbar_me" selectedImage:@"tabbar_meHL"];
}

// 在控制器实现此方式可以修改栏状态栏的颜色（在此位置是无效的，应该放置在此控制器的自控制器中有效->导航控制器）ios10之后的方式
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 5.设置状态栏的背景颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;    
}


- (void)addChildTabBarControllers:(UIViewController *)vc title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}


@end
