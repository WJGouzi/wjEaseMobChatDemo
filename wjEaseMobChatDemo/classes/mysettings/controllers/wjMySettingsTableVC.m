//
//  wjMySettingsTableVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/2.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjMySettingsTableVC.h"
#import "wjLoginVC.h"

@interface wjMySettingsTableVC ()
@property (weak, nonatomic) IBOutlet UILabel *wjIDLable;

@end

@implementation wjMySettingsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示微信的ID
    self.wjIDLable.text = [[EMClient sharedClient] currentUsername];
    self.wjIDLable.text = [@"微信ID:" stringByAppendingString:self.wjIDLable.text];
}


- (IBAction)wjLogOutAction:(UIButton *)sender {
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if (!aError) {
            NSLog(@"退出成功");
            // 退出到登录界面
            self.view.window.rootViewController = [[wjLoginVC alloc] init];
        } else {
            NSLog(@"退出失败%@", aError);
        }
    }];

}

@end
