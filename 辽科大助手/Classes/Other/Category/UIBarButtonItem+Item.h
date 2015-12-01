//
//  UIBarButtonItem+Item.h
//  微博
//
//  Created by DongAn on 15/11/27.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)higImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
