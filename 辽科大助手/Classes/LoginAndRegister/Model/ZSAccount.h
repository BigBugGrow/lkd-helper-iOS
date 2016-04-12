//
//  ZSAccount.h
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ZSAccount : NSObject<MJKeyValue,NSCoding>

@property (nonatomic,assign)NSInteger state;

@property (nonatomic,copy)NSString *nickname;

@property (nonatomic,copy)NSString *key;

@property (nonatomic,copy)NSString *password;

@property (nonatomic,copy)NSString *zjh;

@property (nonatomic,copy)NSString *mm;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *birthday;

@property (nonatomic,copy)NSString *hasTimetable;

@property (nonatomic,strong)NSArray *timetable;

@property (nonatomic,copy)NSString *college;

@property (nonatomic,copy)NSString *major;

@property (nonatomic,copy)NSString *home;

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *qq;

@property (nonatomic,copy)NSString *wechat;

@property (nonatomic,copy)NSString *weibo;

/** 真实姓名*/
@property (nonatomic, copy) NSString *name;

/** 班级*/
@property (nonatomic, copy) NSString *Class;

/** 学期开始*/
@property (nonatomic, copy) NSString *termBeginTime;


@end
