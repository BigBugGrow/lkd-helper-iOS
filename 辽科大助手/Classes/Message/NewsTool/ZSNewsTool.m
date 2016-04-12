//
//  ZSNewsTool.m
//  辽科大助手
//
//  Created by DongAn on 15/12/9.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsTool.h"

#import "ZSNewsResult.h"


#define ZSHelperNewsFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"HelperNews.data"]

#define ZSUSTLNewsFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"USTLNews.data"]

static ZSNewsResult *_helperNews;
static ZSNewsResult *_ustlNews;


@implementation ZSNewsTool
+ (void)saveNewsResult:(ZSNewsResult *)newsResult WithType:(NSString *)newType
{
    if ([newType isEqualToString:@"newslkdhelperread"]) {
        
        [NSKeyedArchiver archiveRootObject:newsResult toFile:ZSHelperNewsFileName];
        
    } else {
        
        [NSKeyedArchiver archiveRootObject:newsResult toFile:ZSUSTLNewsFileName];
    }
    
    
}

+ (ZSNewsResult *)newsResultWithType:(NSString *)newType
{
    if ([newType isEqualToString:@"newslkdhelperread"]) {
        
        if (_helperNews == nil) {
            _helperNews = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSHelperNewsFileName];
        }
        
        return _helperNews;

    }
    
    if (_ustlNews == nil) {
        _ustlNews = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSUSTLNewsFileName];
    }
    return _ustlNews;
    
}

@end
