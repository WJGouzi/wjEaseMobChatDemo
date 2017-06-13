//
//  wjIDCardCell.h
//  wjEaseMobChatDemo
//
//  Created by gouzi on 2017/6/8.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wjIDCardCell : UITableViewCell

/** message */
@property (nonatomic, strong) EMMessage *message;


/**
 发送方的cell
 */
+ (instancetype)senderCellWithTabelView:(UITableView *)tableView;


/**
 接收方的cell
 */
+ (instancetype)recieverCellWithTabelView:(UITableView *)tableView;


@end
