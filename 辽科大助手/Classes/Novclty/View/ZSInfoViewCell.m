//
//  ZSInfoViewCell.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSInfoViewCell.h"

@implementation ZSInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 提供cell*/
+ (instancetype)tableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZSInfoViewCell" owner:nil options:nil] lastObject];
}



@end
