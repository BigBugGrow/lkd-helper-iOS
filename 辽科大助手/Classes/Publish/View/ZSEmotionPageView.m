//
//  ZSEmotionPageView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/15.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionPageView.h"
#import "ZSEmotion.h"
#import "ZSEmotionButton.h"
#import "ZSEmotionPopView.h"
#import "ZSEmotionTool.h"

@interface ZSEmotionPageView ()

/** 放大镜效果*/
@property (nonatomic, weak) ZSEmotionPopView *popView;

/** 添加删除按钮*/
@property (nonatomic, strong) UIButton *deleteButton;

@end


@implementation ZSEmotionPageView

/**
 * 初始化函数
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *deleteButton = [[UIButton alloc] init];
        
        /**
         *  添加删除按钮
         */
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteButton;
        
        /**
         *  添加长按手势
         */
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongGesture:)];
        
        [self addGestureRecognizer:longPressGesture];
        
    }
   return self;
}

//查找按钮位置在那个地方

- (ZSEmotionButton *)containsPointWithLocation:(CGPoint)location
{
    NSUInteger count = self.subviews.count;
    
    for (int i = 1; i < count; i ++) {
        ZSEmotionButton *emotionBtn = self.subviews[i];
        
        if (CGRectContainsPoint(emotionBtn.frame, location)) {
            
            return emotionBtn;
        }
    }
    return nil;
}
/**
 *  长按手势
 */
- (void)clickLongGesture:(UIGestureRecognizer *)recognizer
{
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    ZSEmotionButton *emotiomBtn = [self containsPointWithLocation:location];
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:{
          
            //传模型
            self.popView.emotion = emotiomBtn.emotion;
            //显示放大镜表情
            [self.popView showFromPopView:emotiomBtn];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
         
            //长按钮结束后， 添加表情到textView上面
            if (emotiomBtn) {

                NSMutableDictionary *info = [NSMutableDictionary dictionary];
                info[@"emotion"] = emotiomBtn;
                
                //发送通知向控制器，显示表情
                [ZSNotificationCenter postNotificationName:LBDidClickEmotionButton object:self userInfo:info];
   
            }
            //销毁放大镜表情
            [self.popView removeFromSuperview];
            break;
        }
        default:
            break;
    }
}


//删除按钮的监听方法
- (void)clickDeleteBtn
{
    [ZSNotificationCenter postNotificationName:LBDidClickDeleteButton object:nil];
}

- (ZSEmotionPopView *)popView
{
    if (_popView == nil) {
        
        ZSEmotionPopView *popView = [ZSEmotionPopView popView];
        _popView = popView;
    }
    return _popView;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    
    for (int i = 0; i < count; i ++) {
        
        ZSEmotionButton *btn = [[ZSEmotionButton alloc] init];
        
        ZSEmotion *emotion = emotions[i];
        
        btn.emotion = emotion;
        
        NSString *emoji = [emotion.code emoji];
        
        if (emotion.png) {
            
            [btn setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        } else if (emotion.code) {
            
            [btn setTitle:emoji forState:UIControlStateNormal];
            //图片为字体， 设置字体大小
            btn.titleLabel.font = [UIFont systemFontOfSize:32];
        }
        
        //监听按钮点击事件
        [btn addTarget:self action:@selector(clickEmotionBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

//监听按钮点击事件
- (void)clickEmotionBtn:(ZSEmotionButton *)emotionBtn
{
    
    /**
     *  将点击的按钮存起来
     */
    [ZSEmotionTool saveEmotiom:emotionBtn.emotion];
    
    self.popView.emotion = emotionBtn.emotion;
    
    //显示放大镜表情
    [self.popView showFromPopView:emotionBtn];
    
    /**
     *  当点击popview 之后 移除popview
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.popView removeFromSuperview];
    });
    
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"emotion"] = emotionBtn;
    
    //发送通知向控制器，显示表情
    [ZSNotificationCenter postNotificationName:LBDidClickEmotionButton object:self userInfo:info];

}

/**
 *  计算尺寸
 */

- (void)layoutSubviews
{
    [super layoutSubviews];

    //1.设置按钮frame
    NSUInteger count = self.emotions.count;

    //设置内边距
    CGFloat inset = 15;
    
    CGFloat btnW = (self.width - 2 * inset) / ZSEmotionPageRowsCount;
    CGFloat btnH = (self.height - 2 * inset - 30) / ZSEmotionPageColsCount;
    
//    LBLog(@"%lf", self.height);
    
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        
        btn.x = (i % ZSEmotionPageRowsCount) * btnW + inset;
        btn.y = (i / ZSEmotionPageRowsCount) * btnH + inset;
    }
    
    //2.设置deleteBtn的frame
    //deleteBtn 设置frame属性
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.x =  self.width - inset - self.deleteButton.width;
    self.deleteButton.y = self.height - self.deleteButton.height - inset - 30;
    
}


@end
