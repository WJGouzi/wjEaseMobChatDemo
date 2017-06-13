//
//  wjAddContactVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/5.
//  Copyright © 2017年 wj. All rights reserved.
//  添加用户的页面

#import "wjAddContactVC.h"

@interface wjAddContactVC ()
@property (weak, nonatomic) IBOutlet UITextField *wjFriendsIdTextField;

@end

@implementation wjAddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:NO];
}


- (IBAction)wjAddAction:(UIButton *)sender {
    // 1.获取用户输入好友的名字
    NSString *friendIdStr = self.wjFriendsIdTextField.text;
    
    // 2.发送
    [[EMClient sharedClient].contactManager addContact:friendIdStr message:@"i'm wj,please allow me application" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"发送好友请求成功");
        } else {
            NSLog(@"发送好友申请失败: %u", aError.code);
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}




@end
