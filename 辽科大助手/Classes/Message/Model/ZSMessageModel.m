//
//  ZSMessageModel.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSMessageModel.h"

@implementation ZSMessageModel
- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle
{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        self.detailTitle = detailTitle;
    }
    return self;
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle
{
    return [[self alloc] initWithIcon:icon title:title detailTitle:detailTitle];
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle vcClass:(Class)vcClass
{
   ZSMessageModel *item = [self itemWithIcon:icon title:title detailTitle:detailTitle];
    item.vcClass = vcClass;
    return item;
}
@end
