//
//  ZSComment.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSComment.h"
#import "NSDate+Extension.h"

@implementation ZSComment

- (NSString *)description
{
    return [NSString stringWithFormat:@"nickname: %@, comment: %@, date:%@", self.nickname, self.comment, self.date];
}



/**
 *  重写getter方法，设置时间格式
 */

/**
 1.今年
 1.今天
 *1分钟内 刚刚
 *1分 ~ 59分 xx分
 *大于60分钟  xx小时前
 2.昨天
 昨天  xx：xx
 3.其他
 * xx-xx  xx：xx
 2.非今年
 1.xxxx-xx-xx日
 */
/*
- (NSString *)date
{
 
    //     Sun Jan 10 09:36:34 +0800 2016
    //    NSDateFormatter == EEE MMM dd HH:mm:ss Z yyyy
    // NSString --> NSDate
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期格式
    
    //如果是真机调试 转换这种欧美时间 需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    //微博创建时间的日期
    NSDate *createDate = [fmt dateFromString:_date];
    
    //当前日期
    NSDate *now = [NSDate date];
    
    //日历对象(方便比较时间之间的差距)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //    NSCalendarUnitYear
    //    NSCalendarUnitMonth
    //    NSCalendarUnitDay
    //    NSCalendarUnitHour
    //    NSCalendarUnitMinute
    //    NSCalendarUnitSecond
    
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:calendarUnit fromDate:createDate toDate:now options:0];
    
    //判断时间在哪个阶段里
    if ([createDate isSameYear]) {
        
        if ([createDate isYestoday]) {
            
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToDay]) {
            //*大于60分钟  xx小时前
            if (cmps.hour >= 1) {
                
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if(cmps.minute >= 1){
                //*1分 ~ 59分 xx分
                
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            }
            //*1分钟内 刚刚
            return @"刚刚";
            
        } else { //其他
            //* xx-xx  xx：xx
            fmt.dateFormat = @"MM dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { //过去的哪一年
        //1.xxxx-xx-xx日
        fmt.dateFormat = @"yyyy MM dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
    
    return _date;
}
*/
@end
