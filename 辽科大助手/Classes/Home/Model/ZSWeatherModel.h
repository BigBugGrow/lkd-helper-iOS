//
//  ZSWeatherModel.h
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSWeatherModel : NSObject
@property (nonatomic,copy)NSString *wind;
@property (nonatomic,copy)NSString *pm25;
@property (nonatomic,copy)NSString *temperature;
@property (nonatomic,copy)NSString *weather;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,strong)NSNumber *currentWeek;


@end
