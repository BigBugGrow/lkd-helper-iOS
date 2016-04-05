//
//  ZSDynamicPictureView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/6.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDynamicPictureView.h"
#import "ZSPicture.h"
#import "UIImageView+WebCache.h"

@interface ZSDynamicPictureView ()

//@property (nonatomic, strong) UIImageView *gifView;

@end

@implementation ZSDynamicPictureView

//- (UIImageView *)gifView
//{
//    if (_gifView == nil) {
//        //添加gif图片框
//        
//        //这样设置image  imageview才会自动根据图片的大小设置自己的尺寸
////        UIImage *image = [UIImage imageNamed:@"blue"];
////        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
////        [self addSubview:gifView];
////        _gifView = gifView;
//    }
//    return _gifView;
//}


/**
 *  改变图片内容模式
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //        UIViewContentModeScaleToFill,
        //        UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
        //        UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
        //        UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
        //        UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
        //        UIViewContentModeTop,
        //        UIViewContentModeBottom,
        //        UIViewContentModeLeft,
        //        UIViewContentModeRight,
        //        UIViewContentModeTopLeft,
        //        UIViewContentModeTopRight,
        //        UIViewContentModeBottomLeft,
        //        UIViewContentModeBottomRight,
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)setPicture:(ZSPicture *)picture
{
    
    _picture = picture;
    //设置图片
    
    NSString *str = nil;
    
    //失物认领
    if (self.lol == 1) {
        
        str = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picLostAndFound/%@.jpg!small", picture.thumbnail_pic];
        
    } else { //糯米粒
        
        str = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picNovelty/%@.jpg!small", picture.thumbnail_pic];
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"about"]];
    
    //创建gif动画提示
    //    if ([picture.thumbnail_pic.lowercaseString hasSuffix:@"gif"]) {
    //        self.gifView.hidden = NO;
    //    } else {
    //        self.gifView.hidden = YES;
    //    }
    
//    self.gifView.hidden = ![picture.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.gifView.x = self.width - self.gifView.width;
//    self.gifView.y = self.height - self.gifView.height;
//}


@end
