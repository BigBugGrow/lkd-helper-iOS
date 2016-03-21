//
//  NSString+Extension.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/10.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "NSString+Extension.h"

#define iOS7 [[UIDevice currentDevice].systemVersion doubleValue]

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxWidth
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);

    //ios6 ios7 适配
    if (iOS7) {
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:size];
    }
    
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


@end
