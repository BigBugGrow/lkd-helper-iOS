//
//  ZSDetailWeatherFrameModel.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDetailWeatherFrameModel.h"
#import "ZSDetailWeatherModel.h"


@implementation ZSDetailWeatherFrameModel


- (void)setDetailWeatherModel:(ZSDetailWeatherModel *)detailWeatherModel
{
    
    _detailWeatherModel = detailWeatherModel;
    
    CGFloat marginW = 10;
    
    
    //0.设置容器frame
    CGFloat containViewW = [UIScreen mainScreen].bounds.size.width - 2 * marginW;
    CGFloat containViewH = 155 - 2 * marginW;
    CGFloat containViewXY = marginW;
    self.containViewF = CGRectMake(containViewXY, containViewXY, containViewW, containViewH);
    
    //1.计算namelabel
    CGFloat nameLabelW = 50;
    CGFloat nameLabelH = 40;
    CGFloat nameLabelX = 15;
    CGFloat nameLabelY = 15;
    self.nameLabelF = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    //2.计算指数frame
    CGFloat zsLabelW = 120;
    CGFloat zsLabelH = 30;
    CGFloat zsLabelX = CGRectGetMaxX(self.nameLabelF) + 10;
    CGFloat zsLabelY = 25;
    self.zsLabelF = CGRectMake(zsLabelX, zsLabelY, zsLabelW, zsLabelH);
    
    //3.建议
    CGFloat sugguestW = 35;
    CGFloat sugguestH = 30;
    CGFloat sugguestX = CGRectGetMaxX(self.nameLabelF) + 10;
    CGFloat sugguestY = 55;
    self.sugguestF = CGRectMake(sugguestX, sugguestY, sugguestW, sugguestH);
    
    //3.sugguestTextView
    CGFloat textViewX = CGRectGetMaxX(self.sugguestF);
    CGFloat textViewY = 55;
    CGFloat textViewW = self.containViewF.size.width - textViewX - marginW;
    CGFloat textViewH = self.containViewF.size.height - 2 * marginW;
    self.sugguestTextViewF = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    
    self.cellHeight = CGRectGetMaxY(self.containViewF) + marginW;
}


@end
