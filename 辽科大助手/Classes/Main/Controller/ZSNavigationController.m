//
//  ZSNavigationController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/29.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNavigationController.h"
#import "UIBarButtonItem+Item.h"
#import "UIImage+Image.h"
#import "ZSMyInfoViewController.h"

#import "ZSHomeViewController.h"
#import "ZSMessageViewController.h"
#import "ZSDiscoverViewController.h"
#import "ZSProfileViewController.h"

@implementation ZSNavigationController

+ (void)initialize
{
    

    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"blue"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    bar.titleTextAttributes = titleAttr;
    

}


//#pragma mark 导航控制器的子控制器被push 的时候会调用
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
   // NSLog(@"%@",viewController);
//    //设置 push 新控制器的时候 隐藏Tabbar
    if (![viewController isKindOfClass:[ZSHomeViewController class]] && ![viewController isKindOfClass:[ZSMessageViewController  class]] && ![viewController isKindOfClass:[ZSDiscoverViewController class]] && ![viewController isKindOfClass:[ZSProfileViewController class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

@end
