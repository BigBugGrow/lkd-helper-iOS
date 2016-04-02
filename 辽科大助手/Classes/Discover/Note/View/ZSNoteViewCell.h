//
//  ZSNoteViewCell.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSNoteModel;

@interface ZSNoteViewCell : UITableViewCell


/**笔记模型*/
@property (nonatomic, strong) ZSNoteModel *note;

/** 提供cell方法*/
+ (instancetype)noteViewCellWithTableView:(UITableView *)tableView;

@end
