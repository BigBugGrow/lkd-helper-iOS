//
//  ZSNewsCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/9.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsCell.h"
#import "ZSNewsInfo.h"

#import "ZSNewsController.h"

#import "UIImageView+WebCache.h"

@interface ZSNewsCell ()
//1.标题label
@property (nonatomic,weak)UILabel *titleLabel;
//2.日期label
@property (nonatomic,weak)UILabel *dateLabel;

//4.正文第一句label
@property (nonatomic,weak)UILabel *text;
//5.点击查看原文label
@property (nonatomic,weak)UILabel *tipLabel;
//6.评论按钮
@property (nonatomic,weak)UIButton *commentButton;

/** 总的view容器*/
@property (nonatomic, weak) UIView *containerView;
@end

@implementation ZSNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self setUpAllChildView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setUpAllChildView
{
    
    //0. 容器
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    self.containerView = containerView;
    
    //圆角设置
    
    containerView.layer.cornerRadius = 8;
    
    containerView.layer.masksToBounds = YES;
    
    //边框宽度及颜色设置
    [containerView.layer setBorderWidth:10];
    
    [containerView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor whiteColor])];  //设置边框为蓝色
    [self addSubview:containerView];
    
    //1.标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = ZSCourseNameFont;
    [containerView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    //2.日期label
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font = ZSTextFont;
    [containerView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    //3.图片imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    //圆角设置
    
    imageView.layer.cornerRadius = 8;
    
    imageView.layer.masksToBounds = YES;
    
    //边框宽度及颜色设置
    [imageView.layer setBorderWidth:10];
    
    [imageView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor whiteColor])];  //设置边框为蓝色

    //自动适应,保持图片宽高比
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imageView];
    _image = imageView;
    
    //4.正文第一句label
    UILabel *text = [[UILabel alloc] init];
    text.textColor = [UIColor grayColor];
    text.font = ZSTextFont;
    text.numberOfLines = 0;
    [containerView addSubview:text];
    _text = text;
    
    //5.点击查看原文label
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = ZSTextFont;
    [containerView addSubview:tipLabel];
    _tipLabel = tipLabel;
    
    //6.评论按钮
//    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self addSubview:commentButton];
//    _commentButton = commentButton;
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"newsHelperCell";
    
    ZSNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setModel:(ZSNewsInfo *)model
{
    _model = model;
    
    
    //设置frame
    [self setUpFrame];
    //设置data
    [self setUpDataWithModel:model];
    
}

- (void)setUpFrame
{
    
    CGFloat containerViewX = marginOfCell;
    CGFloat containerViewY = marginOfCell;
    CGFloat containerViewW = ScreenWidth - 2 * marginOfCell;
    CGFloat containerViewH = 290;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    
    //1.标题label
    CGFloat titleLabelX = 10;
    CGFloat titleLabelY = ZSSCellMargin;
    CGFloat titleLabelW = containerViewW;
    CGFloat titleLabelH = 25;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);

    //2.日期label
    CGFloat dateLabelX = marginOfCell * 2;
    CGFloat dateLabelY = CGRectGetMaxY(self.titleLabel.frame) + marginOfCell;
    CGFloat dateLabelW = containerViewW;
    CGFloat dateLabelH = cellTextHeigt;
    self.dateLabel.frame = CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH);
    
    //3.图片imageView
    CGFloat imageX = 0;
    CGFloat imageY = CGRectGetMaxY(self.dateLabel.frame) + marginOfCell;
    CGFloat imageW = containerViewW;
    CGFloat imageH = 150;
    self.image.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //4.正文第一句label
    CGFloat textX = marginOfCell;
    CGFloat textY = CGRectGetMaxY(self.image.frame) + marginOfCell;
    CGFloat textW = containerViewW;
    CGFloat textH = cellTextHeigt;
    self.text.frame = CGRectMake(textX, textY, textW, textH);
    //5.点击查看原文label
    CGFloat tipLabelX = 10;
    CGFloat tipLabelY = CGRectGetMaxY(self.text.frame) + marginOfCell;
    CGFloat tipLabelW = containerViewW;
    CGFloat tipLabelH = 20;

    self.tipLabel.frame = CGRectMake(tipLabelX,tipLabelY,tipLabelW, tipLabelH);
    
//    //6.评论按钮
//    CGFloat commentButtonX = ScreenWidth - 40;
//    CGFloat commentButtonY = CGRectGetMaxY(self.text.frame);
//    CGFloat commentButtonW = 35;
//    CGFloat commentButtonH = 30;
//    self.commentButton.frame = CGRectMake(commentButtonX,commentButtonY,commentButtonW, commentButtonH);
}

- (void)setUpDataWithModel:(ZSNewsInfo *)model
{
    //1.标题label
    _titleLabel.text = model.title;
    
    //2.日期label
    _dateLabel.text = model.date;
    
//    //3.图片imageView
//    NSString *url = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/%@/%@.jpg",self.newsPictureType,model.pic];
//    
//    NSURL *URL = [NSURL URLWithString:url];
//
////    [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////        
////        NSLog(@"----------------------");
////    }];
//    [_image sd_setImageWithPreviousCachedImageWithURL:URL andPlaceholderImage:[UIImage imageNamed:@"placeholder"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    //4.正文第一句label
    _text.text = [NSString stringWithFormat:@"   %@", model.summary];
    
    //5.点击查看原文label
    _tipLabel.text = @"点击查看全文";
    
    //6.评论按钮


//    [_commentButton setTitle:[NSString stringWithFormat:@"%@",model.commentNum] forState:UIControlStateNormal];
//    [_commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
//    [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}



@end
