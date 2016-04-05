//
//  ZSLostThing.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSLostThing : NSObject

/** 昵称*/
@property (nonatomic, copy) NSString *nickname;

/** thing*/
@property (nonatomic, copy) NSString *thing;

/**id*/
@property (nonatomic, assign) NSInteger id;

/** 物品描述*/
@property (nonatomic, copy) NSString *summary;

/** 图片URL*/
@property (nonatomic, copy) NSArray *pics;

/** 地点*/
@property (nonatomic, copy) NSString *adress;

/** 时间*/
@property (nonatomic, copy) NSString *date;

/** 电话号码*/
@property (nonatomic, copy) NSString *phone;

/**评论*/
@property (nonatomic, copy) NSString *commentNum;

@end
