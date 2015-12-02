//
//  ZSRootTool.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSRootTool.h"
#define ZSVersionKey @"version"
@implementation ZSRootTool
+ (void)chooseRootViewController:(UIWindow *)window
{
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:ZSVersionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        //判断是否登录过
        if (1) {
            //直接进入主页
        } else {
            //进入登录界面
        }
    } else {
        //进入新特性界面
    }
}
@end
