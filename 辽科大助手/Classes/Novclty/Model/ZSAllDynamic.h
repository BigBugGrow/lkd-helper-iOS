//
//  ZSAllDynamic.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSAllDynamic : NSObject

/** 动态的ID*/
@property (nonatomic, copy) NSString *ID;

/** 昵称*/
@property (nonatomic, copy) NSString *nickname;

/** 动态正文*/
@property (nonatomic, copy) NSString *essay;

/** 图片URL*/
@property (nonatomic, copy) NSArray *pic;

/** 评论数量*/
@property (nonatomic, copy) NSString *commentNum;

/** 发表日期*/
@property (nonatomic, copy) NSString *date;

/** 类型*/
@property (nonatomic, copy) NSString *Class;

@end
