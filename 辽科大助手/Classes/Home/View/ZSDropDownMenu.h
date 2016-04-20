//
//  ZSDropDownMenu.h
//  新浪微博
//
//  Created by MacBook Pro on 16/1/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSDropDownMenu;

@protocol ZSDropDownMenuDelegate <NSObject>

@optional
//设置标题按钮图片向下
- (void)dropDownMenuDidDismiss:(ZSDropDownMenu *)menu;
//设置箭头向上
- (void)dropDownMenuDidShow:(ZSDropDownMenu *)menu;

@end

@interface ZSDropDownMenu : UIView

//添加代理属性
@property (nonatomic, weak) id<ZSDropDownMenuDelegate> delegate;

//创建菜单
+ (instancetype)menu;
//显示菜单
- (void)show:(UIView *)view;
//清除菜单
- (void)dismiss;
//添加内容属性
@property (nonatomic, strong) UIView *content;
//设置能够添加控制器的内容
@property (nonatomic, strong) UIViewController *contentViewController;

@end
