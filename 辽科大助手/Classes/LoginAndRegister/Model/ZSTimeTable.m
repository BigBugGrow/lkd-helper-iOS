//
//  ZSTimeTable.m
//  辽科大助手
//
//  Created by DongAn on 15/12/3.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSTimeTable.h"
#import "ZSWeek.h"
/**
 *  @property (nonatomic,copy)NSString *name;
 
 @property (nonatomic,copy)NSArray *week;
 
 @property (nonatomic,copy)NSString *course;
 
 @property (nonatomic,copy)NSString *classroom;
 
 @property (nonatomic,copy)NSString *mark;

 */
#define ZSName @"name"
#define ZSWeek @"week"
#define ZSCourse @"course"
#define ZSClassroom @"classroom"
#define ZSMark @"mark"

@implementation ZSTimeTable
//+ (NSDictionary *)objectClassInArray
//{
//    return @{@"week":[ZSWeek class]};
//}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:ZSName];
    [aCoder encodeObject:_week forKey:ZSWeek];
    [aCoder encodeObject:_course forKey:ZSCourse];
    [aCoder encodeObject:_classroom forKey:ZSClassroom];
    [aCoder encodeObject:_mark forKey:ZSMark];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:ZSName];
        _week = [aDecoder decodeObjectForKey:ZSWeek];
        _course = [aDecoder decodeObjectForKey:ZSCourse];
        _classroom = [aDecoder decodeObjectForKey:ZSClassroom];
        _mark = [aDecoder decodeObjectForKey:ZSMark];

    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@\nweek:%@\ncourse:%@\nclassroom:%@\nmark:%@\n",_name,_week,_course,_classroom,_mark];
}

@end
