//
//  ZSComposePictrueView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/14.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSComposePictrueView : UIView

//添加图片
- (void)addPicture:(UIImage *)picture;

/**
 *  提供图片方法
 */
- (NSArray *)addPictrues;
@end
