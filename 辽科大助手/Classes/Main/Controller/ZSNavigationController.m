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
    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    bar.titleTextAttributes = titleAttr;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    

}


//#pragma mark 导航控制器的子控制器被push 的时候会调用
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{


    if (self.viewControllers.count > 0) {
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        
        [viewController.navigationItem.leftBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
        
        [viewController.navigationItem.leftBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateHighlighted];
        
        //当push后 隐藏tarbar
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];

}

// 退出
- (void)exitViewController
{
    [self popToRootViewControllerAnimated:YES];
}


@end
