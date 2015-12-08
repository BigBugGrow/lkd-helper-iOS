//
//  UIImage+Image.h
//  辽科大助手
//
//  Created by DongAn on 15/11/29.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

/**
 *
 *  @param imageName    需要裁剪的图片
 *  @param borderColor 边框的颜色
 *  @param borderWidth 边框的宽度
 *  @return 一个裁剪 带有边框的圆形图片
 */
+(UIImage *)circleImageWithImageName:(NSString *)imageName borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

+(UIImage *)circleImageWithImage:(UIImage *)image borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
