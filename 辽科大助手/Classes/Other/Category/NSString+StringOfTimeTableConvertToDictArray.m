//
//  NSString+StringOfTimeTableConvertToDictArray.m
//  辽科大助手
//
//  Created by DongAn on 15/12/7.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "NSString+StringOfTimeTableConvertToDictArray.h"
#import "NSString+ReplaceUnicode.h"

@implementation NSString (StringOfTimeTableConvertToDictArray)


+ (NSArray *)stringTimeTableConvertToDictArray:(NSString *)stringTimeTable
{
    NSMutableArray *dictArr = [NSMutableArray array];
    
    //  NSLog(@"%@",stringTimeTable);
    
    NSArray *dictStringArr = [stringTimeTable componentsSeparatedByString:@"},"];
    for (NSString *dictStr in dictStringArr) {
        
        // NSLog(@"%@\n",dictStr);
        NSArray *keyValueStrArr = [dictStr componentsSeparatedByString:@"\","];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *keyValueStr in keyValueStrArr) {
            
            //  NSLog(@"%@\n",keyValueStr);
            
            if ([keyValueStr containsString:@"name"]) {
                NSRange nameRange = [keyValueStr rangeOfString:@"name"];
                NSString *nameKey = [keyValueStr substringWithRange:nameRange];
                NSString *nameValue = [keyValueStr substringFromIndex:nameRange.location + nameRange.length + 3];
                dict[nameKey] = nameValue;
            }
            if ([keyValueStr containsString:@"week"]) {
                NSRange weekRange = [keyValueStr rangeOfString:@"week"];
                NSString *weekKey = [keyValueStr substringWithRange:weekRange];
                NSString *weekValue = [keyValueStr substringFromIndex:weekRange.location + weekRange.length + 3];
                
                //取出头和尾 []
                NSString *weekValueSubPre = [weekValue substringFromIndex:1];
                NSString *weekValueSubPreAndSuf = [weekValueSubPre substringToIndex:weekValueSubPre.length];
                
                NSArray *weekStrNumArr = [weekValueSubPreAndSuf componentsSeparatedByString:@","];
                NSMutableArray *weekNumArr = [NSMutableArray array];
                for (NSString *str in weekStrNumArr) {
                    [weekNumArr addObject:[NSNumber numberWithInteger:[str integerValue]]];
                }
                
                dict[weekKey] = weekNumArr;
            }
            if ([keyValueStr containsString:@"course"]) {
                NSRange courseRange = [keyValueStr rangeOfString:@"course"];
                NSString *courseKey = [keyValueStr substringWithRange:courseRange];
                NSString *courseValue = [keyValueStr substringFromIndex:courseRange.location + courseRange.length + 3];
                [courseValue stringByAppendingString:@"\""];
                dict[courseKey] = [NSString replaceUnicode:courseValue];
            }
            if ([keyValueStr containsString:@"classroom"]) {
                NSRange classroomRange = [keyValueStr rangeOfString:@"classroom"];
                NSString *classroomKey = [keyValueStr substringWithRange:classroomRange];
                NSString *classroomValue = [keyValueStr substringFromIndex:classroomRange.location + classroomRange.length + 3];
                dict[classroomKey] = [NSString replaceUnicode:classroomValue];
            }
            if ([keyValueStr containsString:@"mark"]) {
                NSRange markRange = [keyValueStr rangeOfString:@"mark"];
                NSString *markKey = [keyValueStr substringWithRange:markRange];
                NSString *markValueTemp = [keyValueStr substringFromIndex:markRange.location + markRange.length + 3];
                NSString *markValue = [markValueTemp componentsSeparatedByString:@"\""][0];
                dict[markKey] = [NSString replaceUnicode:markValue];
            }
            
        }
        [dictArr addObject:dict];
    }
    
    //    NSLog(@"++++++++%@\n",dictArr);
    //    for (NSDictionary *dict in dictArr) {
    //        NSLog(@"%@",dict);
    //    }
    
    
    return dictArr;
}

@end
