//
//  ZSLostThingViewCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSLostThing;

@interface ZSLostThingViewCell : UITableViewCell


/**模型*/
@property (nonatomic, strong) ZSLostThing *lostThing;


/** 提供cell*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
