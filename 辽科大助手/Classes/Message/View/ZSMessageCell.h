//
//  ZSMessageCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSMessageModel;
@interface ZSMessageCell : UITableViewCell
@property (nonatomic,strong)ZSMessageModel *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
