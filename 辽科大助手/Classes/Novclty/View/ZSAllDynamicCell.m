//
//  ZSAllDynamicCell.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAllDynamicCell.h"
#import "ZSAllDynamicFrame.h"
#import "ZSAllDynamic.h"
#import "UIImageView+WebCache.h"
#import "ZSDynamicPicturesView.h"
#import "ZSMyNovcltyViewController.h"
#import "ZSNavigationController.h"


#import "ZSEssayTextView.h"

@interface ZSAllDynamicCell ()

/** 容器*/
@property (nonatomic, weak) UIView *containerView;

/** 头像imageView*/
@property (nonatomic, weak) UIImageView *iconImageView;

/** 昵称*/
@property (nonatomic, weak) UILabel *nameLabel;

/** 正文*/
@property (nonatomic, weak) ZSEssayTextView *essayTextView;

/** 时间*/
@property (nonatomic, weak) UILabel *timeLabel;

/** 配图*/
@property (nonatomic, weak) ZSDynamicPicturesView *picturesView;

/** 评论数量*/
@property (nonatomic, weak) UIButton *commentButton;



@end

@implementation ZSAllDynamicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /** 容器*/
        UIView *containerView = [[UIView alloc] init];
        self.containerView = containerView;
        [self.contentView addSubview:containerView];
        
        
        /** 头像imageView*/
        UIImageView *iconImageView = [[UIImageView alloc] init];
        self.iconImageView = iconImageView;
        [self.containerView addSubview:iconImageView];
        
        self.iconImageView.layer.masksToBounds = YES;
        
        self.iconImageView.layer.cornerRadius = self.iconImageView.width * 0.5;
        
        self.iconImageView.layer.borderWidth = 0;
        
        self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        iconImageView.userInteractionEnabled = YES;
        [iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cliclImageView)]];
        
        
        /** 昵称*/
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel setTextColor:[UIColor blueColor]];
        self.nameLabel = nameLabel;
        [self.containerView addSubview:nameLabel];
        
        
        /** 正文*/
        ZSEssayTextView *essayTextView = [[ZSEssayTextView alloc] init];
        self.essayTextView = essayTextView;
        [self.containerView addSubview:essayTextView];

        
        /** 时间*/
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel = timeLabel;
        [self.containerView addSubview:timeLabel];
        
        /** 配图*/
        ZSDynamicPicturesView *picturesView = [[ZSDynamicPicturesView alloc] init];
        self.picturesView = picturesView;
        [self.containerView addSubview:picturesView];
        
        
        /** 评论数量*/
        UIButton *commentButton = [[UIButton alloc] init];
        commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.commentButton = commentButton;
        
        [self.containerView addSubview:commentButton];
        
    }
    return self;
}

/** 点击图片*/
- (void)cliclImageView
{
    NSString *nickname = self.nameLabel.text;
    
    if ([nickname isEqualToString:@"匿名"]) return;
    
    if ([self.delegate respondsToSelector:@selector(pushToMyNovcltyViewController: nickName:)]) {
        
        [self.delegate pushToMyNovcltyViewController:self nickName:nickname];
    }
}
//
//- (UIImage *)circleImageWithImage:(UIImage *)oldImage borderWith:(CGFloat)borderWidth bordColor:(UIColor *)borderColor
//{
//    
//    //1.加载原图
//    
//    //2.开启上下文
//    CGFloat imageW = oldImage.size.width;
//    CGFloat imageH = oldImage.size.height;
//    CGSize imageSize = CGSizeMake(imageW, imageH);
//    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
//    
//    //3.获取当前的上下文 这里得到的就是上面刚创建的那个图片上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //4.画边框
//    [borderColor set];
//    CGFloat bigRadius = imageW * 0.5; // 大圆半径
//    CGFloat centerX = bigRadius; // 圆心
//    CGFloat centerY = bigRadius;
//    
//    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
//    CGContextFillPath(ctx); // 画圆
//    
//    //5.小圆
//    CGFloat smallRadius = bigRadius;
//    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
//    
//    //裁剪 （后面画的东西才会瘦裁剪的影响）
//    
//    CGContextClip(ctx);
//    
//    //6.画图
//    [oldImage drawInRect:CGRectMake(bigRadius, bigRadius, oldImage.size.width, oldImage.size.height)];
//    
//    //7 截图
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //8. 结束上下文
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}


- (UIImage *)imageWithImage:(UIImage *)image border:(CGFloat)border withColor:(UIColor *)color {
    
    //设置边距
    CGFloat borderW = border;
    
    //加载久的图片
    UIImage *oldImage = image;
    
    //设置图片的大小
    CGFloat imageW = oldImage.size.width + borderW;
    CGFloat imageH = oldImage.size.height + borderW;
    
    CGFloat circleW = imageW > imageH ? imageH : imageW;
    
    //创建上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW, circleW), NO, 0.0);
    
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleW, circleW)];
    
    
    //将大圆提交到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    [color set];
    
    //渲染
    CGContextFillPath(ctx);
    
    CGRect rect = CGRectMake(borderW / 2, borderW / 2, oldImage.size.width, oldImage.size.height);
    
    //画小圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    //设置裁剪区域
    [clipPath addClip];
    
    //花图片
    [oldImage drawAtPoint:CGPointZero];
    
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndPDFContext();
    
    return newImage;
}




+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"allDynamicCell";
    
    ZSAllDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];;

    if (cell == nil) {
        
        cell = [[ZSAllDynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setAllDynamicFrame:(ZSAllDynamicFrame *)allDynamicFrame
{
    _allDynamicFrame = allDynamicFrame;
    
    //1. 设置控件frame
    
    /** 容器*/
    self.containerView.frame = allDynamicFrame.containerViewF;
    
    /** 头像imageView*/
    self.iconImageView.frame = allDynamicFrame.iconImageViewF;
    
    /** 昵称*/
    self.nameLabel.frame = allDynamicFrame.nameLabelF;
    
    /** 正文*/
    self.essayTextView.frame = allDynamicFrame.essayTextViewF;
    
    /** 时间*/
    self.timeLabel.frame = allDynamicFrame.timeLabelF;
    
    /** 配图*/
    self.picturesView.frame = allDynamicFrame.picturesViewF;
    
    /** 评论数量*/
    self.commentButton.frame = allDynamicFrame.commentButtonF;

    //2.设置数据
    ZSAllDynamic *allDynamic = allDynamicFrame.allDynamic;
    
    
    /** 头像imageView*/
    NSString *str = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", allDynamic.nickname];
    
    NSURL *url = [NSURL URLWithString:str];
    
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
//        
//        UIImage *newImage = [self imageWithImage:self.iconImageView.image border:10 withColor:[UIColor whiteColor]];
//        
//        UIImage *placeHoldImage = [self imageWithImage:[UIImage imageNamed:@"icon"] border:10 withColor:[UIColor whiteColor]];

        
        UIImage *newImage = self.iconImageView.image;
        
        UIImage *placeHolderImage = [UIImage imageNamed:@"icon"];
        
        [self.iconImageView.layer setCornerRadius:CGRectGetHeight([self.iconImageView bounds]) / 2];
        
        self.iconImageView.layer.masksToBounds = YES;
//        然后再给图层添加一个有色的边框，类似qq空间头像那样
        self.iconImageView.layer.borderWidth = 0;
        self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
        self.iconImageView.image = newImage ? newImage : placeHolderImage;
        
    }];
    
//    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"]];
    
    /** 昵称*/
    self.nameLabel.text = allDynamic.nickname;
    
    /** 正文*/
    self.essayTextView.text = allDynamic.essay;
    
    /** 时间*/
    self.timeLabel.text = allDynamic.date;
    
    /** 配图*/
    
    self.picturesView.pictrueArr = allDynamic.pic;
    
    /** 评论数量*/
    if ([allDynamic.commentNum integerValue]) {

        [self.commentButton setTitle:allDynamic.commentNum forState:UIControlStateNormal];
    } else {
        
        [self.commentButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self.commentButton setImage:[UIImage imageNamed:@"commentNum"] forState:UIControlStateNormal];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
