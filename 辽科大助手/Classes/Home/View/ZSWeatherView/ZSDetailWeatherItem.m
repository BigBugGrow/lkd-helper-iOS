//
//  ZSDetailWeatherItem.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/2.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDetailWeatherItem.h"
#import "NSDate+Utilities.h"


@interface ZSDetailWeatherItem ()

/**
 *  哪天
 */
@property (nonatomic, weak) UILabel *day;

/** 天气图标*/
@property (nonatomic, weak) UIImageView *iconView;

/**
 * 温度
 */
@property (nonatomic, weak) UILabel *tempreture;
/**
 *  风向
 */
@property (nonatomic, weak) UILabel *wind;
/**
 *  天气
 */
@property (nonatomic, weak) UILabel *weather;

@end

@implementation ZSDetailWeatherItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGBColor(219, 241, 248, 1);
        
        UILabel *day = [[UILabel alloc] init];
        day.font = [UIFont systemFontOfSize:25];
        day.textAlignment = NSTextAlignmentCenter;
        day.backgroundColor = [UIColor clearColor];
        self.day = day;
        [self addSubview:day];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView.backgroundColor = [UIColor redColor];
        self.iconView = iconView;
        [self addSubview:iconView];
        
        UILabel *tempreture = [[UILabel alloc] init];
        tempreture.font = [UIFont systemFontOfSize:14];
        tempreture.textAlignment = NSTextAlignmentCenter;
        tempreture.backgroundColor = [UIColor clearColor];
        self.tempreture = tempreture;
        [self addSubview:tempreture];
        
        UILabel *wind = [[UILabel alloc] init];
        wind.font = [UIFont systemFontOfSize:14];
        wind.textAlignment = NSTextAlignmentCenter;
        wind.backgroundColor = [UIColor clearColor];
        self.wind = wind;
        [self addSubview:wind];
        
        UILabel *weather = [[UILabel alloc] init];
        weather.textAlignment = NSTextAlignmentCenter;
        weather.font = [UIFont systemFontOfSize:14];
        weather.backgroundColor = [UIColor clearColor];
        self.weather = weather;
        [self addSubview:weather];
        
    }
    return self;
}

- (void)setDetailWeatherModel:(ZSDetailWeatherModel *)detailWeatherModel
{
    _detailWeatherModel = detailWeatherModel;
    
    self.day.text = self.title;
    
    NSString *tempreture = nil;
    NSString *wind = nil;
    NSString *weather = nil;
    
    if ([self.title isEqualToString:@"今天"]) {
        
        tempreture = detailWeatherModel.dayOnTemperature;
        wind = detailWeatherModel.dayOnWind;
        weather = detailWeatherModel.dayOnWeather;
    } else if ([self.title isEqualToString:@"明天"]) {
        
        tempreture = detailWeatherModel.dayTwTemperature;
        wind = detailWeatherModel.dayTwWind;
        weather = detailWeatherModel.dayTwWeather;
    } else {
        
        tempreture = detailWeatherModel.dayThTemperature;
        wind = detailWeatherModel.dayThWind;
        weather = detailWeatherModel.dayThWeather;
    }
    
    self.tempreture.text = tempreture;
    self.wind.text = wind;
    self.weather.text = weather;
    
    if ([weather containsString:@"晴"] && ![weather containsString:@"转"]) {
        
        self.iconView.image = [UIImage imageNamed:@"sunny"];
    } else if([weather containsString:@"雷"]) {
        self.iconView.image = [UIImage imageNamed:@"rain"];
    } else if([weather containsString:@"雪"]) {
        self.iconView.image = [UIImage imageNamed:@"snow"];
    } else if([weather containsString:@"雾"]) {
        self.iconView.image = [UIImage imageNamed:@"fog"];
    } else if([weather containsString:@"霾"]) {
        self.iconView.image = [UIImage imageNamed:@"haze"];
    } else if([weather containsString:@"云"]) {
        self.iconView.image = [UIImage imageNamed:@"cloudy"];
    } else if([weather containsString:@"阴"]) {
        self.iconView.image = [UIImage imageNamed:@"overcast"];
    } else if([weather containsString:@"雨"]) {
        self.iconView.image = [UIImage imageNamed:@"thunder"];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginW = 5;
    
    //天
    self.day.width = self.width;
    self.day.height = 40;
    self.day.x = 0;
    self.day.y = marginW;
    
    self.iconView.width = 50;
    self.iconView.height = 50;
    self.iconView.centerX = self.day.centerX;
    self.iconView.y = CGRectGetMaxY(self.day.frame) + marginW;
    
    
    //温度
    self.tempreture.width = self.width;
    self.tempreture.height = 25;
    self.tempreture.x = 0;
    self.tempreture.y = CGRectGetMaxY(self.iconView.frame) + marginW;
    
    
    //风
    self.wind.width = self.width;
    self.wind.height = 25;
    self.wind.x = 0;
    self.wind.y = CGRectGetMaxY(self.tempreture.frame) + marginW;
    
    //天气
    self.weather.width = self.width;
    self.weather.height = 25;
    self.weather.x = 0;
    self.weather.y = CGRectGetMaxY(self.wind.frame) + marginW;
    
}




@end
