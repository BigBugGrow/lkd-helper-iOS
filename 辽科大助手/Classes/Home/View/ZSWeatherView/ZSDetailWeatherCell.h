//
//  ZSDetailWeatherCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSDetailWeatherFrameModel;

@interface ZSDetailWeatherCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZSDetailWeatherFrameModel *detailWeatherFrameModel;

@end
