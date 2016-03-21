//
//  ZSEmotionKeyboard.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionKeyboard.h"
#import "ZSEmotionListView.h"
#import "ZSEmotionTabbar.h"
#import "MJExtension.h"
#import "ZSEmotionTool.h"

@interface ZSEmotionKeyboard ()<ZSEmotionTabbardelegate>

/**
 * 当前显示的listView
 */

@property (nonatomic, weak) ZSEmotionListView *currentListView;

//@property (nonatomic, weak) UIView *emotionContentView;

/** 最近表情*/
@property (nonatomic, strong) ZSEmotionListView *recentlyEmotionListView;

/** 默认表情*/
@property (nonatomic, strong) ZSEmotionListView *defoultEmotionListView;

/** Emoji表情*/
@property (nonatomic, strong) ZSEmotionListView *emojiEmotionListView;

/** 浪小花表情*/
@property (nonatomic, strong) ZSEmotionListView *lxhEmotionListView;

/**
 * tabBar
 */
@property (nonatomic, weak) ZSEmotionTabbar *emotionTabbar;

@end

@implementation ZSEmotionKeyboard

/**
 *  懒加载
 */

- (ZSEmotionListView *)recentlyEmotionListView
{
    if (_recentlyEmotionListView == nil) {
        
        _recentlyEmotionListView = [[ZSEmotionListView alloc] init];
        _recentlyEmotionListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        _recentlyEmotionListView.emotions = [ZSEmotionTool resentEmotions];
        
    }
    return _recentlyEmotionListView;
}

- (ZSEmotionListView *)defoultEmotionListView
{
    if (_defoultEmotionListView == nil) {
        
        _defoultEmotionListView = [[ZSEmotionListView alloc] init];
        
        _defoultEmotionListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        _defoultEmotionListView.emotions = [ZSEmotionTool defaultEmotions];
    }
    return _defoultEmotionListView;
}

- (ZSEmotionListView *)emojiEmotionListView
{
    if (_emojiEmotionListView == nil) {
        
        _emojiEmotionListView = [[ZSEmotionListView alloc] init];
        
        _emojiEmotionListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
    
        
        //字典数组转换成模型数组
        _emojiEmotionListView.emotions = [ZSEmotionTool emojiEmotions];
    }
    return _emojiEmotionListView;
}

- (ZSEmotionListView *)lxhEmotionListView
{
    if (_lxhEmotionListView == nil) {
        
        _lxhEmotionListView = [[ZSEmotionListView alloc] init];
        
        _lxhEmotionListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        //字典数组转换成模型数组
        _lxhEmotionListView.emotions = [ZSEmotionTool lxhEmotions];
    }
    return _lxhEmotionListView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //1.添加表情栏
        ZSEmotionListView *emotionContentView = [[ZSEmotionListView alloc] init];
        [self addSubview:emotionContentView];
        self.currentListView = emotionContentView;
        
        //2.添加tabBar
        ZSEmotionTabbar *tabBar = [[ZSEmotionTabbar alloc] init];
        
        //成为代理
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.emotionTabbar = tabBar;
    
        //监听点击表情按钮的通知
        //点击表情按钮得到通知
        [LBNotificationCenter addObserver:self selector:@selector(didClickEmotionBtn) name:LBDidClickEmotionButton object:nil];
    }
    return self;
}

//移除通知
- (void)dealloc
{
    [LBNotificationCenter removeObserver:self];
}

- (void)didClickEmotionBtn
{
    self.recentlyEmotionListView.emotions = [ZSEmotionTool resentEmotions];
}

- (void)layoutSubviews
{
    //1.设置tabBar的尺寸
    self.emotionTabbar.height = 37;
    self.emotionTabbar.width = self.width;
    self.emotionTabbar.x = 0;
    self.emotionTabbar.y = self.height - self.emotionTabbar.height;
    
//    //2.设置EmotionListView的尺寸
    self.currentListView.x = self.currentListView.y = 0;
    self.currentListView.width = self.width;
    self.currentListView.height = self.emotionTabbar.y;
    
    //3.设置contentView的所有子控件的frame
    //让子控件填充contentView父控件
//    [self.emotionContentView.subviews lastObject].frame = self.emotionContentView.bounds;
    
}

#pragma mark - LBEmotionTabbardelegate

- (void)emotionTabbar:(ZSEmotionTabbar *)emotionTabBar didClickTabBarButtonWithType:(ZSEmotionTabbarButtonType)buttonType
{
    
    //移除contentView里面的所有子控件
//    [self.emotionContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.currentListView removeFromSuperview];
    
    switch (buttonType) {
        case ZSEmotionTabbarButtonTypeRecently:{ // 最近
        
            [self addSubview:self.recentlyEmotionListView];
            self.currentListView = self.recentlyEmotionListView;
            break;
        }
        case ZSEmotionTabbarButtonTypeDefoult:{ //默认
            
            [self addSubview:self.defoultEmotionListView];
            self.currentListView = self.defoultEmotionListView;
            break;
        }
        case ZSEmotionTabbarButtonTypeEmoji:{ //emoji
            
            [self addSubview:self.emojiEmotionListView];
            self.currentListView = self.emojiEmotionListView;
            break;
        }
        case ZSEmotionTabbarButtonTypeWaveFlower:{ //浪小花

            [self addSubview:self.lxhEmotionListView];
            self.currentListView = self.lxhEmotionListView;
            break;
        }
        default:
            break;
    }
    
    self.recentlyEmotionListView.emotions = [ZSEmotionTool resentEmotions];
    
   //重新调用layoutsubview方法([self setNeedsLayout]; 方法会在适当的时候重新调用layoutsubview方法)
    [self setNeedsLayout];
}



@end
