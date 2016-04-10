//
//  ZSWeatherView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSWeatherView.h"
#import "ZSWeatherModel.h"

@interface ZSWeatherView ()

@property (weak, nonatomic) IBOutlet UILabel *dayon_dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayon_weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UILabel *daon_temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWeekLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@end


@implementation ZSWeatherView

- (void)setWeatherModel:(ZSWeatherModel *)weatherModel
{
    _weatherModel = weatherModel;
    
    self.dayon_dateLabel.text = weatherModel.date;
    self.dayon_weatherLabel.text = weatherModel.weather;
    self.pm25Label.text = [NSString stringWithFormat:@"PM2.5: %@",weatherModel.pm25];
    self.daon_temperatureLabel.text = weatherModel.temperature;
    self.currentWeekLabel.text = [NSString stringWithFormat:@"第%@周",weatherModel.currentWeek];
    
    
    ZSLog(@"%@", weatherModel.weather);
    
    NSString *weather = weatherModel.weather;
    
    if ([weather isEqualToString:@"晴"]) {
        
        self.weatherImageView.image = [UIImage imageNamed:@"sunny"];
    } else if([weather isEqualToString:@"雨"] || [weather isEqualToString:@"小雨"] || [weather isEqualToString:@"多云转小雨"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"rain"];
    } else if([weather isEqualToString:@"雪"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"snow"];
    } else if([weather isEqualToString:@"雾"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"fog"];
    } else if([weather isEqualToString:@"霾"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"haze"];
    } else if([weather isEqualToString:@"云"] || [weather isEqualToString:@"晴转多云"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"cloudy"];
    } else if([weather isEqualToString:@"阴"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"overcast"];
    } else if([weather isEqualToString:@"雷"]) {
        self.weatherImageView.image = [UIImage imageNamed:@"thunder"];
    }
    
    
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (point.y <= 95) {
//        
////        if ([self.delegate respondsToSelector:@selector(weatherDetailController)]) {
////            
////            [self.delegate weatherDetailController];
////        }
//
//        
//        ZSLog(@"点击天气");
//        return NO;
//    }
//    
//    return NO;
//}
@end
