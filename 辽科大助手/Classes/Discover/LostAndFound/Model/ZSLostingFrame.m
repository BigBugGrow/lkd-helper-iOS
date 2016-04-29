//
//  ZSAllDynamicFrame.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSLostingFrame.h"
#import "ZSLostThing.h"
#import "NSString+Extension.h"
#import "ZSDynamicPicturesView.h"

@interface ZSLostingFrame ()

@end

@implementation ZSLostingFrame


- (void)setLostTing:(ZSLostThing *)lostTing
{
    _lostTing = lostTing;
    
    //计算控件的frame
    
    /** 容器*/
    CGFloat marginW = 10;
    
    /** 头像imageView*/
    CGFloat iconImageViewXY = marginW;
    CGFloat iconImageViewWH = 40;
    self.iconImageViewF = CGRectMake(iconImageViewXY, iconImageViewXY, iconImageViewWH, iconImageViewWH);
    
    /** 昵称*/
    CGFloat nameLabelW = ScreenWidth - 2 * marginW - iconImageViewWH;
    CGFloat nameLabelH = 30;
    CGFloat nameLabelX = CGRectGetMaxX(self.iconImageViewF) + marginW;
    CGFloat nameLabelY = marginW;
    self.nameLabelF = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    /** 物品*/
    CGFloat thingLabelW = ZSScreenW;
    CGFloat thingLabelH = 25;
    CGFloat thingLabelX = iconImageViewXY + iconImageViewWH / 2;
    CGFloat thingLabelY = marginW + CGRectGetMaxY(self.iconImageViewF);
    self.thingLabelF = CGRectMake(thingLabelX, thingLabelY, thingLabelW, thingLabelH);
    
    /** 地点*/
    CGFloat adressLabelW = ZSScreenW;
    CGFloat adressLabelH = 25;
    CGFloat adressLabelX = iconImageViewXY + iconImageViewWH / 2;
    CGFloat adressLabelY = CGRectGetMaxY(self.thingLabelF);
    self.placeLabelF = CGRectMake(adressLabelX, adressLabelY, adressLabelW, adressLabelH);
    
    
    self.picturesViewF = CGRectMake(0, 0, 0, 0);
    
    /** 配图*/
    if (lostTing.pics.count) {
        
        CGFloat picturesViewX = thingLabelX - marginW;
        CGFloat picturesViewY = CGRectGetMaxY(self.placeLabelF) + marginW;
        
        CGSize pictureSize = [ZSDynamicPicturesView sizeWithPicturesCount:lostTing.pics.count];
        
        self.picturesViewF = CGRectMake(picturesViewX, picturesViewY, pictureSize.width, pictureSize.height);
        
    }
    

    /** 描述*/
    CGFloat desTextViewX = iconImageViewXY + marginW;
    CGFloat desTextViewY;
 
    
    CGFloat essayTextViewY;
    if (lostTing.pics.count) {
        
        desTextViewY = CGRectGetMaxY(self.picturesViewF) + marginW;
        essayTextViewY = CGRectGetMaxY(self.picturesViewF) + marginW;
    } else {
        desTextViewY = CGRectGetMaxY(self.placeLabelF) + marginW;
        essayTextViewY = CGRectGetMaxY(self.placeLabelF) + marginW;
    }
    
   
    
    //    CGSize essaySize = [allDynamic.essay sizeWithFont:essayTextFont maxW:ScreenWidth];
    
    //    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    //    attr[NSFontAttributeName] = essayTextFont;
    
    //    CGSize essaySize = [allDynamic.essay boundingRectWithSize:CGSizeMake(ScreenWidth- iconImageViewWH - 3 * marginW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    //
    //用attribute bounding 设置字体
    //    CGSize essaySize = [allDynamic.attributeText boundingRectWithSize:CGSizeMake(ScreenWidth- iconImageViewWH - 3 * marginW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    //    self.contentLabelF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
//    CGSize essaySize = [lostTing.summary boundingRectWithSize:CGSizeMake(ScreenWidth- iconImageViewWH - 3 * marginW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
    
    CGSize essaySize = [lostTing.summary sizeWithFont:[UIFont systemFontOfSize:14] maxW:ScreenWidth- iconImageViewWH - 5 * marginW];
    
    CGFloat essayTextViewW = essaySize.width;
    CGFloat essayTextViewH = essaySize.height;
    
    CGFloat desWidth = 40;
    CGFloat desHeight = essaySize.height;
    
     self.desLabelF = CGRectMake(desTextViewX, desTextViewY, desWidth, desHeight);
    
    
    /** 描述*/
    CGFloat essayTextViewX = CGRectGetMaxX(self.desLabelF);
    
    self.descriptionLabelF = CGRectMake(essayTextViewX, essayTextViewY, essayTextViewW, essayTextViewH);
    
    
    /** 时间*/
    CGFloat timeLabelX = essayTextViewX - marginW * 2;
    
    CGFloat timeLabelY;
    timeLabelY = CGRectGetMaxY(self.descriptionLabelF) + marginW;
    
    CGSize timeLabelSize = [lostTing.date sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth - marginW - 50];
    
    CGFloat timeLabelW = timeLabelSize.width;
    CGFloat timeLabelH = timeLabelSize.height;
    self.dateLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    
    /** 电话按钮*/
    CGFloat callBtnW = 200;
    CGFloat callBtnH = 30;
    CGFloat callBtnY = timeLabelY;
    CGFloat callBtnX = ScreenWidth - marginW - callBtnW;
    self.callBtnF = CGRectMake(callBtnX, callBtnY, callBtnW, callBtnH);
    //
    /** 容器的frame*/
    CGFloat containerX = 0;
    CGFloat containerY = 0;
    CGFloat containerW = ScreenWidth;
    CGFloat containerH = CGRectGetMaxY(self.callBtnF) + marginW;
    self.containerViewF = CGRectMake(containerX, containerY, containerW, containerH);
    
    /**
     *  cell的高度
     */
    self.cellHeight = CGRectGetMaxY(self.containerViewF) + marginW;

}

@end
