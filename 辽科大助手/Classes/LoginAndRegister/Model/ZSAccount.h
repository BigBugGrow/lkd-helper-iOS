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

@property (nonatomic,assign)NSInteger code;

@property (nonatomic,copy)NSString *wxid;

@property (nonatomic,copy)NSString *nickname;

@property (nonatomic,copy)NSString *xh;

@property (nonatomic,copy)NSString *password;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *school;

@property (nonatomic,copy)NSString *major;

@property (nonatomic,copy)NSString *home;

@property (nonatomic,copy)NSString *date;

@property (nonatomic,copy)NSString *wx;

@property (nonatomic,copy)NSString *wb;

@property (nonatomic,copy)NSString *qq;

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *startweek;

@property (nonatomic,strong)NSArray *timetable;

#warning 新登录接口增加的字段,接口还不完善，之后还会修改

@property (nonatomic,copy)NSString *zjh;
@property (nonatomic,copy)NSString *mm;
@property (nonatomic,copy)NSString *key;
@end
