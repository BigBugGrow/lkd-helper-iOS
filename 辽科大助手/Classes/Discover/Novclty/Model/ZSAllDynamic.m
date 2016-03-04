//
//  ZSAllDynamic.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAllDynamic.h"

@implementation ZSAllDynamic


- (NSString *)description
{
    return [NSString stringWithFormat:@"ID: %@,  %@, %@, %@, %@, %@, %@  ", self.ID, self.nickname, self.essay, self.pic, self.commentNum, self.date, self.Class];
}

@end
