//
//  ZSWeatherModel.m
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSWeatherModel.h"

@implementation ZSWeatherModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"date: %@  wether: %@  pm: %@ temperature: %@ currentWeek: %@ wind: %@ day", self.date, self.weather, self.pm25, self.temperature, self.currentWeek, self.wind];
}

@end
