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
#import "ZSLostingFrame.h"

#define myNickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSLostThingViewCell ()

/** 容器*/
@property (nonatomic, weak) UIView *containerView;

/** 电话*/
@property (weak, nonatomic) UIButton *callBtn;

/** 描述*/
@property (weak, nonatomic)  UILabel *descriptionLabel;
/** 图册*/
@property (nonatomic, weak) ZSDynamicPicturesView *pictureView;

/** 头像*/
@property (weak, nonatomic) UIImageView *iconImageView;

/** 昵称*/
@property (weak, nonatomic) UILabel *nameLabel;

/** 日期*/
@property (weak, nonatomic) UILabel *dateLabel;

/** 描述*/
@property (weak, nonatomic) UILabel *desLabel;

/** 物品*/
@property (weak, nonatomic) UILabel *thingLabel;

/** 物品的地点*/
@property (weak, nonatomic) UILabel *placeLabel;

@end

@implementation ZSLostThingViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        /** 容器*/
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
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
        nameLabel.textColor = RGBColor(129, 214, 248, 1);
        self.nameLabel = nameLabel;
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        [self.containerView addSubview:nameLabel];
        
        
        /** 捡到的物体*/
        UILabel *thingLabel = [[UILabel alloc] init];
        thingLabel.textColor = RGBColor(3, 169, 244, 1);
        self.thingLabel = thingLabel;
        thingLabel.font = [UIFont systemFontOfSize:15];
        [self.containerView addSubview:thingLabel];
        
        /** 捡到的物体的地点*/
        UILabel *placeLabel = [[UILabel alloc] init];
        
        placeLabel.font = [UIFont systemFontOfSize:15];
        placeLabel.textColor = RGBColor(3, 169, 244, 1);
        self.placeLabel = placeLabel;
        [self.containerView addSubview:placeLabel];
        
        /** 配图*/
        ZSDynamicPicturesView *picturesView = [[ZSDynamicPicturesView alloc] init];
        
        self.pictureView = picturesView;
        [self.containerView addSubview:picturesView];
        
        /** 描述*/
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.font = [UIFont systemFontOfSize:14];
        descriptionLabel.numberOfLines = 0;
        self.descriptionLabel = descriptionLabel;
        [self.containerView addSubview:descriptionLabel];
       
        /** 描述*/
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.font = [UIFont systemFontOfSize:14];
        desLabel.contentMode = UIViewContentModeTop;
        self.desLabel = desLabel;
        [self.containerView addSubview:desLabel];
        
        
        
        /** 时间*/
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:10];
        dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel = dateLabel;
        [self.containerView addSubview:dateLabel];
        
        
        /** 打电话按钮*/
        UIButton *callBtn = [[UIButton alloc] init];
        callBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(clickPhone) forControlEvents:UIControlEventTouchUpInside];
        self.callBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        self.callBtn = callBtn;
        
        [self.containerView addSubview:callBtn];
    }
    return self;
}


///** 提供cell*/
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lostThingCell";
    
    ZSLostThingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];;
    
    if (cell == nil) {
        
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.backgroundColor = RGBColor(243, 243, 243, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)setLostTingFrame:(ZSLostingFrame *)lostTingFrame
{
    
    _lostTingFrame = lostTingFrame;
    
    ZSLostThing *lostThing = lostTingFrame.lostTing;
    
    
    //找了半天， 原来是这错了， 太不应该了
    /** 设置frame*/
    self.containerView.frame = lostTingFrame.containerViewF;
    
    /** 电话*/
    self.callBtn.frame = lostTingFrame.callBtnF;
    
    /** 描述*/
    self.descriptionLabel.frame = lostTingFrame.descriptionLabelF;
    
    self.desLabel.frame = lostTingFrame.desLabelF;
    
    /** 图册*/
    self.pictureView.frame = lostTingFrame.picturesViewF;
    
    /** 头像*/
    self.iconImageView.frame = lostTingFrame.iconImageViewF;
    
    /** 昵称*/
    self.nameLabel.frame = lostTingFrame.nameLabelF;
    
    /** 日期*/
    self.dateLabel.frame = lostTingFrame.dateLabelF;
    
    /** 物品*/
    self.thingLabel.frame = lostTingFrame.thingLabelF;
    
    /** 物品的地点*/
    self.placeLabel.frame = lostTingFrame.placeLabelF;
    
    
    
    /** 头像imageView*/
    NSString *imageStr = lostThing.nickname ? lostThing.nickname : myNickName;
    
    NSString *str = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", imageStr];
    
    NSURL *url = [NSURL URLWithString:str];
    
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //获取的新头像
        UIImage *newImage = self.iconImageView.image;
        
        //占位图片
        UIImage *placeHolderImage = [UIImage imageNamed:@"icon"];
        
        //制作头像的圆形形状
        [self.iconImageView.layer setCornerRadius:CGRectGetHeight([self.iconImageView bounds]) / 2];
        self.iconImageView.layer.masksToBounds = YES;
        //        然后再给图层添加一个有色的边框，类似qq空间头像那样
        self.iconImageView.layer.borderWidth = 0;
        self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.iconImageView.image = newImage ? newImage : placeHolderImage;
        
    }];
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cliclImageView)]];
    
    
    /** 昵称*/
    self.nameLabel.text = imageStr;
    
    /** 时间*/
    self.dateLabel.text = lostThing.date;
    
    /** 拾到物体*/
    self.thingLabel.text = [NSString stringWithFormat:@"物品  %@", lostThing.thing];
    
    /**地点*/
    self.placeLabel.text = [NSString stringWithFormat:@"地点  %@", lostThing.adress];
    
    /** 配图*/
    self.pictureView.lol = 1;
    self.pictureView.pictrueArr = lostThing.pics;
    
    
    self.desLabel.text = @"描述: ";
    /** 描述*/
    self.descriptionLabel.text = lostThing.summary;
    
    //电话
    [self.callBtn setTitle:lostThing.phone forState:UIControlStateNormal];
    [self.callBtn setImage:[UIImage imageNamed:@"pic_register_mobile"] forState:UIControlStateNormal];
    [self.callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}


/** 点击图片*/
- (void)cliclImageView
{
    NSString *nickname = self.nameLabel.text;
    
    if ([nickname isEqualToString:@"匿名"]) return;
    
    if ([self.delegate respondsToSelector:@selector(pushToInfoViewController: nickName:)]) {
        
        [self.delegate pushToInfoViewController:self nickName:nickname];
    }
}

- (void)clickPhone
{
    
    if ([self.delegate respondsToSelector:@selector(clickCall:PhoneNum:)]) {
        
        [self.delegate clickCall:self PhoneNum:self.callBtn.titleLabel.text];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
