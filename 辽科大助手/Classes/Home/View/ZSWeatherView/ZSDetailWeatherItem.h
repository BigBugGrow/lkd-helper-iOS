//
//  ZSDetailWeatherItem.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/2.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSDetailWeatherModel.h"

@interface ZSDetailWeatherItem : UIView

/**
 *  详细天气模型
 */
@property (nonatomic, strong) ZSDetailWeatherModel *detailWeatherModel;

/**
 *  哪天的标题
 */
@property (nonatomic, strong) NSString *title;

@end
