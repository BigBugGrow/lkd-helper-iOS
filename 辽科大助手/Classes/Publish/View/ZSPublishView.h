//
//  BSPublishView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/17.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSPublishView, ZSComposeViewController;

@protocol ZSPublishViewDelegate <NSObject>

/** 通知控制器push到myNovcltyController*/
- (void)pushToPublishViewController:(ZSPublishView *)allDynamicCell ComposeViewController:(ZSComposeViewController *)composeViewController;

@end

@interface ZSPublishView : UIView

/** 代理属性*/
@property (nonatomic, assign) id<ZSPublishViewDelegate> delegate;

+ (instancetype)publishView;

@end
