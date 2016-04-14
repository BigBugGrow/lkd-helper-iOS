//
//  ZSEmotionPart.h
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/23.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSEmotionPart : NSObject

/** 文字*/
@property (nonatomic, copy) NSString *text;

/** 范围*/
@property (nonatomic, assign) NSRange range;

/** 特殊文字*/
@property (nonatomic, assign, getter=isExpeical) BOOL expeicalText;

/** 表情*/
@property (nonatomic, assign, getter=isEmotion) BOOL emotion;
@end
