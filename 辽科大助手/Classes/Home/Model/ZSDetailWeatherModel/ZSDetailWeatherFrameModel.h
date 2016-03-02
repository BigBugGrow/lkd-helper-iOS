//
//  ZSDetailWeatherFrameModel.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSDetailWeatherModel;


@interface ZSDetailWeatherFrameModel : NSObject


@property (nonatomic, strong) ZSDetailWeatherModel *detailWeatherModel;

/**
 *  容器
 */
@property (nonatomic, assign) CGRect containViewF;

/**
 *  名称LabelF
 */
@property (nonatomic, assign) CGRect nameLabelF;

/**
 *  指数label
 */
@property (nonatomic, assign) CGRect zsLabelF;

/**
 *  建议
 */
@property (nonatomic, assign) CGRect sugguestF;

/**
 *  建议text
 */
@property (nonatomic, assign) CGRect sugguestTextViewF;

/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
