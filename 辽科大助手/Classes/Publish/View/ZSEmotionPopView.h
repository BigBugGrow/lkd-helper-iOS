//
//  ZSEmotionPopView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/21.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSEmotion, ZSEmotionButton;

@interface ZSEmotionPopView : UIView

//加载popView
+ (instancetype)popView;

/**
 *  emotion模型
 */
@property (nonatomic, strong) ZSEmotion *emotion;

/**
 *  放大镜效果
 */

- (void)showFromPopView:(ZSEmotionButton *)emotionBtn;
@end
