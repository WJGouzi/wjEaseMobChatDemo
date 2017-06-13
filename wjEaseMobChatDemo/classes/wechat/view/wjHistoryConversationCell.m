//
//  wjHistoryConversationCell.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjHistoryConversationCell.h"

@interface wjHistoryConversationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wjHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *wjNotReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *wjUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wjTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wjMessageLabel;

@end


@implementation wjHistoryConversationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *iden = @"wjHistoryCell";
    wjHistoryConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}


- (void)setConversation:(EMConversation *)conversation {
    _conversation = conversation;
    if (conversation.type == EMConversationTypeChat) {
        // 显示名字
        self.wjUserNameLabel.text = conversation.conversationId;
    } else if (conversation.type == EMConversationTypeGroupChat) {
        self.wjUserNameLabel.text = [wjDBUtils wjGetGroupNameByID:conversation.conversationId];
    }
    

    // 显示内容
    EMMessage *message = conversation.latestMessage;
    NSDictionary *moreTypeDict = message.ext;
    if (!moreTypeDict) {
        if (message.body.type == EMMessageBodyTypeText) {
            // 文本消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
            self.wjMessageLabel.text = textBody.text;
        } else if (message.body.type == EMMessageBodyTypeImage) {
            self.wjMessageLabel.text = @"[图片]";
        } else if (message.body.type == EMMessageBodyTypeVideo) {
            self.wjMessageLabel.text = @"[视频]";
        } else if (message.body.type == EMMessageBodyTypeVoice) {
            self.wjMessageLabel.text = @"[语音]";
        } else if (message.body.type == EMMessageBodyTypeLocation) {
            self.wjMessageLabel.text = @"[共享位置]";
        } else if (message.body.type == EMMessageBodyTypeFile) {
            self.wjMessageLabel.text = @"[文件]";
        } else {
            self.wjMessageLabel.text = @"未识别的类型";
        }
    } else {
        // 显示新增的类型识别方案
        NSString *moreType = moreTypeDict[@"type"];
        if ([moreType isEqualToString:@"1"]) {
            // 名片类型
            self.wjMessageLabel.text = @"[名片信息]";
        } else {
            self.wjMessageLabel.text = @"未识别的类型";
        }
    }
    
    // 显示时间
    NSString *timeStr = [NSDate formattedTimeFromTimeInterval:message.timestamp];
    self.wjTimeLabel.text = timeStr;
    // 显示未读消息的数字
    int notReadCount = [conversation unreadMessagesCount];
    if (notReadCount > 0) {
        self.wjNotReadLabel.hidden = NO;
        self.wjNotReadLabel.text = [NSString stringWithFormat:@"%d", notReadCount];
    } else {
        self.wjNotReadLabel.hidden = YES;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // 未读消息的label
    self.wjNotReadLabel.layer.masksToBounds = YES;
    self.wjNotReadLabel.layer.cornerRadius = self.wjNotReadLabel.frame.size.width * 0.5;
}


@end
