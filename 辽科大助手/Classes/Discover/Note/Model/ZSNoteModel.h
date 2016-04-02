//
//  ZSNoteModel.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSNoteModel : NSObject

/** header的头名*/
@property (nonatomic, copy) NSString *headerTitle;

/** 标题*/
@property (nonatomic, copy) NSString *title;

/** 内容*/
@property (nonatomic, copy) NSString *content;

/** 图片名数组*/
@property (nonatomic, copy) NSMutableArray *icons;

/** time*/
@property (nonatomic, copy) NSString *time;


@end
