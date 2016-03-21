//
//  BSVerticalButton.m
//  百思不得姐
//
//  Created by MacBook Pro on 16/3/12.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSVerticalButton.h"

@implementation ZSVerticalButton

/**
 * 代码创建调用
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}

/**
 * xib加载调用
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUp];

}

- (void)setUp
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = 70;
    
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.height - self.titleLabel.height;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
