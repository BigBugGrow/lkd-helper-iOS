//
//  ZSTableViewCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSTableViewCell.h"
#import "ZSModel.h"
@implementation ZSTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    ZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (cell == nil) {
        cell = [[ZSTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //修改cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setItem:(ZSModel *)item
{
    _item = item;
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.text = item.title;
    self.imageView.image = [UIImage imageNamed:item.icon];
    
    self.detailTextLabel.x = -80;
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.text = item.detailTitle;
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
}

@end
