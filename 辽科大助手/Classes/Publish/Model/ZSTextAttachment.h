//
//  LBTextAttachment.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSEmotion;

@interface ZSTextAttachment : NSTextAttachment

//属性模型
@property (nonatomic, strong) ZSEmotion *emotion;

@end
