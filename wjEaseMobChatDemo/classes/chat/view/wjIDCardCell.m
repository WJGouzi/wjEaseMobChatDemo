//
//  wjIDCardCell.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjIDCardCell.h"


static NSString *sendID = @"SendIdCardCell";
static NSString *recieveID = @"RecieveIdCardCell";

@interface wjIDCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wjBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *wjNameLabel;
// 当前用户自己的头像图片
@property (weak, nonatomic) IBOutlet UIImageView *wjCurrentUserHeadImageView;
// 正在聊天用户的头像
@property (weak, nonatomic) IBOutlet UIImageView *wjToUersHeadImageView;
// 名片中用户的头像
@property (weak, nonatomic) IBOutlet UIImageView *wjTargetUserHeadImageView;


@end


@implementation wjIDCardCell



+ (instancetype)senderCellWithTabelView:(UITableView *)tableView {
    wjIDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:sendID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    }
    
    
    return cell;
}


+ (instancetype)recieverCellWithTabelView:(UITableView *)tableView {
    wjIDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:recieveID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置背景
    NSString *senderBgName = @"EaseUIResource.bundle/chat_sender_bg";
    NSString *receiverBgName = @"EaseUIResource.bundle/chat_receiver_bg";
    
    UIImage *image = nil;
    if ([self.reuseIdentifier isEqualToString:sendID]) {
        // 发送方
        image = [UIImage imageNamed:senderBgName];
    } else {
        // 接收方
        image = [UIImage imageNamed:receiverBgName];
    }
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.7 topCapHeight:image.size.height * 0.7];
    self.wjBackgroundImageView.image = image;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wjIdCardDetailTap:)];
    [self.wjBackgroundImageView addGestureRecognizer:tap];
}


- (void)wjIdCardDetailTap:(UITapGestureRecognizer *)tap {
    wjLog(@"123");
    // 点击进入到个人详情页
    
    
}


- (void)setMessage:(EMMessage *)message {
    _message = message;
    NSDictionary *ext = message.ext;
    NSString *name = ext[@"name"];
    self.wjNameLabel.text = name;
}



@end
