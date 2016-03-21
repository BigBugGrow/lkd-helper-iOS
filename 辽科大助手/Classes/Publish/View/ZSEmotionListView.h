//
//  ZSEmotionListView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSEmotion.h"


//一页表情的数量
#define ZSEmotionCountOnePage 20

@interface ZSEmotionListView : UIView

/** 表情模型数组*/
@property (nonatomic, strong) NSArray *emotions;

@end
