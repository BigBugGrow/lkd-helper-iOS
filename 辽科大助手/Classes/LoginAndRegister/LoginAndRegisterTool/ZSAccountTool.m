//
//  ZSAccountTool.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSAccountTool.h"
#import "ZSAccount.h"

/**
 (lldb) po NSHomeDirectory()
 /Users/DongAn/Library/Developer/CoreSimulator/Devices/9C42B58B-C12C-4C35-9A7B-5810CED62050/data/Containers/Data/Application/90436B60-F217-4568-9D9F-2B0E1DAE13E8
 */
@interface ZSAccountTool ()

/**account*/
//@property (nonatomic, strong) ZSAccount *account;

@end


#define ZSAccountFileName [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Account.data"]

@implementation ZSAccountTool

static ZSAccount *_account;
static id _instance;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[ZSAccountTool alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (void)saveAccount:(ZSAccount *)account
{
    _account = account;
    [NSKeyedArchiver archiveRootObject:account toFile:ZSAccountFileName];
}

+ (ZSAccount *)account
{
    if (_account == nil) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSAccountFileName];
    }
    
    return _account;
}


+ (void)saveAccountTimeTable:(NSArray *)timeTable
{
    _account.timetable = timeTable;
    [self saveAccount:_account];
}
@end
