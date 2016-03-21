//
//  ZSTextView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/12.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSTextView.h"

@implementation ZSTextView

- (instancetype)init
{
    if (self = [super init]) {
        
        //设置通知 不能够设置代理， 代理只能设置一次 没有监听方法
        [LBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

//通知方法
- (void)textDidChange
{
    //重绘字体 自动调用drawRect方法
    [self setNeedsDisplay];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    //copy类型赋值用copy
    _placeHolder = [placeHolder copy];
    
    //重新画一下
    [self setNeedsDisplay];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    //重画
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    //重画
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.hasText) return;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    
    //给字体设置默认颜色
    attrs[NSForegroundColorAttributeName] = self.placeHolderColor ? self.placeHolderColor : [UIColor grayColor];
//    [self.placeHolder drawAtPoint:CGPointZero withAttributes:attrs];
    //
    [self.placeHolder drawInRect:CGRectMake(5, 8, self.width, self.height) withAttributes:attrs];
    
}



@end
