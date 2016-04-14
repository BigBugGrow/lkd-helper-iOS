//
//  ZSEssayTextView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEssayTextView.h"
#import "ZSSpecial.h"

@implementation ZSEssayTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //设置文字位置
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        //设置textView不能够点击
        self.editable = NO;
        //设置文字不能够滚动
        self.scrollEnabled = NO;
        
        self.userInteractionEnabled = NO;
        
        self.font = [UIFont systemFontOfSize:18];
    }
    return self;
}

/**
 *  初始化特殊字符串的矩形框
 */
- (void)setAttributedTextRect
{
    //取出特殊文字
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    
    
    ZSLog(@"%@", specials);
    
    
    for (ZSSpecial *special in specials) {
        
        self.selectedRange = special.range;
        
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        
        //必须设置此属性为原来的值，不然文字会被你选中
        self.selectedRange = NSMakeRange(0, 0);
        
        //存储特殊文字的矩形框数组
        NSMutableArray *specialRects = [NSMutableArray array];
        
        for (UITextSelectionRect *selectedRect in rects) {
            
            //如果是空的frame 直接过掉
            if (selectedRect.rect.size.width == 0 || selectedRect.rect.size.height == 0) continue;
            
            [specialRects addObject:[NSValue valueWithCGRect:selectedRect.rect]];
        }
        //特殊文字的矩形框
        special.rects = specialRects;
    }
}

///**
// *  判断触摸点是否在特殊矩形框内
// */
- (ZSSpecial *)specialRectWithPoint:(CGPoint)point
{
    //取出特殊文字
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    
    for (ZSSpecial *special in specials) {
        
        for (NSValue *rectValue in special.rects) {
            
            //如果点击的点在选中的表情上面 就显示颜色
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {
                
                return special;
            }
        }
    }
    return nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //有一个touch对象
    UITouch *touch = [touches anyObject];
    
    //返回点击位置坐标
    CGPoint point = [touch locationInView:self];
    
    //初始化特殊文字的矩形框
    [self setAttributedTextRect];
    
    ZSSpecial *special = [self specialRectWithPoint:point];
    
    for (NSValue *rectValue in special.rects) {
        
        UIView *tmp = [[UIView alloc] init];
        
        //设置tag
        tmp.tag = LBStatusTextViewCoverTag;
        
        tmp.backgroundColor = [UIColor redColor];
        
        tmp.frame = rectValue.CGRectValue;
        
        [self insertSubview:tmp atIndex:0];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self touchesCancelled:touches withEvent:event];
    });
}

//点击事件被打断， 就会调用取消的方法
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews) {
        
        if (view.tag == LBStatusTextViewCoverTag) {
            
            [view removeFromSuperview];
        }
    }
}

//拦截点击事件， 返回的view就是处理这个点击事件的目标
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    [super hitTest:point withEvent:event];
//
//}

//拦截点击事件 传送一个点击点 返回NO代表不是本身view的点击事件， 自己不会处理
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //初始化矩形框
    [self setAttributedTextRect];
    
    ZSSpecial *special = [self specialRectWithPoint:point];
    
    if (special) { //如果这个点击目标是在这个特殊的文字上面， 就是自己的点击点目标
        
        return YES;
    }
    return NO;
}

@end
