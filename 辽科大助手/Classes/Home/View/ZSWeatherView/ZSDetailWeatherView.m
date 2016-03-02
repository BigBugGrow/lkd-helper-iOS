//
//  ZSDetailWeatherView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/2.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDetailWeatherView.h"
#import "ZSDetailWeatherItem.h"

@interface ZSDetailWeatherView ()

@end


@implementation ZSDetailWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGBColor(207, 236, 245);
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.frame = CGRectMake(0, 0, width, 190);
        
        for (int i = 0; i < 3; i ++) {
            
            ZSDetailWeatherItem *detailWeatherItem = [[ZSDetailWeatherItem alloc] init];

            switch (i) {
                case 0:
                    detailWeatherItem.title = @"今天";
                    break;
                case 1:
                    detailWeatherItem.title = @"明天";
                    break;
                case 2:
                    detailWeatherItem.title = @"后天";
                    break;
                default:
                    break;
            }

            [self addSubview:detailWeatherItem];
            
        }
        
    }
    return self;
}

- (void)setDetailWeatherModel:(ZSDetailWeatherModel *)detailWeatherModel
{
    
    _detailWeatherModel = detailWeatherModel;

    
    for (int i = 0; i < 3; i ++) {
        
        
        ZSDetailWeatherItem *item = self.subviews[i];

        item.detailWeatherModel = detailWeatherModel;
        
        }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat marginW = 10;
    
    ZSLog(@"%ld", self.subviews.count);
    
    NSInteger itemNum = self.subviews.count;
    
    CGFloat detailWeatherW = ([UIScreen mainScreen].bounds.size.width - (itemNum + 1) * marginW) / itemNum;
    CGFloat detailWeatherH = 166;
    
    for (int i = 0; i < itemNum; i ++) {
        
        ZSDetailWeatherItem *item = self.subviews[i];
        item.width = detailWeatherW;
        item.height = detailWeatherH;
        item.x = (detailWeatherW + marginW) * i + marginW;
        item.y = marginW;
    }
    
}


@end
