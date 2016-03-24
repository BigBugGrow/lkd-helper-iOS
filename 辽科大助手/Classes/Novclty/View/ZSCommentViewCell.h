//
//  ZSCommentViewCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSComment.h"

@interface ZSCommentViewCell : UITableViewCell

/**comment模型*/
@property (nonatomic, strong) ZSComment *comment;

/** cell*/
+ (instancetype)tableViewCell;
@end
