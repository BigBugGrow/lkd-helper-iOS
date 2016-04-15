//
//  ZSNovcltyTool.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/30.
//  Copyright © 2016年 USTL. All rights reserved.
//

/** 本想做一个数据缓存， 但是显示表情 有一个bug 表情字体会变大*/


#import <Foundation/Foundation.h>

@interface ZSNovcltyTool : NSObject

/**
 *  存表情模型
 */
+ (void)saveAllNovcltys:(NSArray *)allDynamicFrames;

/**
 *  取出表情
 */
+ (NSArray *)resentAllNovcltys;



/**
 *  存表情模型
 */
+ (void)saveDiscloseBoardNovcltys:(NSArray *)allDynamicFrames;

/**
 *  取出表情
 */
+ (NSArray *)resentDiscloseBoardNovcltys;



/**
 *  存表情模型
 */
+ (void)saveConfessionWallNovcltys:(NSArray *)allDynamicFrames;

/**
 *  取出表情
 */
+ (NSArray *)resentConfessionWallNovcltys;



/**
 *  存表情模型
 */
+ (void)saveTopicsNovcltys:(NSArray *)allDynamicFrames;

/**
 *  取出表情
 */
+ (NSArray *)resentTopicsNovcltys;


@end
