//
//  UITextView+Extensiton.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/18.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "UITextView+Extensiton.h"

@implementation UITextView (Extensiton)

/**
 *  插入图片属性的文字
 */
- (void)insertAttributeText:(NSAttributedString *)attributeText settingBlock:(void(^)(NSMutableAttributedString *attributeString)) settingBlock
{
    //self.textView.selectedRange  选中的地方
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    
    //拼接之前的文字
    [attributeString appendAttributedString:self.attributedText];
    
    NSUInteger loc = self.selectedRange.location;
    
    //设置插入地方的方法
//    [attributeString insertAttributedString:attributeText atIndex:loc];
    
    //插入表情覆盖选中的文字
    [attributeString replaceCharactersInRange:self.selectedRange withAttributedString:attributeText];
    
    //调用block方法设置字体属性, 
    if (settingBlock) {
       settingBlock(attributeString);
    }
    
    //拼接字符串
    self.attributedText = attributeString;
    
    
    //将光标复原
    self.selectedRange = NSMakeRange(loc + 1, 0);
    
    //设置字体

}




@end
