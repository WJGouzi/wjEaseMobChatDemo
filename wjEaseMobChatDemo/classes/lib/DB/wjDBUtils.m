//
//  wjDBUtils.m
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/6.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjDBUtils.h"

@implementation wjDBUtils

+ (FMDatabase *)dataBaseCreate {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *currentUserName = [EMClient sharedClient].currentUsername;
    NSString *dbFilePath = [[[document stringByAppendingPathComponent:@"HyphenateSDK"] stringByAppendingPathComponent:@"easemobDB"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", currentUserName]];
    wjLog(@"db file path is : %@", dbFilePath);
    // 2.插入表
    return [FMDatabase databaseWithPath:dbFilePath];
}



+ (void)wjSaveFriendRequestWithUserName:(NSString *)userName message:(NSString *)message {
    // 默认环信内部不会保存 '好友的添加申请' 的数据
    // 创建表-> creat table if not exisits friendRequest (userName text, message text);
    // 插入数据-> insert friendRequest(userName, message) values(?,?)
    
    // 1.获取本地的数据库文件路径
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *currentUserName = [EMClient sharedClient].currentUsername;
    NSString *dbFilePath = [[[document stringByAppendingPathComponent:@"HyphenateSDK"] stringByAppendingPathComponent:@"easemobDB"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", currentUserName]];
    // 2.插入表
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbFilePath];
    if ([dataBase open]) {
        NSString *creatTable = @"create table if not exists friendRequest (userName text, message text);";
        [dataBase executeUpdate:creatTable];
        
        // 把之前的同名的删除掉
        NSString *deleteExistUser = @"delete from friendRequest where userName = ?";
        [dataBase executeUpdate:deleteExistUser withArgumentsInArray:@[userName]];
        
        // 3.插入数据
        NSString *insertData = @"insert into friendRequest(userName, message) values(?,?)";
        BOOL isInsertSuccess = [dataBase executeUpdate:insertData withArgumentsInArray:@[userName, message]];
        NSLog(@"inser is success ? %d", isInsertSuccess);
    }
    
    // 4.数据库关闭
    [dataBase close];
}


+ (NSInteger)wjGetFriendRequestCount {
    NSString *sql = @"select count(*) from friendRequest;";
    FMDatabase *db = [self dataBaseCreate];
    if (![db open]) {
        return 0;
    }
    NSInteger count = 0;
    FMResultSet *result = [db executeQuery:sql];
    if (result.next) {
        count = [result intForColumnIndex:0];
    }
    [db close];
    return count;
}


+ (NSArray *)wjFriendRequestList {
    // 执行查询的sql
    NSString *sql = @"select * from friendRequest;";
    FMDatabase *db = [self dataBaseCreate];
    if (![db open]) {
        return nil;
    }
    FMResultSet *result = [db executeQuery:sql];
    NSMutableArray *tempArray = [NSMutableArray array];
    // 遍历结果
    while (result.next) {
        wjFriendRequestModel *model = [[wjFriendRequestModel alloc] init];
        // 封装成模型
        model.userName = [result stringForColumn:@"userName"];
        model.message = [result stringForColumn:@"message"];
        [tempArray addObject:model];
    }
    [db close];
    // 添加到数组
    return [tempArray copy];
}


+ (void)wjDeleteFriendRequestWithUserName:(NSString *)userName {
    NSString *sql = @"delete from friendRequest where userName = ?";
    FMDatabase *db = [self dataBaseCreate];
    if (![db open]) {
        return;
    }
    [db executeUpdate:sql withArgumentsInArray:@[userName]];
    [db close];
}


+ (NSString *)wjGetGroupNameByID:(NSString *)ID {
    NSString *sql = @"select groupsubject from 'group' where groupid = ?"; // group是sql的关键字
    FMDatabase *db = [self dataBaseCreate];
    if (![db open]) {
        return nil;
    }
    FMResultSet *reslut = [db executeQuery:sql withArgumentsInArray:@[ID]];
    NSString *groupName = nil;
    while (reslut.next) {
        groupName = [reslut stringForColumn:@"groupsubject"];
    }
    [db close];
    return groupName;
}


@end
