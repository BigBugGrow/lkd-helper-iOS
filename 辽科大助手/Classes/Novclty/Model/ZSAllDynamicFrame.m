//
//  ZSAllDynamicFrame.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAllDynamicFrame.h"
#import "ZSAllDynamic.h"
#import "NSString+Extension.h"
#import "ZSDynamicPicturesView.h"

@interface ZSAllDynamicFrame ()

@end

@implementation ZSAllDynamicFrame


- (void)setAllDynamic:(ZSAllDynamic *)allDynamic
{
    _allDynamic = allDynamic;
    
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
    
    /** 正文*/
    CGFloat essayTextViewX = nameLabelX;
    CGFloat essayTextViewY = CGRectGetMaxY(self.nameLabelF) + marginW;
    
//    CGSize essaySize = [allDynamic.essay sizeWithFont:essayTextFont maxW:ScreenWidth];

    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = essayTextFont;
    
    CGSize essaySize = [allDynamic.essay boundingRectWithSize:CGSizeMake(ScreenWidth- iconImageViewWH - 3 * marginW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    
    CGFloat essayTextViewW = essaySize.width;
    CGFloat essayTextViewH = essaySize.height;
    
    
    self.essayTextViewF = CGRectMake(essayTextViewX, essayTextViewY, essayTextViewW, essayTextViewH);

    /** 配图*/    
    if (allDynamic.pic.count) {
        
            CGFloat picturesViewX = nameLabelX;
            CGFloat picturesViewY = CGRectGetMaxY(self.essayTextViewF) + marginW;
        
            CGSize pictureSize = [ZSDynamicPicturesView sizeWithPicturesCount:allDynamic.pic.count];
        
            self.picturesViewF = CGRectMake(picturesViewX, picturesViewY, pictureSize.width, pictureSize.height);
        
    }
    
    /** 时间*/
    CGFloat timeLabelX = nameLabelX;
    
    CGFloat timeLabelY;
    
    if (allDynamic.pic.count) {

        timeLabelY = CGRectGetMaxY(self.picturesViewF) + marginW;
    } else {
    
        timeLabelY = CGRectGetMaxY(self.essayTextViewF) + marginW;
    }
    
    CGSize timeLabelSize = [allDynamic.date sizeWithFont:[UIFont systemFontOfSize:12] maxW:ScreenWidth - marginW - 50];
    
    CGFloat timeLabelW = timeLabelSize.width;
    CGFloat timeLabelH = timeLabelSize.height;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    
    /** 评论数量*/
    CGFloat commentButtonW = 50;
    CGFloat commentButtonH = 30;
    CGFloat commentButtonY = timeLabelY;
    CGFloat commentButtonX = ScreenWidth - marginW - commentButtonW;
    self.commentButtonF = CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH);
    
    /** 容器的frame*/
    CGFloat containerX = 0;
    CGFloat containerY = 0;
    CGFloat containerW = ScreenWidth;
    CGFloat containerH = CGRectGetMaxY(self.timeLabelF) + 2 * marginW;
    self.containerViewF = CGRectMake(containerX, containerY, containerW, containerH);
    
    /**
     *  cell的高度
     */
    self.cellHeight = CGRectGetMaxY(self.containerViewF) + 3;
}


@end
