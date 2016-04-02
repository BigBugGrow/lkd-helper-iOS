//
//  UIBarButtonItem+Extension.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/7.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(NSString *)image highLightImage:(NSString *)highLightImage  target:(id)target action:(SEL)action;

@end
