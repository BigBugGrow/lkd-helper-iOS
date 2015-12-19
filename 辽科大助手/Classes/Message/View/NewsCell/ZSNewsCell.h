//
//  ZSNewsCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/9.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSNewsInfo;
@interface ZSNewsCell : UITableViewCell

@property (nonatomic,copy)NSString *newsPictureType;
@property (nonatomic,strong)ZSNewsInfo *model;


//3.图片imageView
@property (nonatomic,weak)UIImageView *image;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
