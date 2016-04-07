//
//  ZSWriteNoteViewController.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSWriteNoteViewController, ZSNoteModel;

@protocol ZSWriteNoteViewControllerDelegate <NSObject>

/** 新添加的属性*/
- (void)writeNoteViewControllerDelegate:(ZSWriteNoteViewController *)writeNoteViewController noteModael:(ZSNoteModel *)noteModel;

/** 修改后添加的模型 th 表示第几个模型*/
- (void)writeNoteViewControllerDelegate:(ZSWriteNoteViewController *)writeNoteViewController addnoteModael:(ZSNoteModel *)noteModel th:(NSInteger)th;

@end

@interface ZSWriteNoteViewController : UIViewController

/** 添加代理属性*/
@property (nonatomic, weak) id<ZSWriteNoteViewControllerDelegate> delegate;

/** 模型属性*/
@property (nonatomic, strong) ZSNoteModel *note;

/** 第几条模型*/
@property (nonatomic, assign) NSInteger th;

@end
