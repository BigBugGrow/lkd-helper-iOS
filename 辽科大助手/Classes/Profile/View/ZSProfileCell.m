//
//  ZSProfileCell.m
//  辽科大助手
//
//  Created by DongAn on 15/11/30.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSProfileCell.h"
#import "ZSProfileModel.h"

@interface ZSProfileCell ()

@end

@implementation ZSProfileCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    ZSProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ZSProfileCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    return cell;
}


- (void)setItem:(ZSProfileModel *)item
{
    _item = item;
    
    self.font = [UIFont systemFontOfSize:12];

    self.textLabel.text = item.title;
    self.imageView.image = [UIImage imageNamed:item.icon];
    
}

@end
