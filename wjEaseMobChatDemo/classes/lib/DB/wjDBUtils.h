//
//  wjDBUtils.h
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/6.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wjFriendRequestModel.h"

@interface wjDBUtils : NSObject

/**
 存储好友申请的数据到本地数据库中

 @param userName 申请的用户名
 @param message 附加的说明信息
 */
+ (void)wjSaveFriendRequestWithUserName:(NSString *)userName message:(NSString *)message;


/**
 获取好友申请的条数
 */
+ (NSInteger)wjGetFriendRequestCount;



/**
 好友申请列表的数据

 @return 数组存的是<wjFriendRequestModel>
 */
+ (NSArray *)wjFriendRequestList;



/**
 把好友申请从列表中删除

 @param userName 申请的用户的用户名
 */
+ (void)wjDeleteFriendRequestWithUserName:(NSString *)userName;




/**
 通过ID拿到群组的名字

 @param ID 群的id
 @return 群组的名字  
 */
+ (NSString *)wjGetGroupNameByID:(NSString *)ID;


@end
