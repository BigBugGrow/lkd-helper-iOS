//
//  ZSInquireCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/4.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSInquireCell.h"
#import "ZSInquireModel.h"

@implementation ZSInquireCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"inquireCell";
    
    ZSInquireCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        cell = [[ZSInquireCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)setItem:(ZSInquireModel *)item
{
    _item = item;

    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.text = item.title;
    self.imageView.image = [UIImage imageNamed:item.icon];
}


@end
