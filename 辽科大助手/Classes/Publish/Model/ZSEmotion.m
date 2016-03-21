//
//  LBEmotion.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/15.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSEmotion.h"

@interface ZSEmotion ()<NSCoding>

@end

@implementation ZSEmotion

//归档
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.cht = [decoder decodeObjectForKey:@"cht"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
    }
    return self;
}


//解档
- (void)encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.cht forKey:@"cht"];
    [enCoder encodeObject:self.png forKey:@"png"];
    [enCoder encodeObject:self.code forKey:@"code"];
}

//重写equal方法
- (BOOL)isEqual:(ZSEmotion *)other
{
    return [self.cht isEqual:other.cht] || [self.code isEqual:other.code];
}

@end
