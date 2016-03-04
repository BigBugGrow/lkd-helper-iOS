//
//  ZSAllDynamicCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSAllDynamicFrame;

@interface ZSAllDynamicCell : UITableViewCell

//提供cell

+(instancetype)cellWithTableView:(UITableView *)tableView;

/** cell的frame模型*/
@property (nonatomic, strong) ZSAllDynamicFrame *allDynamicFrame;

@end
