//
//  ZSDropDownMenu.h
//  新浪微博
//
//  Created by MacBook Pro on 16/1/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDropDownMenu.h"

@interface ZSDropDownMenu ()

//添加的内容属性
@property (nonatomic, weak) UIImageView *contentContainer;

@end

@implementation ZSDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //清空颜色
        self.backgroundColor = [UIColor clearColor];
        
        //创建菜单
        UIImageView *contentContainer = [[UIImageView alloc] init];
        UIImage *image = [[UIImage imageNamed:@"popover_background_right"] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
        contentContainer.image = image;
        //设置父控件能够交互
        contentContainer.userInteractionEnabled = YES;
        //添加到子控件
        [self addSubview:contentContainer];
        
        _contentContainer = contentContainer;
    }
    return self;
}

//懒加载
- (void)setContent:(UIView *)content
{
    _content = content;
    
    //1.改变content的位置
    content.x = 10;
    content.y = 15;
    
    //2.设置高度和宽度
    self.contentContainer.height = CGRectGetMaxY(content.frame) + 10;
    self.contentContainer.width = CGRectGetMaxX(content.frame) + 10;
    
    //3.添加到灰色图片中
    [self.contentContainer addSubview:content];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;

    self.content = contentViewController.view;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

//显示菜单
- (void)show:(UIView *)view
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //1.设置frame
    self.frame = window.bounds;
    
    //默认情况下，控件是以父控件左上角为坐标原点为原点
    //2.转换坐标系
    //将以view的原点为坐标原点的view.bounds转换为以window的原点为坐标原点
//    CGRect newFrame = [view convertRect:view.bounds toView:window];
    CGRect newFrame = [view convertRect:view.bounds toView:nil];
//    CGRect newFrame = [window convertRect:view.bounds fromView:view];
    
    //2.设置位置
//    self.contentContainer.centerX = CGRectGetMidX(newFrame);
    self.contentContainer.x = newFrame.origin.x - 110;
    self.contentContainer.y = CGRectGetMaxY(newFrame);
    
    //2.添加到UIWindow
    [window addSubview:self];
    
    if ([self.delegate respondsToSelector:@selector(dropDownMenuDidShow:)]) {
        [self.delegate dropDownMenuDidShow:self];
    }
}

//清除菜单
- (void)dismiss
{
    [self removeFromSuperview];
    
    //通知代理方法
    if ([self.delegate respondsToSelector:@selector(dropDownMenuDidDismiss:)]) {
        [self.delegate dropDownMenuDidDismiss:self];
    }
}

//添加手势，清除菜单
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //清除菜单
    [self dismiss];
}


@end
