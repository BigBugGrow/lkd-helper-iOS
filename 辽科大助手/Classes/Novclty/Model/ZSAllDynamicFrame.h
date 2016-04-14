//
//  ZSAllDynamicFrame.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define essayTextFont [UIFont systemFontOfSize:14]

@class ZSAllDynamic;

@interface ZSAllDynamicFrame : NSObject

/**
 *  模型数据
 */
@property (nonatomic, strong) ZSAllDynamic *allDynamic;

/** 容器*/
@property (nonatomic, assign) CGRect containerViewF;

/** 头像imageView*/
@property (nonatomic, assign) CGRect iconImageViewF;

/** 昵称*/
@property (nonatomic, assign) CGRect nameLabelF;

/** 正文*/
@property (nonatomic, assign) CGRect essayTextViewF;

/** 时间*/
@property (nonatomic, assign) CGRect timeLabelF;

/** 配图*/
@property (nonatomic, assign) CGRect picturesViewF;

/** 评论数量*/
@property (nonatomic, assign) CGRect commentButtonF;

/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;

@end
