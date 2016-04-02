//
//  UIBarButtonItem+Extension.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/7.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(NSString *)image highLightImage:(NSString *)highLightImage   target:(id)target action:(SEL)action
{
    //设置设置按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    
    button.size = button.currentBackgroundImage.size;
    
    //action 写成@selector(action) 改了半天 ，，，，哎
    [button addTarget:target action:action forControlEvents:
     UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
