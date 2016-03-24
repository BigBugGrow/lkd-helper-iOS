//
//  NSDate+Extension.m
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/10.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


//判断是否是同一年
- (BOOL)isSameYear
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *createDate = [calendar components:unit fromDate:self];
    NSDateComponents *nowDate = [calendar components:unit fromDate:[NSDate date]];
    
    return createDate.year == nowDate.year;
}

//是否是昨天
- (BOOL)isYestoday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy MM dd";
    
    NSString *createDateStr = [fmt stringFromDate:self];
    NSString *currentDateStr = [fmt stringFromDate:[NSDate date]];
    
    NSDate *date = [fmt dateFromString:createDateStr];
    NSDate *currentDate = [fmt dateFromString:currentDateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *cpmts = [calendar components:unit fromDate:currentDate  toDate:date options:0];
    
    return cpmts.year == 0 && cpmts.month == 0 && cpmts.day == 1;
}

//判断是否是今天
- (BOOL)isToDay
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy MM dd";
    
    NSString *createDateStr = [fmt stringFromDate:self];
    NSString *currentDateStr = [fmt stringFromDate:[NSDate date]];
    
    return [createDateStr isEqualToString:currentDateStr];
}



@end
