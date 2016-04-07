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
    
    if ([weatherModel.weather isEqualToString:@"晴"]) {
        
        self.weatherImageView.image = [UIImage imageNamed:@"fine"];
        
    } else if ([weatherModel.weather isEqualToString:@"雨"] || [weatherModel.weather isEqualToString:@"小雨"]){
        
        self.weatherImageView.image = [UIImage imageNamed:@"rain"];
    } else if ([weatherModel.weather isEqualToString:@"雪"]){
        
        self.weatherImageView.image = [UIImage imageNamed:@"snow"];
    }  else if ([weatherModel.weather isEqualToString:@"云"]){
        
        self.weatherImageView.image = [UIImage imageNamed:@""];
    } else if ([weatherModel.weather isEqualToString:@"阴"]){
        
        self.weatherImageView.image = [UIImage imageNamed:@"cloudy"];
    } else if ([weatherModel.weather isEqualToString:@"雷"]){
        
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
