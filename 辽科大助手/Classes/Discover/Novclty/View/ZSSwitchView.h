//
//  ZSSwitchView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/2.
//  Copyright © 2016年 USTL. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ZSSwitchView : UIView
@property UIButton *button1;
@property UIButton *button2;
@property UIButton *button3;
@property UIButton *button4;
@property ( strong) void (^ButtonActionBlock)(int buttonTag);
-(void)swipeAction:(NSInteger)tag;
@end
