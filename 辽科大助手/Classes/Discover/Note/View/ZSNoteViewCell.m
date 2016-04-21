//
//  ZSNoteViewCell.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSNoteViewCell.h"

#import "ZSNoteModel.h"

@interface ZSNoteViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ZSNoteViewCell

/** 提供cell方法*/
+ (instancetype)noteViewCellWithTableView:(UITableView *)tableView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZSNoteViewCell" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setNote:(ZSNoteModel *)note
{
    _note = note;
    
    self.titleLabel.text = note.title;
    
    self.contentLabel.text = [NSString stringWithFormat:@" %@", note.content];
    
    if (note.icons.count) {
        
        self.iconView.image = [UIImage GetImageFromLocal:[note.icons lastObject]];
    }
    
    self.timeLabel.text = note.time;
    
    ZSLog(@"%@", note.title);

    
}

@end
