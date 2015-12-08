//
//  ZSMyInfoCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSMyInfoCell.h"

@implementation ZSMyInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    CGFloat cellW = ScreenWidth;
    CGFloat cellH = 100;
    self.frame = CGRectMake(0, 0, cellW, cellH);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
