//
//  ZSCommentViewCell.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSCommentViewCell.h"

#import "ZSComment.h"
#import "UIImageView+WebCache.h"

@interface ZSCommentViewCell ()
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 评论*/
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
/** 时间*/
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZSCommentViewCell


/** cell*/
+ (instancetype)tableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZSCommentViewCell" owner:nil options:nil] lastObject];
}



- (void)setComment:(ZSComment *)comment
{
    _comment = comment;
    
    
    self.dateLabel.text = comment.date;
    
    self.nameLabel.text = comment.nickname;
    
    self.commentLabel.text = comment.comment;

    NSString *urlStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg", comment.nickname];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"o_weiguan"]];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
