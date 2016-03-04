//
//  NewsTableViewCell.m
//  NewsDemo
//
//  Created by apple on 15/2/10.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "ZSNewsTableViewCell.h"


@implementation ZSNewsTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        float CellHeight=100-1;
        float orginY=10;
        float orginX=10;
        float spaceImageAndTitle=10;
        
        float imageWidth=50;
        float imageHeight=50;
        
        
        float mainHeight=imageHeight/3;
        float detailHeight=mainHeight*2;
        float labelWidth=ScreenWidth-imageWidth-2*orginX-spaceImageAndTitle;
        self.contentView.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, CellHeight)];
        
        [self.contentView addSubview:bgView];
        
        bgView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        
        _mainIV=[[UIImageView alloc] initWithFrame:CGRectMake(orginX, orginY+4, imageWidth,imageHeight-8 )];
        _mainIV.backgroundColor = [UIColor redColor];
        [bgView addSubview:_mainIV];
       
        
        _mainLabel=[[UILabel alloc] initWithFrame:CGRectMake(orginX+imageWidth+spaceImageAndTitle, orginY, labelWidth, mainHeight)];
        
        _mainLabel.backgroundColor = [UIColor yellowColor];
        [bgView addSubview:_mainLabel];
     
        
        _detailLabel=[[UILabel alloc] initWithFrame:CGRectMake(orginX+imageWidth+spaceImageAndTitle, orginY+mainHeight, labelWidth, detailHeight)];
        _detailLabel.backgroundColor = [UIColor greenColor];
        [bgView addSubview:_detailLabel];
       
        _mainLabel.font=[UIFont systemFontOfSize:18];
        
//        _mainLabel.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
//        _detailLabel.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _detailLabel.font=[UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines=0;
        _detailLabel.textColor=[UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
        
        

    
    }

    return self;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
