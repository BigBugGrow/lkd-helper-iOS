//
//  ZSMyInfoHeader.m
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSMyInfoHeader.h"

@interface ZSMyInfoHeader ()

@property (weak, nonatomic) IBOutlet UIView *blurryView;

@property (nonatomic,weak)UIButton *backButton;

@property (nonatomic,weak)UIButton *iconButton;

@property (nonatomic,weak)UIImageView *sexImage;

@property (nonatomic,weak)UILabel *nickNameLabel;
@end

@implementation ZSMyInfoHeader

- (void)awakeFromNib {
    
    CGFloat imageW = ScreenWidth;
    CGFloat imageH = 250;
    self.frame = CGRectMake(0, 0, imageW, imageH);
    
    //添加返回button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [backBtn setImage:[UIImage imageNamed:@"tab_back"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backBtn;
    [self.blurryView addSubview:backBtn];
    
    //添加头像
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage circleImageWithImageName:@"chaoren" borderColor:nil borderWidth:1] forState:UIControlStateNormal];
    
    btn.userInteractionEnabled = NO;
    self.iconButton = btn;
    
    [self.blurryView addSubview:btn];
    
    //性别图片
    UIImageView *sexImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boy"]];
    self.sexImage = sexImage;
    
    [self.blurryView addSubview:sexImage];

    
    //添加昵称label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"超人强";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    
    self.nickNameLabel = label;
    [self.blurryView addSubview:label];
}

- (void)layoutSubviews
{
    self.backButton.frame = CGRectMake(10, 20, 30, 40);
    
    self.iconButton.frame = CGRectMake(0, 0, 84, 84);
    self.iconButton.center = CGPointMake(ScreenWidth/2, self.blurryView.center.y);
    
    self.sexImage.frame = CGRectMake(0, 0, 30, 30);
        self.sexImage.center = CGPointMake(ScreenWidth/2, self.blurryView.center.y + 60);
    
    self.nickNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.sexImage.frame), self.width, 15);
//    self.nickNameLabel.center = CGPointMake(ScreenWidth/2 - 30, self.blurryView.center.y + 85);
//    [self.nickNameLabel sizeToFit];
//    self.nickNameLabel.layer.cornerRadius = 10;
    
}

- (void)backButtonClick:(UIButton *)btn
{
    
    //添加通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ZSDidClickBackBtn object:self];
    
    if ([_delegate respondsToSelector:@selector(backButtonClick)]) {
        [_delegate backButtonClick];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
