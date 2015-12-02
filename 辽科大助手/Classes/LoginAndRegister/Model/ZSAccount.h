//
//  ZSAccount.h
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

/**
 code	:	1
 
 wxid	:	olQUJj4lSI9lU31iOBwDbcrEwFtA
 
 nickname	:	infinitytron
 
 xh	:	120143206067
 
 password	:	iu
 
 sex	:	boy
 
 school	:	材冶学院
 
 major	:	能源
 
 home	:	广东省汕头市
 
 date	:	2015-11-30
 
 wx	:	lee-1450
 
 wb	:	Libra-铭
 
 qq	:	372110675
 
 phone	:	13592821928
 
 startweek	:	36
 
 timetable	:
 */

#import <Foundation/Foundation.h>

@interface ZSAccount : NSObject
/**
 *  code是什么？
 */
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

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
