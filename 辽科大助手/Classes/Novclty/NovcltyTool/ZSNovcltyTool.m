//
//  ZSNovcltyTool.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/30.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSNovcltyTool.h"
#import "ZSAllDynamic.h"

//拼接路径
#define ZSRecentAllNovcltyPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentAllNovcltys.plist"]
//拼接路径
#define ZSRecentDiscloseBoardNovcltyPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentDiscloseBoardNovcltys.plist"]
//拼接路径
#define ZSRecentConfessionWallNovcltyPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentConfessionWallNovcltys.plist"]
//拼接路径
#define ZSRecentTopicNovcltyPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentTopicNovcltys.plist"]


NSMutableArray *_recentAllNovcltys;
NSMutableArray *_recentDiscloseBoardNovcltys;
NSMutableArray *_recentConfessionWallNovcltys;
NSMutableArray *_recentTopicNovcltys;

@interface ZSNovcltyTool ()

@end

@implementation ZSNovcltyTool

+ (void)initialize
{
    //全部动态
    _recentAllNovcltys = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSRecentAllNovcltyPath];
    
    if (_recentAllNovcltys == nil) {
        
        _recentAllNovcltys = [NSMutableArray array];
    }
    
    
    //吐槽
    
    _recentDiscloseBoardNovcltys = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSRecentDiscloseBoardNovcltyPath];
    
    if (_recentDiscloseBoardNovcltys == nil) {
        
        _recentDiscloseBoardNovcltys = [NSMutableArray array];
    }
    
    //表白
    _recentConfessionWallNovcltys = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSRecentConfessionWallNovcltyPath];
    
    if (_recentConfessionWallNovcltys == nil) {
        
        _recentConfessionWallNovcltys = [NSMutableArray array];
    }
    
    //话题
    _recentTopicNovcltys = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSRecentTopicNovcltyPath];
    
    if (_recentTopicNovcltys == nil) {
        
        _recentTopicNovcltys = [NSMutableArray array];
    }
}



/**
 * 全部
 */
+ (void)saveAllNovcltys:(NSArray *)allDynamics
{
    
    //将最近重复的表情删除掉
//    [_recentNovcltys removeObject:emotion];
    
    //    for (int i = 0; i < _recentEmotions.count; i ++) {
    //
    //        LBEmotion *e = _recentEmotions[i];
    //        if ([emotion.cht isEqual:e.cht]) {
    //
    //            [_recentEmotions removeObject:e];
    //            break;
    //        }
    //    }
    
    NSRange range = NSMakeRange(0, allDynamics.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    //将新的数据添加到大数组的最前面
    [_recentAllNovcltys insertObjects:allDynamics atIndexes:indexSet];
    
    [NSKeyedArchiver archiveRootObject:_recentAllNovcltys toFile:ZSRecentAllNovcltyPath];
}

/**
 *  吐槽
 */
+ (NSArray *)resentAllNovcltys
{

    return _recentAllNovcltys;
}


/**
 *  吐槽
 */
+ (void)saveDiscloseBoardNovcltys:(NSArray *)discloseBoardDynamics
{
    //插入表情到数组第一个
    
    NSRange range = NSMakeRange(0, discloseBoardDynamics.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    //将新的数据添加到大数组的最前面
    [_recentDiscloseBoardNovcltys insertObjects:discloseBoardDynamics atIndexes:indexSet];
    
    [NSKeyedArchiver archiveRootObject:_recentDiscloseBoardNovcltys toFile:ZSRecentDiscloseBoardNovcltyPath];
}

/**
 *  吐槽
 */
+ (NSArray *)resentDiscloseBoardNovcltys
{
    return _recentDiscloseBoardNovcltys;
}


/**
 *  表白
 */
+ (void)saveConfessionWallNovcltys:(NSArray *)confessionWallDynamics
{

    NSRange range = NSMakeRange(0, confessionWallDynamics.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    //将新的数据添加到大数组的最前面
    [_recentConfessionWallNovcltys insertObjects:confessionWallDynamics atIndexes:indexSet];
    

    
    [NSKeyedArchiver archiveRootObject:_recentConfessionWallNovcltys toFile:ZSRecentAllNovcltyPath];

}

/**
 *  表白
 */
+ (NSArray *)resentConfessionWallNovcltys
{
    return _recentConfessionWallNovcltys;
}



/**
 *  话题
 */
+ (void)saveTopicsNovcltys:(NSArray *)topicDynamics
{

    NSRange range = NSMakeRange(0, topicDynamics.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    //将新的数据添加到大数组的最前面
    [_recentTopicNovcltys insertObjects:topicDynamics atIndexes:indexSet];
    
    [NSKeyedArchiver archiveRootObject:_recentTopicNovcltys toFile:ZSRecentTopicNovcltyPath];

}

/**
 *  话题
 */
+ (NSArray *)resentTopicsNovcltys
{
    return _recentTopicNovcltys;
}


@end
