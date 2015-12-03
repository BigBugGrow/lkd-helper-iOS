//
//  ZSAccount.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSAccount.h"
#import "ZSTimeTable.h"

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
+ (NSDictionary *)objectClassInArray
{
    return @{@"timetable":[ZSTimeTable class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_wxid forKey:ZSWxid];
    [aCoder encodeObject:_nickname forKey:ZSNickname];
    [aCoder encodeObject:_xh forKey:ZSXh];
    [aCoder encodeObject:_password forKey:ZSPassword];
    [aCoder encodeObject:_sex forKey:ZSSex];
    [aCoder encodeObject:_school forKey:ZSSchool];
    [aCoder encodeObject:_major forKey:ZSMajor];
    [aCoder encodeObject:_home forKey:ZSHome];
    [aCoder encodeObject:_date forKey:ZSDate];
    [aCoder encodeObject:_wx forKey:ZSWx];
    [aCoder encodeObject:_wb forKey:ZSWb];
    [aCoder encodeObject:_qq forKey:ZSQq];
    [aCoder encodeObject:_phone forKey:ZSPhone];
    [aCoder encodeObject:_startweek forKey:ZSStartWeek];
    [aCoder encodeObject:_timetable forKey:ZSTimetable];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _wxid = [aDecoder decodeObjectForKey:ZSWxid];
        _nickname = [aDecoder decodeObjectForKey:ZSNickname];
        _xh = [aDecoder decodeObjectForKey:ZSXh];
        _password = [aDecoder decodeObjectForKey:ZSPassword];
        _sex = [aDecoder decodeObjectForKey:ZSSex];
        _school = [aDecoder decodeObjectForKey:ZSSchool];
        _major = [aDecoder decodeObjectForKey:ZSMajor];
        _home = [aDecoder decodeObjectForKey:ZSHome];
        _date = [aDecoder decodeObjectForKey:ZSDate];
        _wx = [aDecoder decodeObjectForKey:ZSWx];
        _wb = [aDecoder decodeObjectForKey:ZSWb];
        _qq = [aDecoder decodeObjectForKey:ZSQq];
        _phone = [aDecoder decodeObjectForKey:ZSPhone];
        _startweek = [aDecoder decodeObjectForKey:ZSStartWeek];
        _timetable = [aDecoder decodeObjectForKey:ZSTimetable];
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"wxid:%@\nnickname:%@\nxh:%@\npassword:%@\nsex:%@\nschool:%@\nmajor:%@\nhome:%@\ndate:%@\nwx:%@\nwb:%@\nqq:%@\nphone:%@\nstartweek:%@\ntimetable:%@\n",_wxid,_nickname,_xh,_password,_sex,_school,_major,_home,_date,_wx,_wb,_qq,_phone,_startweek,_timetable];
}
@end
