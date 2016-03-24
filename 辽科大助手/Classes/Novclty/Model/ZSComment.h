//
//  ZSComment.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSComment : NSObject

/** 昵称*/
@property (nonatomic, copy) NSString *nickname;

/** 评论*/
@property (nonatomic, copy) NSString *comment;

/** 评论时间*/
@property (nonatomic, copy) NSString *date;

@end
