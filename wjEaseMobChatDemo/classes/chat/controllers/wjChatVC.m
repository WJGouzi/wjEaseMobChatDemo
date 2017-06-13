//
//  wjChatVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjChatVC.h"
#import "wjIDCardCell.h"


@interface wjChatVC () <EaseChatBarMoreViewDelegate, EaseMessageViewControllerDelegate>

@end

@implementation wjChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjNavigationSettings];
    // 在moreView添加一个子控件
    [self wjInsertMoreActionButtonInMoreView];
    // 实现自定义聊天cell
    self.delegate = self;
    
    // 自定义背景
    self.view.backgroundColor = [UIColor redColor];
    
}


#pragma mark - 通用设置
/**
 导航栏的设置
 */
- (void)wjNavigationSettings {
    
    // 判断聊天的模式
    if (self.conversation.type == EMConversationTypeChat) {
        // 显示好友的名字
        self.title = self.conversation.conversationId;
    } else if (self.conversation.type == EMConversationTypeGroupChat) {
        // 显示群组的名字
        NSString *groupId = self.conversation.conversationId;
        [[EMClient sharedClient].groupManager searchPublicGroupWithId:groupId completion:^(EMGroup *aGroup, EMError *aError) {
            self.title = aGroup.subject;
        }];
    }
}


/**
 在moreView中新增一些按钮
 */
- (void)wjInsertMoreActionButtonInMoreView {
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"IDCard"] highlightedImage:nil title:nil];
    self.chatBarMoreView.delegate = self;
}


#pragma mark - EaseChatBarMoreViewDelegate
/*!
 @method
 @brief 自定义moreview的点击
 @param moreView    功能view
 @param index       按钮索引
 */
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index {
    wjLog(@"more view click : %ld", index);
    // 1.创建一个消息体
//    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithText:@"名片消息"];
    // 2.构造扩展字典（名片消息） type = 1:名片,  2:红包 ...
    NSDictionary *idCardInfo = @{
                                 @"type" : @"1",
                                 @"name" : @"wangjun",
                                 @"icon" : @"xxxx"
                                 };
    // 3.构造消息对象
    // 方法一:
//    NSString *toID = self.conversation.conversationId;
//    NSString *fromID = [EMClient sharedClient].currentUsername;
//    EMMessage *message = [[EMMessage alloc] initWithConversationID:toID from:fromID to:toID body:textBody ext:idCardInfo];
//    [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:nil];

    // 方法二:z
    [self sendTextMessage:@"名片消息" withExt:idCardInfo];

}


#pragma mark - EaseMessageViewControllerDelegate
/*!
 @method
 @brief 获取消息自定义cell
 @discussion 用户根据messageModel判断是否显示自定义cell,返回nil显示默认cell,否则显示用户自定义cell
 @param tableView 当前消息视图的tableView
 @param messageModel 消息模型
 @result 返回用户自定义cell
 */
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel {
    
    // 1.判断名片cell的
    EMMessage *message = messageModel.message;
    // 2.获取扩展消息
    NSDictionary *ext = message.ext;
    if (!ext) {
        return nil;
    }
    
    wjIDCardCell *cell = nil;
    if ([ext[@"type"] isEqualToString:@"1"]) {
        // 名片
        wjLog(@"名片");
        // 返回名片的cell
        // 判断是接收还是发送
        BOOL isSendUserHand = [message.from isEqualToString:[EMClient sharedClient].currentUsername]; // 是否是发送方
        if (isSendUserHand) {
            // 创建发送方的cell
            cell = [wjIDCardCell senderCellWithTabelView:tableView];
        } else {
            // 创建接收方的cell
            cell = [wjIDCardCell recieverCellWithTabelView:tableView];
        }
        // 赋值显示数据
        cell.message = message;
    }
    return cell;
}

/*!
 @method
 @brief 获取消息cell高度
 @discussion 用户根据messageModel判断,是否自定义显示cell的高度
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @param cellWidth 视图宽度
 @result 返回用户自定义cell
 */
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth {
    // 1.判断名片cell的
    EMMessage *message = messageModel.message;
    // 2.获取扩展消息
    NSDictionary *ext = message.ext;
    if (!ext) {
        return 0;
    }
    
    if ([ext[@"type"] isEqualToString:@"1"]) {
        // 名片
        return 100;
    }

    return 0;
}



@end
