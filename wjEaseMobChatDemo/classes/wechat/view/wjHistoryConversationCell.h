//
//  wjHistoryConversationCell.h
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wjHistoryConversationCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;


/** EMConversation*/
@property (nonatomic, strong) EMConversation *conversation;

@end
