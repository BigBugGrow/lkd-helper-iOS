//
//  ZSCourse.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/19.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSCourse : NSObject

/** 添加课程名*/
@property (nonatomic, copy) NSString *courseName;

/** 添加上课地点*/
@property (nonatomic, copy) NSString *coursePlace;

/** 必修 还是选修*/
@property (nonatomic, copy) NSString *neccesaryCourse;

/** 周几上课*/
@property (nonatomic, assign) NSInteger weekCourse;

/**第几大节课*/
@property (nonatomic, assign) NSInteger courseNum;

/**上课周次*/
@property (nonatomic, strong) NSMutableArray *weekCourses;

@end
