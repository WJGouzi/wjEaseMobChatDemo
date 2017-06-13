//
//  wjGroupChatListVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjGroupChatListVC.h"
#import "wjCreatGroupVC.h"
#import "wjChatVC.h"

@interface wjGroupChatListVC ()

@property (nonatomic, strong) NSMutableArray *groupListArray;

@end

@implementation wjGroupChatListVC

#pragma mark - 懒加载
- (NSMutableArray *)groupListArray {
    if (!_groupListArray) {
        _groupListArray = [NSMutableArray array];
    }
    return _groupListArray;
}



#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjNavigationSettings];
    // 显示群列表的数据
    [self wjShowGroupListData];
}

- (void)wjShowGroupListData {
    /*!
     *  获取用户所有群组
     *  @result 群组列表<EMGroup>
     */
    NSArray *groupList = [[EMClient sharedClient].groupManager getJoinedGroups];
    if (groupList.count == 0) {
        // 就从服务器进行获取
//        *  从服务器获取所有的群组
//        *  @param aPageNum  获取公开群的cursor，首次调用传空
//        *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
//        *  @param aCompletionBlock      完成的回调
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 completion:^(NSArray *aList, EMError *aError) {
            wjLog(@"从服务器获取所有的群:%@", aList);
            [self.groupListArray addObjectsFromArray:aList];
            [self.tableView reloadData];
        }];
    } else {
        [self.groupListArray addObjectsFromArray:groupList];
        wjLog(@"从本地获取的数据库group list:%@", groupList);
    }
}


- (void)wjNavigationSettings {
    self.title = @"群列表";
    
    // 1.添加群列表的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建群" style:UIBarButtonItemStylePlain target:self action:@selector(wjGotoCreatGroupChat)];
 
    // 2.添加搜索条
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    searchBar.placeholder = @"请输入搜索群的名称";
    self.tableView.tableHeaderView = searchBar;
}


/**
 创建群按钮的点击事件
 */
- (void)wjGotoCreatGroupChat {
    wjCreatGroupVC *creatGroupVC = [[wjCreatGroupVC alloc] init];
    [self.navigationController pushViewController:creatGroupVC animated:YES];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groupListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"wjGroupListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    
    EMGroup *group = self.groupListArray[indexPath.row];
    cell.textLabel.text = group.subject;
    
    return cell;
}


#pragma mark - Table view data delegate
// 点击进入群聊界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取点击的群信息
    EMGroup *group = self.groupListArray[indexPath.row];
    // 进入到相关的聊天的界面
    wjChatVC *chatVC = [[wjChatVC alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    [self.navigationController pushViewController:chatVC animated:YES];
}



@end
