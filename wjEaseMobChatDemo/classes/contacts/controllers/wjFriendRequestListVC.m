//
//  wjFriendRequestListVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/6.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjFriendRequestListVC.h"

@interface wjFriendRequestListVC ()

@property (nonatomic, strong) NSMutableArray *friendRequestListArray;

@end

@implementation wjFriendRequestListVC


#pragma mark - 懒加载
- (NSMutableArray *)friendRequestListArray {
    if (!_friendRequestListArray) {
        _friendRequestListArray = [NSMutableArray array];
    }
    return _friendRequestListArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjNavgationSettings];
    // 显示数据
    NSArray *listArray = [wjDBUtils wjFriendRequestList];
    if (listArray.count) {
        [self.friendRequestListArray addObjectsFromArray:listArray];
    }
}

- (void)wjNavgationSettings {
    self.title = @"好友申请列表";
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendRequestListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"friendRequestList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        // 添加cell的同意按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"同意" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(wjAcceptAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        cell.accessoryView = btn;
    }
    // 绑定tag值
    cell.accessoryView.tag = indexPath.row + 1;
    wjFriendRequestModel *model = self.friendRequestListArray[indexPath.row];
    cell.textLabel.text = model.userName;
    cell.detailTextLabel.text = model.message;
    
    
    return cell;
}


#pragma mark - delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"删除 ： %ld", indexPath.row);
    // 拿到用户名
    wjFriendRequestModel *model = self.friendRequestListArray[indexPath.row];
    // 发送请求给服务器
    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:model.userName completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"拒绝请求发送成功");
            // 当前记录从数据库中删除
            [wjDBUtils wjDeleteFriendRequestWithUserName:model.userName];
            // 当前记录从当前表格的数据源数组进行删除
            [self.friendRequestListArray removeObject:model];
            // 刷新表格
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        } else {
            NSLog(@"拒绝请求发送失败");
        }
    }];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"拒绝";
}

#pragma mark - 各种点击事件
- (void)wjAcceptAction:(UIButton *)btn {
    NSLog(@"同意 ： %ld", btn.tag);
    // 拿到用户名
    wjFriendRequestModel *model = self.friendRequestListArray[btn.tag - 1];
    // 发送请求给服务器
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:model.userName completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"同意请求发送成功");
            // 当前记录从数据库中删除
            [wjDBUtils wjDeleteFriendRequestWithUserName:model.userName];
            // 当前记录从当前表格的数据源数组进行删除
            [self.friendRequestListArray removeObject:model];
            // 刷新表格
            NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag - 1 inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
        } else {
            NSLog(@"同意请求发送失败");
        }
    }];
    
}



@end
