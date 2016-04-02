//
//  ZSNoteModel.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSNoteModel.h"
#import "MJExtension.h"
@interface ZSNoteModel ()<NSCoding>


@end


@implementation ZSNoteModel

MJCodingImplementation

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.headerTitle, self.title, self.content, self.icons];
}

@end
