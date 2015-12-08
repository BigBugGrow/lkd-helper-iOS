//
//  NSDate+Convert.h
//  辽科大助手
//
//  Created by DongAn on 15/12/7.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Convert)
//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date;
//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string;
@end
