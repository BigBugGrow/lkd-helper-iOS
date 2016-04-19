//
//  ZSCourse.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/19.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSCourse.h"

@implementation ZSCourse

- (NSString *)description
{
    return [NSString stringWithFormat:@"courseName: %@ %@ courseplace: %@ 周数: %ld 第几节: %ld  %@", self.courseName , self.coursePlace, self.weekCourses, self.courseNum, self.weekCourse,self.neccesaryCourse];
}


@end
