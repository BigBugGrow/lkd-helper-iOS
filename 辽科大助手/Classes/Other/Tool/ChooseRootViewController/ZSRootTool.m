//
//  ZSRootTool.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSRootTool.h"
#import "ZSLoginViewController.h"
#import "ZSNewFeatureController.h"
#import "ZSNavigationController.h"
#import "ZSAccountTool.h"
#import "ZSTabBarController.h"
#define ZSVersionKey @"version"
@implementation ZSRootTool
+ (void)chooseRootViewController:(UIWindow *)window
{
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:ZSVersionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        //判断是否登录过
        if ([ZSAccountTool account]) {
            ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
            window.rootViewController = tabBarVC;
        } else {
           //进入 登录界面
                ZSLoginViewController *loginVC = [[ZSLoginViewController alloc] init];
            
                ZSNavigationController *loginNavigationVC = [[ZSNavigationController alloc] initWithRootViewController:loginVC];
            
                window.rootViewController = loginNavigationVC;
        }
    } else {
        //进入新特性界面
        ZSNewFeatureController *vc = [[ZSNewFeatureController alloc] init];
        window.rootViewController = vc;
        
        //保存当前版本
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:ZSVersionKey];
    }
}
@end
