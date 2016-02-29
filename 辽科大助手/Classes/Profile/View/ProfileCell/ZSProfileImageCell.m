//
//  ZSProfileImageCell.m
//  辽科大助手
//
//  Created by DongAn on 15/11/30.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSProfileImageCell.h"
#import<QuartzCore/QuartzCore.h>

@interface ZSProfileImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,weak)UIButton *iconButton;

@property (nonatomic,weak)UILabel *nickNameLabel;

@end


@implementation ZSProfileImageCell

- (void)awakeFromNib {
    
    CGFloat imageW = ScreenWidth;
    CGFloat imageH = 134;
    self.frame = CGRectMake(0, 64, imageW, imageH);
    

    //添加头像
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.imageView.image = [UIImage circleImageWithImageName:@"tab04_bgon" borderColor:nil borderWidth:1];
    [btn setImage:[UIImage circleImageWithImageName:@"chaoren" borderColor:nil borderWidth:1] forState:UIControlStateNormal];

    self.iconButton = btn;
    
    [self.imgView addSubview:btn];
    
    
    //添加昵称label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"DongAn";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:109/255.0 green:128/225.0 blue:160/255.0 alpha:0.5];
   // [label sizeToFit];
    self.nickNameLabel = label;
    [self.imgView addSubview:label];
}

- (void)layoutSubviews
{
    self.iconButton.frame = CGRectMake(10, 60, 54, 54);
    self.nickNameLabel.frame = CGRectMake(70, 80, 10, 15);
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.layer.cornerRadius = 10.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
