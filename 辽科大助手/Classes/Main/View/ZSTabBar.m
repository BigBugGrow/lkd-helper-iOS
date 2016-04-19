//
//  ZSTabBar.m
//  辽科大助手
//
//  Created by DongAn on 15/11/29.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSTabBar.h"
#import "UIImage+Image.h"

@implementation ZSTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
        
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / self.items.count;
    CGFloat btnH = h;
    
    int i = 0;
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
           
            btnX = i * btnW;
            
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            i++;
        }
    }
    
}

@end
