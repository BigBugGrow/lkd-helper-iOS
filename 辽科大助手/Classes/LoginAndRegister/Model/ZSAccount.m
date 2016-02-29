//
//  ZSAccount.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSAccount.h"

//@property (nonatomic,assign)NSInteger state;
//
//@property (nonatomic,copy)NSString *nickname;
//
//@property (nonatomic,copy)NSString *key;
//
//@property (nonatomic,copy)NSString *password;
//
//@property (nonatomic,copy)NSString *zjh;
//
//@property (nonatomic,copy)NSString *mm;
//
//@property (nonatomic,copy)NSString *sex;
//
//@property (nonatomic,copy)NSString *hasTimetable;
//
//@property (nonatomic,strong)NSArray *timetable;
//
//@property (nonatomic,copy)NSString *college;
//
//@property (nonatomic,copy)NSString *major;
//
//@property (nonatomic,copy)NSString *home;
//
//@property (nonatomic,copy)NSString *phone;
//
//@property (nonatomic,copy)NSString *qq;
//
//@property (nonatomic,copy)NSString *wechat;
//
//@property (nonatomic,copy)NSString *weibo;


#define ZSWxid @"wxid"
#define ZSNickname @"nickname"
#define ZSXh @"xh"
#define ZSPassword @"password"
#define ZSSex @"sex"
#define ZSSchool @"school"
#define ZSMajor @"major"
#define ZSHome @"home"
#define ZSDate @"date"
#define ZSWx @"wx"
#define ZSWb @"wb"
#define ZSQq @"qq"
#define ZSPhone @"phone"
#define ZSStartWeek @"startweek"
#define ZSTimetable @"timetable"

@implementation ZSAccount

MJCodingImplementation   //NSArchive  将模型存档  不用自己去手动敲

- (NSString *)description
{
    return [NSString stringWithFormat:@"state:%ld\nnickname:%@\nkey:%@\npassword:%@\nzjh:%@\nmm:%@\nsex:%@\nhasTimetable:%@\ncollege:%@\nmajor:%@\nhome:%@\nwechate:%@\nweibo:%@\nqq:%@\nphone:%@\ntimetable:%@\n",_state,_nickname,_key,_password,_zjh,_mm,_sex,_hasTimetable,_college,_major,_home,_wechat,_weibo,_qq,_phone,_timetable];
}
@end
