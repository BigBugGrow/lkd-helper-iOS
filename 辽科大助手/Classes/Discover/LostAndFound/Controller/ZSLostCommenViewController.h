//
//  ZSCommenViewController.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSAllDynamicFrame, ZSCommenViewController;

@protocol commenViewControllerDelegate <NSObject>

@optional
- (void)loadNewData;

@end

@interface ZSLostCommenViewController : UIViewController

/**代理*/
@property (nonatomic, assign) id<commenViewControllerDelegate> delegate;

/** block*/
@property (nonatomic, copy) void (^loadNewData)();


//** cell模型*/
@property (nonatomic, strong) ZSAllDynamicFrame *allDynamicFrame;

@end
