//
//  AppDelegate.m
//  辽科大助手
//
//  Created by DongAn on 15/11/24.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "AppDelegate.h"
#import "ZSTabBarController.h"
#import "ZSNewFeatureController.h"
#import "ZSNavigationController.h"
#import "ZSLoginViewController.h"
#import "SDWebImageManager.h"
#import "ZSHomeViewController.h"


#import "ZSRootTool.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
//        
//        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
//        
//        //注册通知类型
//        [application registerUserNotificationSettings:settings];
//    }
    
    
    //注册本地通知
//    [self registerLocalNotification:5];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    //判断当前是否有新的版本，如果有，进入新特性界面
//    ZSNewFeatureController *newFeatureVC = [[ZSNewFeatureController alloc] init];
//    
//    self.window.rootViewController = newFeatureVC;
    
//    ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
//    
//    self.window.rootViewController = tabBarVC;
    
    //登录界面
//    ZSLoginViewController *loginVC = [[ZSLoginViewController alloc] init];
//    
//    ZSNavigationController *loginNavigationVC = [[ZSNavigationController alloc] initWithRootViewController:loginVC];
//    
//    self.window.rootViewController = loginNavigationVC;
    
    [ZSRootTool chooseRootViewController:self.window];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
    //清除图片缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
    //取消正在下载的图片
    [[SDWebImageManager sharedManager] cancelAll];
}


//#pragma mark - 本地通知
//// 设置本地通知
//- (void)registerLocalNotification:(NSInteger)alertTime {
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    // 设置触发通知的时间
//    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//    
//    //获取本地时区(中国时区)
//    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
//    
//    //计算世界时间与本地时区的时间偏差值
//    NSInteger offset = [localTimeZone secondsFromGMTForDate:fireDate];
//    
//    //世界时间＋偏差值 得出中国区时间
//    NSDate *localDate = [fireDate dateByAddingTimeInterval:offset];
//    
//    ZSLog(@"fireDate=%@",fireDate);
//    
//    ZSLog(@"fireDate=%@",localDate);
//    
//    notification.fireDate = fireDate;
//    //    notification.fireDate = [NSDate dateWithTimeIntervalSince1970:];
//    // 时区
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    // 设置重复的间隔
//    notification.repeatInterval = kCFCalendarUnitMinute;
//    
//    // 通知内容
//    notification.alertBody =  @"该去上课喽";
//    //    notification.applicationIconBadgeNumber = 20;
//    // 通知被触发时播放的声音
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    // 通知参数
//    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始新的一天喽！" forKey:@"key"];
//    notification.userInfo = userDict;
//    
//    // ios8后，需要添加这个注册，才能得到授权
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSCalendarUnitDay;
//    } else {
//        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSCalendarUnitDay;
//    }
//    
//    // 执行通知注册
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//}
//
//
//// 取消某个本地推送通知
//- (void)cancelLocalNotificationWithKey:(NSString *)key {
//    // 获取所有本地通知数组
//    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
//    
//    for (UILocalNotification *notification in localNotifications) {
//        NSDictionary *userInfo = notification.userInfo;
//        if (userInfo) {
//            // 根据设置通知参数时指定的key来获取通知参数
//            NSString *info = userInfo[key];
//            
//            // 如果找到需要取消的通知，则取消
//            if (info != nil) {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//                break;
//            }
//        }
//    }
//}
//
//
//
//// 本地通知回调函数，当应用程序在前台时调用
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    NSLog(@"noti:%@",notification);
//    
//    // 这里真实需要处理交互的地方
//    // 获取通知所带的数据
//    NSString *notMess = [notification.userInfo objectForKey:@"key"];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
//                                                    message:notMess
//                                                   delegate:nil
//                                          cancelButtonTitle:@"我知道了"
//                                          otherButtonTitles:nil];
//    [alert show];
//    
////    // 更新显示的徽章个数
////    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
////    badge--;
////    badge = badge >= 0 ? badge : 0;
////    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
////    
//    // 在不需要再推送时，可以取消推送
//    [self cancelLocalNotificationWithKey:@"key"];
//}



@end
