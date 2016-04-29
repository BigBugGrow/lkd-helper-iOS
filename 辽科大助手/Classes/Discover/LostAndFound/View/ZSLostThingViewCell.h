
//
//  ZSLostThingViewCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSLostThingViewCell, ZSLostingFrame;

@protocol ZSLostThingViewCellDelegate <NSObject>

@optional
- (void)clickCall:(ZSLostThingViewCell *)lostThingViewCell PhoneNum:(NSString *)phoneNum;
/** 通知控制器push到myNovcltyController*/
- (void)pushToInfoViewController:(ZSLostThingViewCell *)lostThingViewCell nickName:(NSString *)nickName;


@end

@interface ZSLostThingViewCell : UITableViewCell

@property (nonatomic, weak) id<ZSLostThingViewCellDelegate> delegate;

///** 提供cell*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** cell的frame模型*/
@property (nonatomic, strong) ZSLostingFrame *lostTingFrame;

@end
