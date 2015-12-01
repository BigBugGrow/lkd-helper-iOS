//
//  ZSModel.m
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSModel.h"

@implementation ZSModel
- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title
{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
    }
    return self;
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    return [[self alloc] initWithIcon:icon title:title];
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title vcClass:(Class)vcClass
{
    ZSModel *item = [self itemWithIcon:icon title:title];
    item.vcClass = vcClass;
    return item;
}
@end
