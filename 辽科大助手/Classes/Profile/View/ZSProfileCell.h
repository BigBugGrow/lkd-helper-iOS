//
//  ZSProfileCell.h
//  辽科大助手
//
//  Created by DongAn on 15/11/30.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSProfileModel;

@interface ZSProfileCell : UITableViewCell

@property (nonatomic,strong)ZSProfileModel *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
