//
//  ZSSpecial.h
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/24.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSpecial : NSObject

/** 特殊文字的文字*/
@property (nonatomic, copy) NSString *text;

/** 特殊文字的范围*/
@property (nonatomic, assign) NSRange range;

/** 存储特殊文字的矩形框*/
@property (nonatomic, strong) NSArray *rects;

@end
