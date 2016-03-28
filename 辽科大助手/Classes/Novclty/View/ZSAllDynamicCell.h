//
//  ZSAllDynamicCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSAllDynamicFrame, ZSAllDynamicCell;

@protocol ZSAllDynamicCellDelegate <NSObject>

/** 通知控制器push到myNovcltyController*/
- (void)pushToMyNovcltyViewController:(ZSAllDynamicCell *)allDynamicCell nickName:(NSString *)nickName;
@end

@interface ZSAllDynamicCell : UITableViewCell

/** 添加代理属性*/
@property (nonatomic, assign) id<ZSAllDynamicCellDelegate> delegate;

//提供cell

+(instancetype)cellWithTableView:(UITableView *)tableView;

/** cell的frame模型*/
@property (nonatomic, strong) ZSAllDynamicFrame *allDynamicFrame;

@end
