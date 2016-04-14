//
//  ZSInfoViewCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSInfoViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/** cell*/
+ (instancetype)tableViewCell;

/** 详细*/
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
