//
//  ZSComposeToolBar.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/13.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSComposeToolBar.h"

@interface ZSComposeToolBar ()

/**  表情按钮*/

@property (nonatomic, weak) UIButton *emotionBtn;

@end

@implementation ZSComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //加按钮
        [self addToolBtnWithImage:[UIImage imageNamed:@"compose_camerabutton_background"] highlightImage:[UIImage imageNamed:@"compose_camerabutton_background_highlighted"] btnType:ZSComposeToolBarButtonTypeCamera];
        
        [self addToolBtnWithImage:[UIImage imageNamed:@"compose_toolbar_picture"] highlightImage:[UIImage imageNamed:@"compose_toolbar_picture_highlighted"] btnType:ZSComposeToolBarButtonTypePicture];
        
        [self addToolBtnWithImage:[UIImage imageNamed:@"compose_mentionbutton_background"] highlightImage:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] btnType:ZSComposeToolBarButtonTypeMention];
        
        [self addToolBtnWithImage:[UIImage imageNamed:@"compose_trendbutton_background"] highlightImage:[UIImage imageNamed:@"compose_trendbutton_background_highlighted"] btnType:ZSComposeToolBarButtonTypeTrend];
        
        self.emotionBtn = [self addToolBtnWithImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] highlightImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] btnType:ZSComposeToolBarButtonTypeEmotion];
        
    }
    return self;
}

/**
 *  键盘转换的图片转换
 *
 */
- (void)switchKeyboardWitgImage:(NSString *)image highLightImage:(NSString *)highLightImage
{
    UIButton *emotionBtn = self.emotionBtn;
    [emotionBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [emotionBtn setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];

}


- (UIButton *)addToolBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage btnType:(ZSComposeToolBarButtonType)btnType
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightImage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = btnType;
    [self addSubview:btn];
    
    return btn;
}

//按钮监听方法
- (void)didClickButton:(UIButton *)button
{
    ZSComposeToolBarButtonType btnType = (ZSComposeToolBarButtonType)button.tag;
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)]) {
        [self.delegate composeToolBar:self didClickButton:btnType];
    }
}

/**计算位置*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn = self.subviews[i];
        
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
        btn.y = 0;
    }
    
}

- (void)dealloc
{
    //消除通知对象
    [LBNotificationCenter removeObserver:self];
}


@end











