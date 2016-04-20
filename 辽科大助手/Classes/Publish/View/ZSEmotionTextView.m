//
//  ZSEmotionTextView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/21.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionTextView.h"
#import "ZSEmotion.h"
#import "ZSTextAttachment.h"

@implementation ZSEmotionTextView

/**
 *  插入表情
 */

- (void)setEmotion:(ZSEmotion *)emotion
{
    
    if (emotion.code) {
        
        [self insertText:emotion.code.emoji];
    } else if(emotion.cht) {
        
        //加载图片
        ZSTextAttachment *attach = [[ZSTextAttachment alloc] init];
        
        //传递模型
        attach.emotion = emotion;
        
        CGFloat attachWH = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        
        NSAttributedString *imageStr = [NSMutableAttributedString attributedStringWithAttachment:attach];
        
        
        //插入图片文字
        [self insertAttributeText:imageStr settingBlock:^(NSMutableAttributedString *attributeString) {
            //设置字体
            [attributeString addAttribute:NSFontAttributeName value:self.font range: NSMakeRange(0, attributeString.length)];
            
        }];
    }
}

/**
 *  传递属性text
 */
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    /**
     * 遍历attribute属性
     */
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
       
        //若想把所有的图片文字 还有emoji表情，拿过来，就必须重新定义自己的NSAttachment
        ZSTextAttachment *attach = attrs[@"NSAttachment"];
        
        if (attach) {
            
            [fullText appendString:attach.emotion.cht];
        } else { //否则就是普通文字
            
            //获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}



@end
