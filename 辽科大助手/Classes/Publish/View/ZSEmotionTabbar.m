//
//  ZSEmotionTabbar.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionTabbar.h"
#import "ZSEmotionTabBarButton.h"

@interface ZSEmotionTabbar ()

/**
 * 默认选择的按钮
 */
@property (nonatomic, weak) ZSEmotionTabBarButton *currentBtn;


@end


@implementation ZSEmotionTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //添加按钮
        [self addTabBarBtnWithTitle:@"最近" buttonType:ZSEmotionTabbarButtonTypeRecently];
        [self addTabBarBtnWithTitle:@"默认" buttonType:ZSEmotionTabbarButtonTypeDefoult];
        [self addTabBarBtnWithTitle:@"Emoji" buttonType:ZSEmotionTabbarButtonTypeEmoji];
        [self addTabBarBtnWithTitle:@"浪小花" buttonType:ZSEmotionTabbarButtonTypeWaveFlower];
        
    }
    return self;
}

/**
 *  添加按钮
 */
- (void)addTabBarBtnWithTitle:(NSString *)title buttonType:(ZSEmotionTabbarButtonType)buttonType
{
    ZSEmotionTabBarButton *btn = [[ZSEmotionTabBarButton alloc] init];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
   
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectedImage = @"compose_emotion_table_mid_selected";
    
    if (buttonType == ZSEmotionTabbarButtonTypeRecently) {
     
        
        image = @"compose_emotion_table_left_normal";
        selectedImage = @"compose_emotion_table_left_selected";
        
    } else if(buttonType == ZSEmotionTabbarButtonTypeWaveFlower) {
    
        image = @"compose_emotion_table_right_normal";
        selectedImage = @"compose_emotion_table_right_selected";

    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if (btn.tag == LBEmotionTabbarButtonTypeDefoult) {
//        [self didClickBtn:btn];
//    }
    
    [self addSubview:btn];
}

/**
 *  重写代理方法，让默认的图片框显示出来，再复制代理的时刻
 */
- (void)setDelegate:(id<ZSEmotionTabbardelegate>)delegate
{
    _delegate = delegate;
    
    [self didClickBtn:(ZSEmotionTabBarButton *)[self viewWithTag:ZSEmotionTabbarButtonTypeDefoult]];
}

/**
 *  监听按钮点击方法
 */
- (void)didClickBtn:(ZSEmotionTabBarButton *)btn
{

    self.currentBtn.enabled = YES;
    btn.enabled = NO;
    self.currentBtn = btn;
    
    ZSEmotionTabbarButtonType btnType = (ZSEmotionTabbarButtonType)btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(emotionTabbar:didClickTabBarButtonWithType:)]) {
        
        [self.delegate emotionTabbar:self didClickTabBarButtonWithType:btnType];
    }
    
}


/**
 *  设置按钮尺寸
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat width = self.width / count;
    CGFloat height = self.height;
    
    for (int i = 0; i < count; i ++) {
        
        ZSEmotionTabBarButton *btn = self.subviews[i];
        btn.width = width;
        btn.height = height;
        btn.x = i * width;
        btn.y = 0;
    }
}


@end
