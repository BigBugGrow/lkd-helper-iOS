//
//  ZSDiscoverCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSDiscoverCell.h"
#import "ZSDiscoverModel.h"

@implementation ZSDiscoverCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    ZSDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}


- (void)setItem:(ZSDiscoverModel *)item
{
    _item = item;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.text = item.title;
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.detailTextLabel.text = item.detailTitle;
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
}

@end
