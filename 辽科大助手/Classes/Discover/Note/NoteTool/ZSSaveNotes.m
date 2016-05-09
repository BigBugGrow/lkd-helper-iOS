//
//  ZSSaveNotes.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSSaveNotes.h"
#import "ZSNoteModel.h"

//拼接路径
#define ZSRecentNotePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentNotes.plist"]

NSMutableArray *_recentNotes;

@implementation ZSSaveNotes

+ (void)initialize
{
    //全部笔记
    _recentNotes = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSRecentNotePath];
    
    if (_recentNotes == nil) {
        
        _recentNotes = [NSMutableArray array];
    }
}

/**
 * 全部
 */
+ (void)saveresentNotes:(NSArray *)resentNotes
{
    
//    NSRange range = NSMakeRange(0, resentNotes.count);
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    //将新的数据添加到大数组的最前面
//    [_recentNotes addObjectsFromArray:resentNotes];
    
    [NSKeyedArchiver archiveRootObject:resentNotes toFile:ZSRecentNotePath];
}

/**
 *  吐槽
 */
+ (NSArray *)resentNotes
{
    
    return _recentNotes;
}


+ (void)removeNote:(NSInteger)index
{
    [_recentNotes removeLastObject];
//    [NSKeyedArchiver archiveRootObject:_recentNotes toFile:ZSRecentNotePath];
}


@end
