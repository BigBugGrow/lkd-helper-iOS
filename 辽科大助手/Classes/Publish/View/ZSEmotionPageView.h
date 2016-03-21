//
//  ZSEmotionPageView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/15.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 每页的最大行数*/
#define ZSEmotionPageRowsCount 7
/** 每页的最大列数*/
#define ZSEmotionPageColsCount 3


@interface ZSEmotionPageView : UIView
/** 这一页的表情数组*/
@property (nonatomic, strong) NSArray *emotions;
@end
