//
//  UIImage+Image.m
//  辽科大助手
//
//  Created by DongAn on 15/11/29.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+(UIImage *)circleImageWithImageName:(NSString *)imageName borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    //需求：从位图上下文，裁剪图片[裁剪成圆形，也添加圆形的边框]，生成一张图片
    
    // 获取要裁剪的图片
    UIImage *img = [UIImage imageNamed:imageName];
    CGRect imgRect = CGRectMake(0, 0, img.size.width, img.size.height);
    
    // 1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    
#warning 在自定义的view的drawRect方法里，调用UIGraphicsGetCurrentContext获取的上下文，是图层上下文(Layer Graphics Context)
    // 1.1 获取位图上下文
    CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
    
    // 2.往位图上下裁剪图片
    
    // 2.1 指定一个圆形的路径，把圆形之外的剪切掉
    CGContextAddEllipseInRect(bitmapContext, imgRect);
    CGContextClip(bitmapContext);
    
    
    // 2.2 添加图片
    [img drawInRect:imgRect];
    
    // 2.3 添加边框
    // 设置边框的宽度
    CGContextSetLineWidth(bitmapContext, borderWidth);
    // 设置边框的颜色
    [borderColor set];
    CGContextAddEllipseInRect(bitmapContext, imgRect);
    CGContextStrokePath(bitmapContext);
    
    
    // 3.获取当前位图上下文的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束位图编辑
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
