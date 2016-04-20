//
//  ZSRightButton.h
//  新浪微博
//
//  Created by MacBook Pro on 16/1/2.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSRightButton.h"

@implementation ZSRightButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
//        self.imageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
//        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    
    frame.size.width += 10;
    [super setFrame:frame];
}

//设置子控件的尺寸
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //在这个方法中修改控件的位置，是最靠谱的
    self.titleLabel.x = self.imageView.x;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 10;

}

//重写settitle方法
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}

@end



//测试用的
//        self.backgroundColor = [UIColor redColor];
//        self.imageView.backgroundColor = RGBColor(249, 249, 249);
//        self.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:200 alpha:0.2];


//self.imageView.contentMode = UIViewContentModeCenter;
//        只有当标题和图片为固定死的时候才能够使用，否则很容易会出错
//        self.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, 0);
//        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);

//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    [super titleRectForContentRect:contentRect];
//
//    NSDictionary *textAttrs = @{
//                                NSFontAttributeName : [UIFont systemFontOfSize:17]
//                                };
//    CGFloat titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:textAttrs context:nil].size.width;
//
//    CGFloat titleH = contentRect.size.height;
//    CGFloat titleX = contentRect.size.width - titleW - self.imageView.size.width;
//    CGFloat titleY = 0;
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}
//
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//
//    CGFloat imageW = 30;
//    CGFloat imageH = 30;
//    CGFloat imageX = contentRect.size.width - imageW;
//    CGFloat imageY = 0;
//    LBLog(@"imageRectForContentRect");
//    return CGRectMake(imageX, imageY, imageW, imageH);
//}
