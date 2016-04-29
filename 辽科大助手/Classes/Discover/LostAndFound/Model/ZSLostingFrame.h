//
//  ZSAllDynamicFrame.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define essayTextFont [UIFont systemFontOfSize:14]

@class ZSLostThing;

@interface ZSLostingFrame : NSObject

/**
 *  模型数据
 */
@property (nonatomic, strong) ZSLostThing *lostTing;

/** 容器*/
@property (nonatomic, assign) CGRect containerViewF;

/** 头像imageView*/
@property (nonatomic, assign) CGRect iconImageViewF;

/** 昵称*/
@property (nonatomic, assign) CGRect nameLabelF;

/** 物体*/
@property (nonatomic, assign) CGRect thingLabelF;

/**地点*/
@property (nonatomic, assign) CGRect placeLabelF;

/** 描述*/
@property (nonatomic, assign) CGRect desLabelF;

/** 描述*/
@property (nonatomic, assign) CGRect descriptionLabelF;

/** 时间 日期*/
@property (nonatomic, assign) CGRect dateLabelF;

/** 配图*/
@property (nonatomic, assign) CGRect picturesViewF;

/** 电话*/
@property (nonatomic, assign) CGRect callBtnF;

/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;

@end
