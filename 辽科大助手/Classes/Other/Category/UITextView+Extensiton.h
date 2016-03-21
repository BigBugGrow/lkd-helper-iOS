//
//  UITextView+Extensiton.h
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/18.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extensiton)

/**
 *  插入图片属性的文字
 */
- (void)insertAttributeText:(NSAttributedString *)attributeText settingBlock:(void(^)(NSMutableAttributedString *attributeString)) settingBlock;

@end
