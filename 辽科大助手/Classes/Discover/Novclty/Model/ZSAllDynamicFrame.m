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

@implementation ZSAllDynamicFrame

- (void)setAllDynamic:(ZSAllDynamic *)allDynamic
{
    _allDynamic = allDynamic;
    
    //计算控件的frame
    
    /** 容器*/
    CGFloat marginW = 10;
    
    /** 头像imageView*/
    CGFloat iconImageViewXY = marginW;
    CGFloat iconImageViewWH = 50;
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
    
    CGSize essaySize = [allDynamic.essay sizeWithFont:[UIFont systemFontOfSize:15] maxW:ScreenWidth - iconImageViewWH - 2 * marginW];

    CGFloat essayTextViewW = essaySize.width;
    CGFloat essayTextViewH = essaySize.height;
    self.essayTextViewF = CGRectMake(essayTextViewX, essayTextViewY, essayTextViewW, essayTextViewH);
    
    /** 时间*/
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(self.essayTextViewF) + marginW;
    CGFloat timeLabelW = 50;
    CGFloat timeLabelH = 30;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    /** 配图*/
//    CGFloat picturesViewX = nameLabelX;
//    CGFloat picturesViewY = CGRectGetMaxY(self.essayTextViewF) + 2 * marginW;
//    CGFloat picturesViewW = 50;
//    CGFloat picturesViewH = 30;
//    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
//    @property (nonatomic, assign) CGRect picturesViewF;
    
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
    CGFloat containerH = CGRectGetMaxY(self.timeLabelF);
    self.containerViewF = CGRectMake(containerX, containerY, containerW, containerH);
    
    /**
     *  cell的高度
     */
    self.cellHeight = CGRectGetMaxY(self.containerViewF) + 2 * marginW;
}


@end
