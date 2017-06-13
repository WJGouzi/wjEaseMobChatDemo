//
//  wjLoginVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/2.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjLoginVC.h"
#import "wjMainVC.h"


@interface wjLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *wjUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *wjPwdTextField;

@end

@implementation wjLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}

- (IBAction)wjRegisterAction:(UIButton *)sender {
    // 同步的请求
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];
//    if (error==nil) {
//        NSLog(@"注册成功");
//    }
    
    NSString *wjUserName = self.wjUserTextField.text;
    NSString *wjPwd = self.wjPwdTextField.text;
    if (wjUserName.length == 0 || wjPwd.length == 0) {
        NSLog(@"用户名和账号名不能为空");
        return;
    } else {
        // 异步请求
        [[EMClient sharedClient] registerWithUsername:wjUserName password:wjPwd completion:^(NSString *aUsername, EMError *aError) {
            if (aError) {
                wjLog(@"error is %@", aError);
                wjLog(@"注册失败");
            } else {
                wjLog(@"注册成功");
            }
        }];
    }

}


- (IBAction)wjLoginAction:(UIButton *)sender {
    NSString *wjUserName = self.wjUserTextField.text;
    NSString *wjPwd = self.wjPwdTextField.text;
    if (wjUserName.length == 0 || wjPwd.length == 0) {
        NSLog(@"用户名和账号名不能为空");
        return;
    } else {
        // 执行登录的请求
        [[EMClient sharedClient] loginWithUsername:wjUserName password:wjPwd completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                wjLog(@"登录成功");
                // 开启自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                // 进入到主界面
                self.view.window.rootViewController = [[wjMainVC alloc] init];
            } else {
                wjLog(@"登录失败:%u", aError.code);
                if (aError.code == EMErrorUserAuthenticationFailed) {
                    wjLog(@"密码输入错误");
                }
            }
        }];
    }
}

- (void)dealloc {
    wjLog(@"%s", __func__);
}

@end
