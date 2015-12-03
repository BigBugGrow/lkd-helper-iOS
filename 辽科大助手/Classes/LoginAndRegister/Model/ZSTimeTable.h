//
//  ZSTimeTable.h
//  辽科大助手
//
//  Created by DongAn on 15/12/3.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
/**
 *  {\"name\":\"13\",\"week\":\"[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]\",\"course\":\"\\u6750\\u6599\\u529b\\u5b66\",\"classroom\":\"1\\u53f7\\u697cA\\u533aa111\",\"mark\":\"\\u5468\\u65b0\\u7965*\\u5fc5\\u4fee\"}
 */
@interface ZSTimeTable : NSObject<NSCoding>
@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSArray *week;

@property (nonatomic,copy)NSString *course;

@property (nonatomic,copy)NSString *classroom;

@property (nonatomic,copy)NSString *mark;
@end
