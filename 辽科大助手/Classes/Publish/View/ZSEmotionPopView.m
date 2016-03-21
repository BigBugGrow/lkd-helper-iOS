//
//  ZSEmotionPopView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/21.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionPopView.h"
#include "ZSEmotionButton.h"

@interface ZSEmotionPopView ()

@property (weak, nonatomic) IBOutlet ZSEmotionButton *emotionButton;

@end

@implementation ZSEmotionPopView


//加载popView
+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZSEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)setEmotion:(ZSEmotion *)emotion
{
    _emotion = emotion;
    
    self.emotionButton.emotion = emotion;
}


- (void)showFromPopView:(ZSEmotionButton *)emotionBtn
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self];
    /**
     *  放大镜效果
     */

    /**
     *  转换坐标系 //将以window为坐标系的坐标转换成为以
     */
    CGRect frameBtn = [emotionBtn convertRect:emotionBtn.bounds toView:nil];
    
    self.y = CGRectGetMidY(frameBtn) - self.height;
    self.centerX = CGRectGetMidX(frameBtn);
}

@end
