//
//  ZSNewsParams.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsParams.h"

@implementation ZSNewsParams

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"Class" : @"class",
             @"item_start" : @"item"
             };
}

@end
