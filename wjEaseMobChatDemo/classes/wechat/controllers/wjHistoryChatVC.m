//
//  wjHistoryChatVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjHistoryChatVC.h"
#import "wjHistoryConversationCell.h"
#import "wjChatVC.h"

@interface wjHistoryChatVC () <EMChatManagerDelegate>

@property (nonatomic, strong) NSMutableArray *conversationsArray;


@end

@implementation wjHistoryChatVC


#pragma mark - 懒加载
- (NSMutableArray *)conversationsArray {
    if (!_conversationsArray) {
        _conversationsArray = [NSMutableArray array];
    }
    return _conversationsArray;
}


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjNavigationSettings];
    // 获取历史回话记录
    [self wjGetAllHistoryConversations];
    // 添加代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 刷新未读消息数
    [self.tableView reloadData];
    [self wjShowUnReadTotalNumberCount];
}


#pragma maek - 方法
/** 
 * 显示总的未读消息数
 */
- (void)wjShowUnReadTotalNumberCount {
    int count = 0;
    for (EMConversation *conversation in self.conversationsArray) {
        count += conversation.unreadMessagesCount;
    }
    if (count == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else if (count <= 99) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
    } else {
        self.navigationController.tabBarItem.badgeValue = @"99+";
    }
}


/**
 导航栏设置
 */
- (void)wjNavigationSettings {
    self.title = @"微信";
}


#pragma mark - 获取历史回话记录
- (void)wjGetAllHistoryConversations {
    NSArray *historyConversationArray = [[EMClient sharedClient].chatManager getAllConversations];
    wjLog(@"%@", historyConversationArray);
    [self.conversationsArray addObjectsFromArray:historyConversationArray];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.conversationsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"historyConversationsCell";
    wjHistoryConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [wjHistoryConversationCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.conversation = self.conversationsArray[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate 
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取删除的好友
    EMConversation *conversation = self.conversationsArray[indexPath.row];
    // 删除回话
    [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        //
        wjLog(@"删除回话成功");
    }];
}

// 点击进入到聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 传入用户的名字
    EMConversation *conversation = self.conversationsArray[indexPath.row];
    /** 初始化聊天界面
     *  conversationChatter 对方的名字或者是群聊等房间名
     *  conversationType 聊天的类型: 单聊\群聊\会话室
     */
    wjChatVC *chatVC = [[wjChatVC alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}



#pragma mark - EMChatManagerDelegate
/*!
 *  收到消息 (收到未读消息监听)
 *  @param aMessages  消息列表<EMMessage>
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    [self wjShowUnReadTotalNumberCount];
    [self.tableView reloadData];
}

/*!
 *  会话列表发生变化(新增和删除都会调用的)
 *  @param aConversationList  会话列表<EMConversation>
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
//    EMConversation *conversation = aConversationList.lastObject;
//    wjLog(@"aConversationList:%@", conversation.conversationId);
//    // 把最新的数据传到数据源
//    [self.conversationsArray insertObject:conversation atIndex:0];
    [self.conversationsArray removeAllObjects];
    [self.conversationsArray addObjectsFromArray:aConversationList];
    // 刷新表格
    [self.tableView reloadData];
    // 刷新总的未读消息数
    [self wjShowUnReadTotalNumberCount];
}


@end
