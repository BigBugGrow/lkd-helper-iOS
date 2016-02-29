//
//  ZSWeatherCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSWeatherCell.h"
#import "ZSWeatherModel.h"

@interface ZSWeatherCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayon_dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayon_weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UILabel *daon_temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWeekLabel;

@end

@implementation ZSWeatherCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)layoutSubviews
{
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"weatherCell";
    
    ZSWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZSWeatherCell" owner:nil options:nil] lastObject];
    }

    
    
    return cell;
}

- (void)setItem:(ZSWeatherModel *)item
{
    _item = item;

    self.dayon_dateLabel.text = item.date;
    self.dayon_weatherLabel.text = item.weather;
    self.pm25Label.text = [NSString stringWithFormat:@"PM2.5: %@",item.pm25];
    self.daon_temperatureLabel.text = item.temperature;
    self.currentWeekLabel.text = [NSString stringWithFormat:@"%@周",item.currentWeek];
    
}
@end
