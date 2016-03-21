//
//  ZSEmotionTextView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/21.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSTextView.h"
@class ZSEmotion;
@interface ZSEmotionTextView : ZSTextView

/**
 *  emotion 表情模型
 */
@property (nonatomic, strong) ZSEmotion *emotion;

/**
 *  传递属性text
 */
- (NSString *)fullText;

@end
