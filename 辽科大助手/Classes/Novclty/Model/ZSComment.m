//
//  ZSComment.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSComment.h"
#import "NSDate+Extension.h"

@implementation ZSComment

- (NSString *)description
{
    return [NSString stringWithFormat:@"nickname: %@, comment: %@, date:%@", self.nickname, self.comment, self.date];
}

@end
