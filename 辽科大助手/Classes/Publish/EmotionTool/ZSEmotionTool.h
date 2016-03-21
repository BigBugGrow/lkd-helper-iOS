//
//  LBEmotionTool.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSEmotion;

@interface ZSEmotionTool : NSObject

/**
 *  存表情模型
 */
+ (void)saveEmotiom:(ZSEmotion *)emotion;

/**
 * 根据表情描述，返回表情
 *
 *  @param 表情描述
 */
+ (ZSEmotion *)emotionWithCht:(NSString *)cht;

/**
 *  取出最近表情
 */
+ (NSArray *)resentEmotions;

/**
 * 默认表情
 */
+ (NSArray *)defaultEmotions;


/**
 * 浪小花表情
 */
+ (NSArray *)lxhEmotions;


/**
 * emoji表情
 */
+ (NSArray *)emojiEmotions;

@end
