//
//  ZSWeatherView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSWeatherModel;

//添加代理
@protocol ZSWeatherViewDelegate <NSObject>

@optional
- (void)weatherDetailController;

@end

@interface ZSWeatherView : UIButton

@property (nonatomic, weak) id<ZSWeatherViewDelegate> delegate;

//天气模型
@property (nonatomic, strong) ZSWeatherModel *weatherModel;

@end
