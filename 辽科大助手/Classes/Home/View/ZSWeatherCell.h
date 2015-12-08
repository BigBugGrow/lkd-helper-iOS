//
//  ZSWeatherCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSWeatherModel;
@interface ZSWeatherCell : UITableViewCell

@property (nonatomic,strong)ZSWeatherModel *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
