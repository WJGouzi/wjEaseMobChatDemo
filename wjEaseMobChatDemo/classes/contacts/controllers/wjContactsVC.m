//
//  wjContactsVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/5.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjContactsVC.h"
#import "wjAddContactVC.h"
#import "wjContactHeaderView.h"
#import "wjFriendRequestListVC.h"
#import "wjChatVC.h"
#import "wjGroupChatListVC.h"


@interface wjContactsVC () <EMContactManagerDelegate>

@property (nonatomic, strong) NSMutableArray *contactArray;


@end

@implementation wjContactsVC


#pragma mark - 懒加载
- (NSMutableArray *)contactArray {
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

#pragma maek - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjNavigationSettings];
    [self wjShowContactDataFromDB];
    [self wjSetUpHeaderView];
    // 添加代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示新朋友的badgeValue
    [self wjShowHeaderViewBadgeIfHaveRequest];
    [self wjShowContactBadgeValue];
}

/**
 显示headerview的badge
 */
- (void)wjShowHeaderViewBadgeIfHaveRequest {
    NSInteger count = [wjDBUtils wjGetFriendRequestCount];
    wjContactHeaderView *headerView = (wjContactHeaderView *)self.tableView.tableHeaderView;
    headerView.badgeView.hidden = (count == 0);
}


/**
 显示联系人的badgeValue
 */
- (void)wjShowContactBadgeValue {
    // 要获取 FriendRequest 的条数
    NSInteger requestCount = [wjDBUtils wjGetFriendRequestCount];
    self.navigationController.tabBarItem.badgeValue = requestCount ? [NSString stringWithFormat:@"%ld", requestCount] : nil;
}


/**
 导航栏的设置
 */
- (void)wjNavigationSettings {
    self.title = @"通讯录";
    UIBarButtonItem *addContactItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactAction:)];
    self.navigationItem.rightBarButtonItem = addContactItem;
}

- (void)addContactAction:(UIBarButtonItem *)addContactItem {
    // 进入到添加好友的界面
    [self.navigationController pushViewController:[[wjAddContactVC alloc] init] animated:YES];
}


// 显示好友数据
- (void)wjShowContactDataFromDB {
    // 开发中只需要获取到数据库中的好友数据就可以了
    // 1.获取好友的数据库
    NSArray *contactArray = [[EMClient sharedClient].contactManager getContacts];
    // 如果本地没有好友的数据，需要从服务器进行获取
    if (contactArray.count == 0) {
        [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
            // 获取到好友
            [self.contactArray addObjectsFromArray:aList];
            [self.tableView reloadData];
        }];
    } else {
        [self.contactArray addObjectsFromArray:contactArray];
    }
}


// 添加headerView
- (void)wjSetUpHeaderView {
    wjContactHeaderView *headView = [wjContactHeaderView headerView];
    self.tableView.tableHeaderView = headView;
    // 监听headerView的点击事件
    headView.selectedBlock = ^(NSInteger index) {
        UIViewController *vc = nil;
        if (index == 0) { // 点击头部
            // 进入好友申请的列表
            vc = [[wjFriendRequestListVC alloc] init];
        } else if (index == 1) {
            // 进入群列表
            vc = [[wjGroupChatListVC alloc] init];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    
    cell.textLabel.text = self.contactArray[indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取用户名
    NSString *userName = self.contactArray[indexPath.row];
    // 进入到聊天界面中
    wjChatVC *chatVC = [[wjChatVC alloc] initWithConversationChatter:userName conversationType:EMConversationTypeChat];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}


#pragma mark - EMContactManagerDelegate
// 好友关系建立
/*!
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *  @param aUsername   用户好友关系的另一方
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername {
    NSLog(@"%s", __func__);
    [self.contactArray addObject:aUsername];
    [self.tableView reloadData];
}




@end
