//
//  ZSWeek.m
//  辽科大助手
//
//  Created by DongAn on 15/12/3.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSWeek.h"
#define ZSWeekNum @"weekNum"
@implementation ZSWeek
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_weekNum forKey:ZSWeekNum];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {

        _weekNum = [aDecoder decodeObjectForKey:ZSWeekNum];

        
    }
    return self;
}
@end
