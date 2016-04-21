//
//  UIImage+Extension.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/21.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


#pragma mark - 保存图片

//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key;

//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString*)key;

//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key;

/** 图片压缩*/
//图片压缩到指定大小
+ (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)sourceImage;

@end
