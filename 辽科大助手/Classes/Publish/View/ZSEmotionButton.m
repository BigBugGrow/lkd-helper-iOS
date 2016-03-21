//
//  ZSEmotionButton.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/21.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionButton.h"
#import "ZSEmotion.h"

@implementation ZSEmotionButton


/**
 *  代码创建就会调用
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        //按钮点击不高亮
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

/**
 *  从xib里面加载出来的，会在这里面调用
 */
- (instancetype)initWithCoder:(NSCoder *)dDecoder
{
    if (self = [super initWithCoder:dDecoder]) {
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
}

- (void)setEmotion:(ZSEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) {
        
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) {
        
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}

/**
 *  去除高亮效果
// */
//- (void)setHighlighted:(BOOL)highlighted
//{
//    
//}


@end
