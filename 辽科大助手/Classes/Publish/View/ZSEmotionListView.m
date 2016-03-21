//
//  ZSEmotionListView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionListView.h"
#import "ZSEmotionPageView.h"

//屏幕的宽度
#define pageViewWidth [UIScreen mainScreen].bounds.size.width

@interface ZSEmotionListView () <UIScrollViewDelegate>
/** 滚动条*/
@property (nonatomic, weak) UIScrollView *scroView;

/** pageControl*/
@property (nonatomic, weak) UIPageControl *pageControl;

@end


@implementation ZSEmotionListView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        //1.添加scroView
        
        UIScrollView *scroView = [[UIScrollView alloc] init];
        [self addSubview:scroView];
        //设置不能滚动 去掉滚动条
        scroView.showsHorizontalScrollIndicator = NO;
        scroView.showsVerticalScrollIndicator = NO;
        //设置代理
        scroView.delegate = self;
        //去除弹簧效果
        scroView.bounces = NO;
        //设置分页
        scroView.pagingEnabled = YES;

        self.scroView = scroView;
        
        
        //2.添加pageController
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        
        //去除单行显示
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        pageControl.userInteractionEnabled = NO;
        pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
        self.pageControl = pageControl;
        
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    //移除先前scroview的表情，再重新加载到scroview上面
    [self.scroView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    //1.设置pagecontrol有多少页
    
    NSUInteger pageCount = (emotions.count + ZSEmotionCountOnePage - 1) / ZSEmotionCountOnePage;;
    self.pageControl.numberOfPages = pageCount;

    //2.设置scroview
    
    for (int i = 0; i < pageCount; i ++) {
        
        //添加自定义页表情控件
        ZSEmotionPageView *emotinPageView = [[ZSEmotionPageView alloc] init];
        
        NSRange range;
    
        range.location = i * ZSEmotionCountOnePage;
        
        //求得去掉i页还剩多少个表情
        NSUInteger length = emotions.count - range.location;
        
        //每页的最大表情个数
        
        NSUInteger pageCount = (ZSEmotionPageColsCount * ZSEmotionPageRowsCount) - 1;
        if (length >= pageCount) {
            
            range.length = ZSEmotionCountOnePage;
        } else {
            
            range.length = length;
        }
        
        //截取固定范围的字符数组
        emotinPageView.emotions = [emotions subarrayWithRange:range];
        
        [self.scroView addSubview:emotinPageView];

        //重新计算尺寸
        [self setNeedsLayout];
    }
    
}


/**
 *  设置尺寸
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.设置UIPageControl尺寸
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    
    //2.设置scroView尺寸
    self.scroView.width = self.width;
    self.scroView.height = self.pageControl.y;
    self.scroView.y = self.scroView.x = 0;
 
    
    //3.设置scroview里面的view的frame
    NSUInteger count = self.scroView.subviews.count;
    for (int i = 0; i < count; i ++) {
        ZSEmotionPageView *pageView = self.scroView.subviews[i];
        pageView.width = pageViewWidth;
        pageView.height = self.height;
        pageView.x = i * pageView.width;
        pageView.y = 0;
    }

    //4.设置scroview滚动的大小
    self.scroView.contentSize = CGSizeMake(count * pageViewWidth, 0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{}

#pragma mark - scroView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double currentPage = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(currentPage + 0.5);
}


@end
