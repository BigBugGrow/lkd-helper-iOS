//
//  ZSInquireCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSInquireModel;

@interface ZSInquireCell : UITableViewCell

@property (nonatomic,strong)ZSInquireModel *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
