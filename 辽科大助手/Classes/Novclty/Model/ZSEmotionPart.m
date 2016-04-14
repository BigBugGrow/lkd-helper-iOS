//
//  ZSEmotionPart.m
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/23.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotionPart.h"

@implementation ZSEmotionPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", self.text, NSStringFromRange(self.range)];
}

@end
