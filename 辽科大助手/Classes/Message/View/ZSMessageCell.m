//
//  ZSMessageCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSMessageCell.h"
#import "ZSMessageModel.h"

@implementation ZSMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    ZSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}


- (void)setItem:(ZSMessageModel *)item
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
