//
//  ZSNewsParams.h
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSNewsParams : NSObject


/**class*/
@property (nonatomic, strong) NSString *Class;
/**
 *  请求的第一条数据
 */
@property (nonatomic,copy)NSString *item_start;
/**
 *  请求的最后一条数据
 */
@property (nonatomic,copy)NSString *item_end;

@end
