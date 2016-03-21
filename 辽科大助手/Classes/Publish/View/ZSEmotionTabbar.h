//
//  ZSEmotionTabbar.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSEmotionTabbar;

typedef enum {
    
    ZSEmotionTabbarButtonTypeRecently, //最近
    ZSEmotionTabbarButtonTypeDefoult, //默认
    ZSEmotionTabbarButtonTypeEmoji, //Emoji
    ZSEmotionTabbarButtonTypeWaveFlower //浪小花
}ZSEmotionTabbarButtonType;


@protocol ZSEmotionTabbardelegate <NSObject>

@optional
- (void)emotionTabbar:(ZSEmotionTabbar *)emotionTabBar didClickTabBarButtonWithType:(ZSEmotionTabbarButtonType)buttonType;

@end

@interface ZSEmotionTabbar : UIView

/** 代理属性*/
@property (nonatomic, weak) id<ZSEmotionTabbardelegate> delegate;

@end
