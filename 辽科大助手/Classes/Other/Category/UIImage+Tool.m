//
//  UIImage+Tool.m
//  裁剪圆环图片
//
//  Created by MacBook Pro on 15/11/21.
//  Copyright © 2015年 USTL. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)

+ (UIImage *)imageWithName:(NSString *)imageName border:(CGFloat)border withColor:(UIColor *)color{
    
    //设置边距
    CGFloat borderW = border;
    
    //加载久的图片
    UIImage *oldImage = [UIImage imageNamed:imageName];
    
    //设置图片的大小
    CGFloat imageW = oldImage.size.width + borderW;
    CGFloat imageH = oldImage.size.height + borderW;
    
    CGFloat circleW = imageW > imageH ? imageH : imageW;
    
    //创建上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW, circleW), NO, 0.0);
    
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleW, circleW)];
    
    
    //将大圆提交到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    [color set];
    
    //渲染
    CGContextFillPath(ctx);
    
    CGRect rect = CGRectMake(borderW / 2, borderW / 2, oldImage.size.width, oldImage.size.height);
    
    //画小圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    //设置裁剪区域
    [clipPath addClip];
    
    //花图片
    [oldImage drawAtPoint:CGPointZero];
    
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndPDFContext();
   
    return newImage;
}

@end
