//
//  ZSLostThingViewCell.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSLostThingViewCell.h"
#import "ZSLostThing.h"
#import "ZSDynamicPicturesView.h"
#import "UIImageView+WebCache.h"

@interface ZSLostThingViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *sexImageVIew;
/** 电话*/
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

/** 描述*/
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
/** 图册*/
@property (nonatomic, weak) ZSDynamicPicturesView *pictureView;

/** 拾到物品*/
@property (weak, nonatomic) IBOutlet UIView *thingInfoView;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/** 昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/** 日期*/
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/** 物品*/
@property (weak, nonatomic) IBOutlet UILabel *thingLabel;

/** 物品的地点*/
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;

@end

@implementation ZSLostThingViewCell

/** 提供cell*/
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZSLostThingViewCell" owner:nil options:nil] lastObject];
}


- (void)setLostThing:(ZSLostThing *)lostThing
{
    _lostThing = lostThing;
    
    if (lostThing.pics.count == 0) {
        
        self.pictureView.hidden = YES;
    } else {
        
        CGSize pictrueViewSize = [ZSDynamicPicturesView sizeWithPicturesCount:lostThing.pics.count];
        self.pictureView.width = pictrueViewSize.width;
        self.pictureView.height = pictrueViewSize.height;
        self.pictureView.x = 20;
        self.pictureView.y = CGRectGetMaxY(self.thingInfoView.frame) + 10;
        self.pictureView.lol = 1;
        self.pictureView.pictrueArr = lostThing.pics;
        
        self.pictureView.hidden = NO;
    }
    
    
    //1.头像
    
    /** 头像imageView*/
    NSString *str = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", lostThing.nickname];
    
    NSURL *url = [NSURL URLWithString:str];
    
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //获取的新头像
        UIImage *newImage = self.iconView.image;
        
        //占位图片
        UIImage *placeHolderImage = [UIImage imageNamed:@"icon"];
        
        //制作头像的圆形形状
        [self.iconView.layer setCornerRadius:CGRectGetHeight([self.iconView bounds]) / 2];
        self.iconView.layer.masksToBounds = YES;
        //        然后再给图层添加一个有色的边框，类似qq空间头像那样
        self.iconView.layer.borderWidth = 0;
        self.iconView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.iconView.image = newImage ? newImage : placeHolderImage;
        
    }];
    
    /** 昵称*/
    self.nameLabel.text = lostThing.nickname;
    
    /** 性别*/
    self.sexImageVIew.image = [UIImage imageNamed:@"boy"];
    
    /** 时间*/
    self.dateLabel.text = lostThing.date;
    
    /** 拾到物体*/
    self.thingLabel.text = lostThing.thing;
    
    /**地点*/
    self.placeLabel.text = lostThing.adress;
    
    /** 描述*/
    self.descriptionLabel.text = lostThing.summary;
    
    /** 电话*/
    self.phoneLabel.text = lostThing.phone;
    
    
    /** 评论数量*/
    if ([lostThing.commentNum integerValue]) {
        
        [self.commentBtn setTitle:lostThing.commentNum forState:UIControlStateNormal];
    } else {
        
        [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self.commentBtn setImage:[UIImage imageNamed:@"commentNum"] forState:UIControlStateNormal];
    
    
    
}

- (void)awakeFromNib {

    ZSDynamicPicturesView *dynamicPictureView = [[ZSDynamicPicturesView alloc] init];
    [self.contentView addSubview:dynamicPictureView];
    self.pictureView = dynamicPictureView;
    
    self.phoneLabel.userInteractionEnabled = YES;
    
    /** 添加点击事件*/
    [self.phoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhone)]];
    
    self.phoneImageView.userInteractionEnabled = YES;
    
    /** 添加点击事件*/
    [self.phoneImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhone)]];
    
}

- (void)clickPhone
{
    ZSLog(@"%@", self.phoneLabel.text);
    
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@", self.phoneLabel.text];
    
    telUrl = [telUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
