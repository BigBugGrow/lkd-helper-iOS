//
//  ZSNewFeatureCell.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewFeatureCell.h"
#import "ZSTabBarController.h"
#import "ZSLoginViewController.h"
#import "ZSAccountTool.h"
@interface ZSNewFeatureCell()
@property (nonatomic,weak)UIImageView *imageView;
@end

@implementation ZSNewFeatureCell

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageView = imageV;
        
        [self.contentView addSubview:imageV];
    }
    return _imageView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) {
        ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
        
        //判断是否登录过
        if ([ZSAccountTool account]) {//登录过
            ZSKeyWindow.rootViewController = tabBarVC;
        } else {
            ZSLoginViewController *vc = [[ZSLoginViewController alloc] init];
            ZSKeyWindow.rootViewController = vc;
        }
       
    }
}

@end
