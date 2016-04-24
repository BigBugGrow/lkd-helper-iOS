//
//  ZSTabBarController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSTabBarController.h"

#import "ZSHomeViewController.h"
#import "ZSMessageViewController.h"
#import "ZSDiscoverViewController.h"
#import "ZSProfileViewController.h"
#import "ZSNavigationController.h"
#import "ZSTabBar.h"

#import "UIImage+Image.h"

#import "ZSNewsController.h"

@interface ZSTabBarController ()

@end

@implementation ZSTabBarController


+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = RGBColor(3, 169, 244, 1);
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    //设置所有子控制器
    [self setUpAllChildViewController];
    
    
    // 自定义tabBar
    
    ZSTabBar *tabBar = [[ZSTabBar alloc] initWithFrame:self.tabBar.bounds];
    
    // 利用KVC把readly的属性改
    [self setValue:tabBar forKeyPath:@"tabBar"];
//    [self.tabBar addSubview:tabBar];
   
    UIImage *whiteImage = [UIImage imageCompressForSize:[UIImage imageNamed:@"white"] targetSize:CGSizeMake(414, 49)];
    self.tabBar.backgroundImage =  whiteImage;

}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    for (UIView *tabBarButton in self.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBarButton removeFromSuperview];
//        }
//    }
//}

- (void)setUpAllChildViewController
{
    //首页
    ZSHomeViewController *homeVC = [[ZSHomeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self setUpOneChildViewController:homeVC image:[UIImage imageNamed:@"tab_home_normal"] selectedImage:[UIImage imageNamed:@"tab_home_pressed"] title:@"首页"];
    
    //消息
//    ZSMessageViewController *messageVC = [[ZSMessageViewController alloc] init];
    ZSNewsController *newsViewController = [[ZSNewsController alloc] init];
    
    [self setUpOneChildViewController:newsViewController image:[UIImage imageNamed:@"tab_passage_normal"] selectedImage:[UIImage imageNamed:@"tab_passage_pressed"] title:@"消息"];
    
    //发现
    ZSDiscoverViewController *discoverVC = [[ZSDiscoverViewController alloc] init];
    
    [self setUpOneChildViewController:discoverVC image:[UIImage imageNamed:@"tab_finding_normal"] selectedImage:[UIImage imageNamed:@"tab_finding_pressed"] title:@"发现"];
    
    //我
    ZSProfileViewController *profileVC = [[ZSProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self setUpOneChildViewController:profileVC image:[UIImage imageNamed:@"tab_settings_normal"] selectedImage:[UIImage imageNamed:@"tab_settings_pressed"] title:@"我"];
}

- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    
    vc.tabBarItem.title = title;
    
    
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    ZSNavigationController *nav = [[ZSNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}
@end
