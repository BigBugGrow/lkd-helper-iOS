//
//  ZSCourseRightView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/20.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSCourseRightView.h"

@interface ZSCourseRightView ()

@property (nonatomic, weak) UIButton *resetBgBtn;

@property (nonatomic, weak) UIButton *resetTimeTableBtn;

@end

@implementation ZSCourseRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *resetTimetableBtn = [[UIButton alloc] init];
        [resetTimetableBtn setTitle:@"初始化课表" forState:UIControlStateNormal];
        [resetTimetableBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [resetTimetableBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [self addSubview:resetTimetableBtn];
        self.resetTimeTableBtn = resetTimetableBtn;
        
        
        
        UIButton *resetBgBtn = [[UIButton alloc] init];
        [resetBgBtn setTitle:@"重设背景" forState:UIControlStateNormal];
        [resetBgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [resetBgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [self addSubview:resetBgBtn];
        self.resetBgBtn = resetBgBtn;
        
    }
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.resetTimeTableBtn.width = self.width;
    self.resetTimeTableBtn.height = 35;
    self.resetTimeTableBtn.x = 0;
    self.resetTimeTableBtn.y = 100;
    
    self.resetBgBtn.width = self.width;
    self.resetBgBtn.height = 35;
    self.resetBgBtn.x = 0;
    self.resetBgBtn.y = CGRectGetMaxY(self.resetTimeTableBtn.frame);
}


@end
