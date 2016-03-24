//
//  ZSComposePictrueView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSComposePictrueView.h"

@interface ZSComposePictrueView ()

/**
 *  图片数组
 */
@property (nonatomic, strong, readonly) NSMutableArray *pictrues;

@end

@implementation ZSComposePictrueView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _pictrues = [NSMutableArray array];
    }
    return self;
}
/**
 *  不用懒加了
 */

- (NSArray *)addPictrues
{
    return _pictrues;
}

//添加图片
- (void)addPicture:(UIImage *)picture
{
    UIImageView *pictureView = [[UIImageView alloc] init];
    pictureView.image = picture;
    [self addSubview:pictureView];
    
    [_pictrues addObject:picture];
}

//设置尺寸和颜色
- (void)layoutSubviews
{
    NSUInteger count = self.subviews.count;

    CGFloat pictureWH = 70;
    CGFloat pictureMargin = 10;
    
    for (int i = 0; i < count; i ++) {
        UIImageView *pictureView = self.subviews[i];
        pictureView.width = pictureWH;
        pictureView.height = pictureWH;
        
        NSUInteger col = i % 3;
        pictureView.x = col * (pictureWH + pictureMargin)+ pictureMargin;
        
        NSUInteger row = i / 3;
        pictureView.y = row * (pictureWH + pictureMargin) + pictureMargin;
    }
}

@end
