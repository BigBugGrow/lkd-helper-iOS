//
//  ZSTimeTableCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSTimeTableCell.h"
#import "ZSTimeTabelModel.h"
#import "NSDate+Utilities.h"


#define cellHeigt self.frame.size.height
#define cellWidth self.frame.size.width
#define cellTextHeigt 12
#define marginOfCell 10

@interface ZSTimeTableCell ()
@property (nonatomic,weak)UIImageView *dotImage;
@property (nonatomic,weak)UILabel *orderLabel;
@property (nonatomic,weak)UILabel *courseNameLabel;
@property (nonatomic,weak)UIImageView *adressImage;
@property (nonatomic,weak)UILabel *adressLabel;
@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,weak)UIImageView *teacherImage;
@property (nonatomic,weak)UILabel *teacherLabel;
@end

@implementation ZSTimeTableCell

+ (instancetype)timeTabelCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"timeTableCell";
    
    ZSTimeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       [self setUpAllChildView];
        //self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setUpAllChildView
{
    //1.点图片
    UIImageView *dotImage = [[UIImageView alloc] init];
    [self.contentView addSubview:dotImage];
    self.dotImage = dotImage;
    
    //2.第几节课label
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.textColor = [UIColor grayColor];
    orderLabel.font = ZSTextFont;
    [self.contentView addSubview:orderLabel];
    self.orderLabel = orderLabel;
    
    //3.课程名label
    UILabel *courseNameLabel = [[UILabel alloc] init];
    courseNameLabel.textColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:239/255.0 alpha:1.0];
    courseNameLabel.font = ZSCourseNameFont;
    [self.contentView addSubview:courseNameLabel];
    self.courseNameLabel = courseNameLabel;
    
    //4.地点图片
    UIImageView *adressImage = [[UIImageView alloc] init];
    [self.contentView addSubview:adressImage];
    self.adressImage = adressImage;

    //5.地点label
    UILabel *adressLabel = [[UILabel alloc] init];
    adressLabel.textColor = [UIColor grayColor];
    adressLabel.font = ZSTextFont;
    [self.contentView addSubview:adressLabel];
    self.adressLabel = adressLabel;
    
    //6.时间laebl
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = ZSTextFont;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //7.老师图标
    UIImageView *teacherImage = [[UIImageView alloc] init];
    [self.contentView addSubview:teacherImage];
    self.teacherImage = teacherImage;
    
    //8.老师label
    UILabel *teacherLabel = [[UILabel alloc] init];
    teacherLabel.textColor = [UIColor grayColor];
    teacherLabel.font = ZSTextFont;
    [self.contentView addSubview:teacherLabel];
    self.teacherLabel = teacherLabel;
    
    
}


- (void)setModel:(ZSTimeTabelModel *)model
{
    _model = model;
    
    
    //设置frame
    [self setUpFrame];
    //设置data
    [self setUpDataWithModel:model];
    
}
- (void)setUpDataWithModel:(ZSTimeTabelModel *)model
{
    //1.点图片
    UIImage *dotImageGreen =  [UIImage imageCompressForSize:[UIImage imageNamed:@"green"] targetSize:CGSizeMake(10, 10)];
    UIImage *dotImageCircleGreen =  [UIImage circleImageWithImage:dotImageGreen borderColor:nil borderWidth:0];
    
    UIImage *dotImageGray = [UIImage imageCompressForSize:[UIImage imageNamed:@"gray"] targetSize:CGSizeMake(10, 10)];
    UIImage *dotImageCircleGray = [UIImage circleImageWithImage:dotImageGray borderColor:nil borderWidth:0];
#warning 点图片的显示需要处理一下
    NSDate *date = [NSDate date];
   // NSLog(@"%ld",(long)date.minute)  ;

    
    self.dotImage.image = dotImageCircleGreen;
    
    //2.第几节课label

    self.orderLabel.text = model.orderLesson ? [NSString stringWithFormat:@"%d",[model.orderLesson intValue] + 1]: @"--" ;
       //3.课程名label
    self.courseNameLabel.text = (model.course) ?  model.course : @"没课啦~";
    
    //4.地点图片
    self.adressImage.image = [UIImage imageNamed:@"adress"];
    
    //5.地点label
    self.adressLabel.text = model.classroom;
    
    //6.时间laebl
    self.timeLabel.text = model.timeOfLesson;
    
    //7.老师图标
    self.teacherImage.image = model.orderLesson ? [UIImage imageNamed:@"teacher"] : nil;
    
    //8.老师label
    self.teacherLabel.text = [model.mark componentsSeparatedByString:@"*"][0];


}

- (void)setUpFrame;
{
    //1.点图片
    CGFloat dotX = 35;
    CGFloat dotY = cellHeigt / 2;
    CGFloat dotW = 10;
    CGFloat dotH = 10;
    self.dotImage.frame = CGRectMake(dotX, dotY, dotW, dotH);
    
    //2.第几节课label
    CGFloat orderLabelX = dotX * 2;
    CGFloat orderLabelY = cellHeigt / 2;
    CGFloat orderLabelW = cellTextHeigt;
    CGFloat orderLabelH = cellTextHeigt;
    self.orderLabel.frame = CGRectMake(orderLabelX, orderLabelY, orderLabelW, orderLabelH);
    
    //3.课程名label
    CGFloat courseNameLabelX = dotX * 3;
    CGFloat courseNameLabelY = cellHeigt / 3;
    CGFloat courseNameLabelW = 200;
    CGFloat courseNameLabelH = 15;
    self.courseNameLabel.frame = CGRectMake(courseNameLabelX, courseNameLabelY, courseNameLabelW, courseNameLabelH);
    
    //4.地点图片
    CGFloat adressImageX = courseNameLabelX;
    CGFloat adressImageY = CGRectGetMaxY(self.courseNameLabel.frame) + marginOfCell;
    CGFloat adressImageW = 15;
    CGFloat adressImageH = 15;
    self.adressImage.frame = CGRectMake(adressImageX, adressImageY, adressImageW, adressImageH);
    
    //5.地点label
    CGFloat adressLabelX = CGRectGetMaxX(self.adressImage.frame) + 5;
    CGFloat adressLabelY = CGRectGetMaxY(self.courseNameLabel.frame) + 10;
    CGFloat adressLabelW = 200;
    CGFloat adressLabelH = cellTextHeigt;
    self.adressLabel.frame = CGRectMake(adressLabelX, adressLabelY, adressLabelW, adressLabelH);
    
    //6.时间laebl
    CGFloat timeLabelX = ScreenWidth - 35;
    CGFloat timeLabelY = cellHeigt / 2;
    CGFloat timeLabelW = 35;
    CGFloat timeLabelH = cellTextHeigt;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    //7.老师图标
    CGFloat teacherImageX = ScreenWidth - 60;
    CGFloat teacherImageY = adressImageY;
    CGFloat teacherImageW = 20;
    CGFloat teacherImageH = 20;
    self.teacherImage.frame = CGRectMake(teacherImageX, teacherImageY, teacherImageW, teacherImageH);
    
    //8.老师label
    CGFloat teacherLabelX = CGRectGetMaxX(self.teacherImage.frame);
    CGFloat teacherLabelY = teacherImageY + 5;
    CGFloat teacherLabelW = 40;
    CGFloat teacherLabelH = cellTextHeigt;
    self.teacherLabel.frame = CGRectMake(teacherLabelX, teacherLabelY, teacherLabelW, teacherLabelH);
}

@end
