//
//  wjCreatGroupVC.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjCreatGroupVC.h"

@interface wjCreatGroupVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wjGroupNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 联系人*/
@property (nonatomic, strong) NSMutableArray *contactsListArray;


/** 选择的人员*/
@property (nonatomic, strong) NSMutableArray *selectedContactsArray;

@end

@implementation wjCreatGroupVC

#pragma mark - 懒加载
- (NSMutableArray *)contactsListArray {
    if (!_contactsListArray) {
        _contactsListArray = [NSMutableArray array];
    }
    return _contactsListArray;
}

- (NSMutableArray *)selectedContactsArray {
    if (!_selectedContactsArray) {
        _selectedContactsArray = [NSMutableArray array];
    }
    return _selectedContactsArray;
}

#pragma mark - 声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wjNavigationSettings];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 获取好友的数据
    [self wjGetFriendContacts];
    // 实现多选的功能
    self.tableView.editing = YES;
    
    
    
}

- (void)wjNavigationSettings {
    self.title = @"创建群";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(wjCreatGroup)];
}

- (void)wjCreatGroup {
    wjLog(@"选中的好友为 : %@", self.selectedContactsArray);
    // 人数要大于2的时候才创建群
    if (self.selectedContactsArray.count >= 2) {
//         *  创建群组
//         *  @param aSubject         群组名称
        NSString *subject = self.wjGroupNameTextField.text;
//         *  @param aDescription     群组描述
        NSString *description = @"欢迎到本群组进行交流学习！";
//         *  @param aInvitees        群组成员（不包括创建者自己）
        NSArray *invitesArray = [self.selectedContactsArray copy];
//         *  @param aMessage         邀请消息
        NSString *inviteMessage = @"WELCOM";
//         *  @param aSetting         群组属性
        EMGroupOptions *groupOptions = [[EMGroupOptions alloc] init];
        groupOptions.style = EMGroupStylePublicOpenJoin; // 可以公开加入的
//         *  @param aCompletionBlock 完成的回调
        
        [[EMClient sharedClient].groupManager createGroupWithSubject:subject description:description invitees:invitesArray message:inviteMessage setting:groupOptions completion:^(EMGroup *aGroup, EMError *aError) {
            wjLog(@"创建群的结果:%@", aError.errorDescription);
        }];
    } else {
        wjLog(@"人数必须大于2！");
    }
}


#pragma mark - 获取好友的数据
- (void)wjGetFriendContacts {
    NSArray *contactsList = [[EMClient sharedClient].contactManager getContacts];
    [self.contactsListArray addObjectsFromArray:contactsList];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"chooseContacts";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    
    cell.textLabel.text = self.contactsListArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
// 多选和编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


// 点击选择的人员
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedContactsArray addObject:self.contactsListArray[indexPath.row]];
}

// 未选择人员
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedContactsArray.count) {
        [self.selectedContactsArray removeObject:self.contactsListArray[indexPath.row]];
    }
}

@end
