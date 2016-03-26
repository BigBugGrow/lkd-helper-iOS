//
//  ZSTimeTabelModel.m
//  辽科大助手
//
//  Created by DongAn on 15/12/7.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSTimeTabelModel.h"

@implementation ZSTimeTabelModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@",self.classroom, self.mark, self.course, self.orderLesson, self.timeOfLesson];
}

@end