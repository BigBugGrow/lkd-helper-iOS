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
    
    /** 头像imageView*/

    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *newImage = self.iconView.image;
        
        UIImage *placeHolderImage = [UIImage imageNamed:@"icon"];
        
        [self.iconView.layer setCornerRadius:CGRectGetHeight([self.iconView bounds]) / 2];
        
        self.iconView.layer.masksToBounds = YES;
        //        然后再给图层添加一个有色的边框，类似qq空间头像那样
        self.iconView.layer.borderWidth = 0;
        self.iconView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.iconView.image = newImage ? newImage : placeHolderImage;
        
    }];
    
    [ZSNotificationCenter addObserver:self selector:@selector(updateImage) name:@"swapImage" object:nil];

}

- (void)updateImage
{
    self.iconView.image = [self GetImageFromLocal:ZSIconImageStr];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//从本地获取图片
- (UIImage*)GetImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        ZSLog(@"未从本地获得图片");
    }
    return image;
}


@end
