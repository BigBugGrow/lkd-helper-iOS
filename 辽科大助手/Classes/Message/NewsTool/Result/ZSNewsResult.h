//
//  ZSNewsResult.h
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface ZSNewsResult : NSObject<MJKeyValue>

@property (nonatomic,strong)NSArray *latestNews;

@property (nonatomic,copy)NSString *item_start;

@property (nonatomic,copy)NSString *item_end;

@property (nonatomic,copy)NSString *info_num;

@end
