//
//  ZSLostThing.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSLostThing.h"



@implementation ZSLostThing


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@", self.nickname, self.pics, self.adress, self.phone, self.summary];
}


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             };
}


@end
