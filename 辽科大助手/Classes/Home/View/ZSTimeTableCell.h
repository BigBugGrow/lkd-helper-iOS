//
//  ZSTimeTableCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSTimeTabelModel;
@interface ZSTimeTableCell : UITableViewCell

@property (nonatomic,strong)ZSTimeTabelModel *model;

+ (instancetype)timeTabelCellWithTableView:(UITableView *)tableView;
@end
