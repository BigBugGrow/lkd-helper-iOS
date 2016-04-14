//
//  LBSpecial.m
//  辽科大微博
//
//  Created by MacBook Pro on 16/1/24.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSSpecial.h"
#import "MJExtension.h"
@implementation ZSSpecial

MJCodingImplementation

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", self.text, NSStringFromRange(self.range)];
}

@end
