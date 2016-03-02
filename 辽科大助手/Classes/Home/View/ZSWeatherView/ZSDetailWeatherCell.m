//
//  ZSDetailWeatherCell.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDetailWeatherCell.h"
#import "ZSDetailWeatherFrameModel.h"
#import "ZSDetailWeatherModel.h"


@interface ZSDetailWeatherCell ()

/**
 *  容器
 */
@property (nonatomic, weak) UIView *containView;

/**
 *  名称Label
 */
@property (nonatomic, weak) UILabel *nameLabel;

/**
 *  指数label
 */
@property (nonatomic, weak) UILabel *zsLabel;

/**
 *  建议
 */
@property (nonatomic, weak) UILabel *sugguest;
/**
 *  建议text
 */
@property (nonatomic, weak) UITextView *sugguestTextView;

@end


@implementation ZSDetailWeatherCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"detailWeatherCell";
    ZSDetailWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ZSDetailWeatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = RGBColor(207, 236, 245);
    //设置cell不能够点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //0. 容器
        UIView *containView = [[UIView alloc] init];
        containView.backgroundColor = RGBColor(219, 241, 248);
        [self.contentView addSubview:containView];
        self.containView = containView;
        
        //1.添加名称说明
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:25];
        [self.containView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //2.添加指数label
        UILabel *zsLabel = [[UILabel alloc] init];
        zsLabel.font = [UIFont systemFontOfSize:14];
        [self.containView addSubview:zsLabel];
        self.zsLabel = zsLabel;
        
        //3.建议
        UILabel *sugguest = [[UILabel alloc] init];
        sugguest.font = [UIFont systemFontOfSize:14];
        [self.containView addSubview:sugguest];
        self.sugguest = sugguest;
        
        //4.添加建议textView
        UITextView *sugguestTextView = [[UITextView alloc] init];
        //设置不能够被选中
        sugguestTextView.selectable = NO;
        sugguestTextView.font = [UIFont systemFontOfSize:14];
        sugguestTextView.backgroundColor = [UIColor clearColor];
        sugguestTextView.editable = NO;
        [self.containView addSubview:sugguestTextView];
        self.sugguestTextView = sugguestTextView;
        
    }
    
    return self;
}


- (void)setDetailWeatherFrameModel:(ZSDetailWeatherFrameModel *)detailWeatherFrameModel
{
    _detailWeatherFrameModel = detailWeatherFrameModel;
    
    ZSDetailWeatherModel *detailWeatherModel = detailWeatherFrameModel.detailWeatherModel;
    
    //设置frame
    
    self.containView.frame = detailWeatherFrameModel.containViewF;
    
    self.nameLabel.frame = detailWeatherFrameModel.nameLabelF;
    
    self.zsLabel.frame = detailWeatherFrameModel.zsLabelF;
    
    self.sugguest.frame = detailWeatherFrameModel.sugguestF;
    
    self.sugguestTextView.frame = detailWeatherFrameModel.sugguestTextViewF;
    
    
    //设置数据
    self.nameLabel.text = detailWeatherModel.title;
    self.sugguest.text = @"建议:";
    
    NSString *zs = nil;
    NSString *sugguestText = nil;
    
    if ([detailWeatherModel.title isEqualToString:@"穿衣"]) {
        
        zs = detailWeatherModel.wearZs;
        sugguestText = detailWeatherModel.wearDes;
    } else if ([detailWeatherModel.title isEqualToString:@"感冒"]) {
        
        zs = detailWeatherModel.coldZs;
        sugguestText = detailWeatherModel.coldDes;
    } else if ([detailWeatherModel.title isEqualToString:@"运动"]) {
        
        zs = detailWeatherModel.sportZs;
        sugguestText = detailWeatherModel.sportDes;
    } else {
        
        zs = detailWeatherModel.sunScreenZs;
        sugguestText = detailWeatherModel.sunScreenDes;
    }
    
    self.zsLabel.text = [NSString stringWithFormat:@"指数:  %@", zs];
    self.sugguestTextView.text = sugguestText;
    
}



@end
