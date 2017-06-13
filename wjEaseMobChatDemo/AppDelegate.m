//
//  AppDelegate.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/1.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "AppDelegate.h"
#import "wjLoginVC.h"
#import "wjMainVC.h"
#import "wjContactsVC.h"

@interface AppDelegate () <EMClientDelegate, EMContactManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 环信集成
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1174170601115833#wjchatdemo"];
    //    options.apnsCertName = @"istore_dev"; // 远程推送的证书
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 添加 （监听自动登录或在其他设备登录）
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    
    // 添加联系人管理的代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    
    
    // 窗口创建
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    wjLoginVC *vc = [[wjLoginVC alloc] init];
    wjMainVC *mainVC = [[wjMainVC alloc] init];
    // 检测是否有过登录，是否有开启自动登录
    if ([[EMClient sharedClient].options isAutoLogin]) {
        self.window.rootViewController = mainVC;
        
        // 显示联系人的badgeValue
        [self wjShowContactBadgeValue];
        
    } else {
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    return YES;
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    NSLog(@"123");
}

#pragma mark - 自动登录或在其他设备登录的 delegate
- (void)didAutoLoginWithError:(EMError *)aError {
    if (!aError) {
        wjLog(@"自动登录成功");
    } else {
        wjLog(@"自动登录失败");
    }
}

/*
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice {
    // 回到登录界面
    self.window.rootViewController = [[wjLoginVC alloc] init];
    // 给用户一个提醒
    [self wjShowAlertMessageToUserWithMessage:@"当前账号在其他设备登录\n\n如非本人操作请修改密码!" title:@"提醒"];
}

- (void)userAccountDidRemoveFromServer {
    
}




#pragma mark - 联系人管理的代理 EMContactManagerDelegate
/*!
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *  @param aUsername   用户B
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername {
    NSString *message = [aUsername stringByAppendingString:@"同意您的好友申请!"];
    [self wjShowAlertMessageToUserWithMessage:message title:@"好友请求的结果"];
}


/*!
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *  @param aUsername   用户B
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername {
    NSString *message = [aUsername stringByAppendingString:@"拒绝了您的好友请求!"];
    [self wjShowAlertMessageToUserWithMessage:message title:@"好友请求的结果"];
}


/*!
 *  用户B申请加A为好友后，用户A会收到这个回调
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage {
    NSLog(@"%@-%@", aUsername, aMessage);
    // 保存好友申请到数据库中
    [wjDBUtils wjSaveFriendRequestWithUserName:aUsername message:aMessage];
    // 显示tabbar的badgeValue
    [self wjShowContactBadgeValue];
    
}


#pragma mark - 公用方法

/**
 显示联系人的badgeValue
 */
- (void)wjShowContactBadgeValue {
    UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *contactNav = tabBarVC.childViewControllers[1];
    // 要获取 FriendRequest 的条数
    NSInteger requestCount = [wjDBUtils wjGetFriendRequestCount];
    contactNav.tabBarItem.badgeValue = requestCount ? [NSString stringWithFormat:@"%ld", requestCount] : nil;
    
    // 好友列表申请的headerView的小圆点提示
    wjContactsVC *contactVC = contactNav.childViewControllers.firstObject;
    [contactVC wjShowHeaderViewBadgeIfHaveRequest];
}

/**
 提醒框

 @param message 提醒内容
 @param title 提醒标题
 */
- (void)wjShowAlertMessageToUserWithMessage:(NSString *)message title:(NSString *)title {
    // 给用户一个提醒
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action];
    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}



@end
