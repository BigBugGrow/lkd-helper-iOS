//
//  ZSTableViewCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSModel.h"

@interface ZSTableViewCell : UITableViewCell
@property (nonatomic,strong)ZSModel *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
