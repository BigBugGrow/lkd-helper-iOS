//
//  ZSDetailWeatherModel.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDetailWeatherModel.h"

@interface ZSDetailWeatherModel ()


@end

@implementation ZSDetailWeatherModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@", self.pm25, self.dayOnDate, self.dayOnWeather, self.dayOnTemperature];
}



@end
