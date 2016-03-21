//
//  LBTextAttachment.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSTextAttachment.h"
#import "ZSEmotion.h"

@implementation ZSTextAttachment

- (void)setEmotion:(ZSEmotion *)emotion
{
    _emotion = emotion;

    self.image = [UIImage imageNamed:emotion.png];
}

@end
