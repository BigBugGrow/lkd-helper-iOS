//
//  NSString+Extension.h
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/10.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxWidth;
- (CGSize)sizeWithFont:(UIFont *)font;

@end
