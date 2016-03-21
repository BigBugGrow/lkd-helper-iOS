//
//  ZSEmotionTabBarButton.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionTabBarButton.h"

@implementation ZSEmotionTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

//重写setHight方法 去除高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
