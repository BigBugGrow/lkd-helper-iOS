//
//  ZSEmotionTool.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionTool.h"
#import "ZSEmotion.h"
#import "MJExtension.h"
//拼接路径
#define ZSRecentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentEmotions.plist"]

NSMutableArray *_recentEmotions;

@interface ZSEmotionTool ()

@end

static NSArray *_defaultEmotions, *_lxhEmotions, *_emojiEmotions;

@implementation ZSEmotionTool

+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSRecentEmotionPath];
    
    if (_recentEmotions == nil) {
        
        _recentEmotions = [NSMutableArray array];
    }
}

/**
 * 根据表情描述，返回表情
 *
 *  @param 表情描述
 */
+ (ZSEmotion *)emotionWithCht:(NSString *)cht
{
    NSArray *defaultEmotions = [self defaultEmotions];
    for (ZSEmotion *emotion in defaultEmotions) {
        if ([emotion.cht isEqualToString:cht]) {
            return emotion;
        }
    }
    
    NSArray *lxhEmotions = [self lxhEmotions];
    for (ZSEmotion *emotion in lxhEmotions) {
        if ([emotion.cht isEqualToString:cht]) {
            return emotion;
        }
    }
    
    return nil;
}


/**
 * 默认表情
 */
+ (NSArray *)defaultEmotions;
{
    
    if (_defaultEmotions == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/def/abc.plist" ofType:nil];
        //字典数组转换成模型数组
        _defaultEmotions = [ZSEmotion objectArrayWithFile:path];
    }
    return _defaultEmotions;
}


/**
 * 浪小花表情
 */
+ (NSArray *)lxhEmotions
{
    if (_lxhEmotions == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/abc.plist" ofType:nil];
        //字典数组转换成模型数组
        _lxhEmotions = [ZSEmotion objectArrayWithFile:path];
    }
    return _lxhEmotions;

}

/**
 * emoji表情
 */
+ (NSArray *)emojiEmotions
{
    if (_emojiEmotions == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/abc.plist" ofType:nil];
        //字典数组转换成模型数组
        _emojiEmotions = [ZSEmotion objectArrayWithFile:path];
    }
    return _emojiEmotions;

}


/**
 *  存表情模型
 */
+ (void)saveEmotiom:(ZSEmotion *)emotion
{
    
    //将最近重复的表情删除掉
    [_recentEmotions removeObject:emotion];
    
//    for (int i = 0; i < _recentEmotions.count; i ++) {
//        
//        LBEmotion *e = _recentEmotions[i];
//        if ([emotion.cht isEqual:e.cht]) {
//            
//            [_recentEmotions removeObject:e];
//            break;
//        }
//    }
    
    //插入表情到数组第一个
    [_recentEmotions insertObject:emotion atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:ZSRecentEmotionPath];
}

/**
 *  取出表情
 */
+ (NSArray *)resentEmotions
{
    return _recentEmotions;
}

@end
