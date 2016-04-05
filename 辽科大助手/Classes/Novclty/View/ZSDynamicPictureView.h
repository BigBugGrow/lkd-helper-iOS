//
//  ZSDynamicPictureView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/6.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZSPicture;

@interface ZSDynamicPictureView : UIImageView

/** 辨别谁使用*/
@property (nonatomic, assign) NSInteger lol;

/** 缩略图的地址*/

@property (nonatomic, strong) ZSPicture *picture;

@end
