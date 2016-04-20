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

#import "ZSHomeViewController.h"
#import "ZSMessageViewController.h"
#import "ZSDiscoverViewController.h"
#import "ZSProfileViewController.h"

@implementation ZSNavigationController

//+ (void)initialize
//{
//
////    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
//    
//    
//    UINavigationBar *bar = [[UINavigationBar alloc] init];
//    
//    [bar setBackgroundImage:[UIImage imageNamed:@"blue"] forBarMetrics:UIBarMetricsDefault];
//    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
//    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    bar.titleTextAttributes = titleAttr;
//    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    
//
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 如果滑动移除控制器的功能失效，清空代理(让导航控制器重新设置这个功能)
//    self.interactivePopGestureRecognizer.delegate = nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        
//        UINavigationBar *bar = [[UINavigationBar alloc] init];
        
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"blue"] forBarMetrics:UIBarMetricsDefault];
        NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
        titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
        titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
        self.navigationBar.titleTextAttributes = titleAttr;
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        

    }
    return self;
}


//#pragma mark 导航控制器的子控制器被push 的时候会调用
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{


    if (self.viewControllers.count > 0) {
        
        UIButton *backBtn = [[UIButton alloc] init];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [backBtn setImage:[UIImage imageNamed:@"rightBack"] forState:UIControlStateNormal];
        backBtn.size = CGSizeMake(70, 30);
        //设置按钮的内容靠左边
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //设置按钮的切割
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        //按钮内容有多少 size就有多大
        //    [backBtn sizeToFit];
        [backBtn addTarget:self action:@selector(exitViewController) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        //当push后 隐藏tarbar
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];

}

// 退出
- (void)exitViewController

{   [self popViewControllerAnimated:YES];
}


@end
