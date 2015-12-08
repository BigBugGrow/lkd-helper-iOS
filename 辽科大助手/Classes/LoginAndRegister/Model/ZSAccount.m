//
//  ZSAccount.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSAccount.h"


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
    return [NSString stringWithFormat:@"wxid:%@\nnickname:%@\nxh:%@\npassword:%@\nsex:%@\nschool:%@\nmajor:%@\nhome:%@\ndate:%@\nwx:%@\nwb:%@\nqq:%@\nphone:%@\nstartweek:%@\ntimetable:%@\n",_wxid,_nickname,_xh,_password,_sex,_school,_major,_home,_date,_wx,_wb,_qq,_phone,_startweek,_timetable];
}
@end
