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
    //1.标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = ZSCourseNameFont;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    //2.日期label
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.font = ZSTextFont;
    [self addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    //3.图片imageView
    UIImageView *image = [[UIImageView alloc] init];
    [self addSubview:image];
    _image = image;
    
    //4.正文第一句label
    UILabel *text = [[UILabel alloc] init];
    text.textColor = [UIColor grayColor];
    text.font = ZSTextFont;
    [self addSubview:text];
    _text = text;
    
    //5.点击查看原文label
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = ZSTextFont;
    [self addSubview:tipLabel];
    _tipLabel = tipLabel;
    
    //6.评论按钮
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:commentButton];
    _commentButton = commentButton;
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
    //1.标题label
    CGFloat titleLabelX = ZSSCellMargin;
    CGFloat titleLabelY = ZSSCellMargin;
    CGFloat titleLabelW = ScreenWidth - 2 * marginOfCell;
    CGFloat titleLabelH = 25;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);

    //2.日期label
    CGFloat dateLabelX = ZSSCellMargin;
    CGFloat dateLabelY = CGRectGetMaxY(self.titleLabel.frame) + marginOfCell;
    CGFloat dateLabelW = 60;
    CGFloat dateLabelH = cellTextHeigt;
    self.dateLabel.frame = CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH);
    
    //3.图片imageView
    CGFloat imageX = ZSSCellMargin;
    CGFloat imageY = CGRectGetMaxY(self.dateLabel.frame) + marginOfCell;
    CGFloat imageW = ScreenWidth - 2 * ZSSCellMargin;
    CGFloat imageH = 120;
    self.image.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //4.正文第一句label
    CGFloat textX = ZSSCellMargin;
    CGFloat textY = CGRectGetMaxY(self.image.frame) + marginOfCell;
    CGFloat textW = ScreenWidth - 2 * marginOfCell;
    CGFloat textH = cellTextHeigt;
    self.text.frame = CGRectMake(textX, textY, textW, textH);
    //5.点击查看原文label
    CGFloat tipLabelX = ZSSCellMargin;
    CGFloat tipLabelY = CGRectGetMaxY(self.text.frame) + marginOfCell;
    CGFloat tipLabelW = 80;
    CGFloat tipLabelH = cellTextHeigt;
    self.tipLabel.frame = CGRectMake(tipLabelX,tipLabelY,tipLabelW, tipLabelH);
    
    //6.评论按钮
    CGFloat commentButtonX = ScreenWidth - 40;
    CGFloat commentButtonY = CGRectGetMaxY(self.text.frame);
    CGFloat commentButtonW = 35;
    CGFloat commentButtonH = 30;
    self.commentButton.frame = CGRectMake(commentButtonX,commentButtonY,commentButtonW, commentButtonH);
}

- (void)setUpDataWithModel:(ZSNewsInfo *)model
{
    //1.标题label
    _titleLabel.text = model.title;
    
    //2.日期label
    _dateLabel.text = model.time;
    
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
    _text.text = model.text;
    
    //5.点击查看原文label
    _tipLabel.text = @"点击查看原文";
    
    //6.评论按钮


    [_commentButton setTitle:[NSString stringWithFormat:@"%@",model.commentnum] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}



@end
