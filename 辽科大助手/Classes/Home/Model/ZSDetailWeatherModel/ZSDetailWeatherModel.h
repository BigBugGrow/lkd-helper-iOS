//
//  ZSDetailWeatherModel.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSDetailWeatherModel : NSObject

/**
 *  标题名称
 */
@property (nonatomic, strong) NSString *title;

/**
 *  pm2.5
 */
@property (nonatomic, strong) NSNumber *pm25;
/**
 *  当天周几
 */
@property (nonatomic, strong) NSDate *dayOnDate;

/**
 *  当天的天气
 */
@property (nonatomic, strong) NSString *dayOnWeather;
/**
 *  当天的温度
 */

@property (nonatomic, strong) NSString *dayOnTemperature;

/**
 *  今天的风
 */
@property (nonatomic, strong) NSString *dayOnWind;

/**
 *  明天周几
 */
@property (nonatomic, strong) NSString *dayTwDate;
/**
 *  明天的天气
 */
@property (nonatomic, strong) NSString *dayTwWeather;
/**
 *  明天的风
 */
@property (nonatomic, strong) NSString *dayTwWind;
/**
 *  明天的温度
 */
@property (nonatomic, strong) NSString *dayTwTemperature;
/**
 *  后天的周几
 */
@property (nonatomic, strong) NSString *dayThDate;
/**
 *  后天的天气
 */
@property (nonatomic, strong) NSString *dayThWeather;
/**
 *  后天的风
 */
@property (nonatomic, strong) NSString *dayThWind;
/**
 *  后天的温度
 */
@property (nonatomic, strong) NSString *dayThTemperature;


/**
 *  穿衣指数
 */
@property (nonatomic, strong) NSString *wearZs;
/**
 *  穿衣建议
 */
@property (nonatomic, strong) NSString *wearDes;

/**
 *  感冒指数
 */
@property (nonatomic, strong) NSString *coldZs;

/**
 *  感冒说明
 */
@property (nonatomic, strong) NSString *coldDes;


/**
 *  运动指数
 */
@property (nonatomic, strong) NSString *sportZs;

/**
 *  运动建议
 */
@property (nonatomic, strong) NSString *sportDes;

/**
 *  晒阳光指数
 */
@property (nonatomic, strong) NSString *sunScreenZs;

/**
 *  晒阳建议
 */
@property (nonatomic, strong) NSString *sunScreenDes;

@end
