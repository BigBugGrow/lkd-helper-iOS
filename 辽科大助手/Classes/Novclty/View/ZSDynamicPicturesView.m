//
//  ZSDynamicPicturesView.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/6.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDynamicPicturesView.h"
#import "ZSPicture.h"
#import "ZSDynamicPictureView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

//设置最大列数
#define LBMaxColsWithCount(count) ((count == 4) ? 2 : 3)

//图片的宽高
#define LBPictureSizeWH 70
//图片之间的间距
#define LBPictureMargin 15


@implementation ZSDynamicPicturesView


- (void)setPictrueArr:(NSArray *)pictrueArr
{
    _pictrueArr = pictrueArr;
    
    
    int i = 0;
    //创建 添加足够的 LBStatusPictureView
    while (self.subviews.count < self.pictrueArr.count) {
        
        ZSDynamicPictureView * imageView = [[ZSDynamicPictureView alloc] init];
        imageView.lol = self.lol;
        imageView.tag = i ++;
        //添加手势点按
        UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tab:)];
        
        //设置UIImageView可点击
        imageView.userInteractionEnabled = YES;
        
        [imageView addGestureRecognizer:tab];
        
        [self addSubview:imageView];
    }
    
    //设置图片
    for (int i = 0; i < self.subviews.count; i ++) {
        
        if (i < self.pictrueArr.count) { //相册里的imageVIew小于图片的数量
            
            //拿到模型
            
//            NSString
            ZSPicture *picture = [[ZSPicture alloc] init];
            picture.thumbnail_pic = self.pictrueArr[i];
            
            self.subviews[i].hidden = NO;
            
            ZSDynamicPictureView *pictureView = [[ZSDynamicPictureView alloc] init];
            pictureView.lol = self.lol;
            pictureView = self.subviews[i];
            
            pictureView.picture = picture;
            
        } else { //相册里imageview数量大于image 要隐藏
            
            self.subviews[i].hidden = YES;
        }
    }

}

- (void)tab:(UITapGestureRecognizer *)tab
{
    UIImageView *tabView = (UIImageView *)tab.view;
    // ZSPhoto --> MJPhone
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    int i = 0;
    
    for (NSString *urlStr in self.pictrueArr) {

        NSString *urlS = nil;
        if (self.lol == 1) {
            
            //失物认领
            urlS = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picLostAndFound/%@.jpg", urlStr];
        } else {
            
            //糯米粒
            urlS = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picNovelty/%@.jpg", urlStr];
        }

        
        MJPhoto *p = [[MJPhoto alloc] init];
        p.url = [NSURL URLWithString:urlS];
        p.index = i;
        p.srcImageView = tabView;
        [arrM addObject:p];
        i ++;
    }
    
    //弹出图片浏览器
    //创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //MJPhone
    brower.photos = arrM;
    brower.currentPhotoIndex = tabView.tag;
    [brower show];
    
    
}

- (void)layoutSubviews
{
    //计算图片的尺寸和位置
    
    NSInteger picturesCount = self.pictrueArr.count;
    
    NSInteger maxCol = LBMaxColsWithCount(picturesCount);
    
    for (int i = 0; i < picturesCount; i ++) {
        
        ZSDynamicPictureView *imageView = self.subviews[i];
        
        //列
        int col = i % maxCol;
        imageView.x = col * (LBPictureSizeWH + LBPictureMargin);
        
        //行
        int row = i / maxCol;
        imageView.y = row * (LBPictureSizeWH + LBPictureMargin);
        
        imageView.width = LBPictureSizeWH;
        imageView.height = LBPictureSizeWH;
        
    }

}

+ (CGSize)sizeWithPicturesCount:(NSInteger)count
{
    
    //最大列数
    NSInteger maxCols = LBMaxColsWithCount(count);
    
    //列数
    NSInteger cols = (count >= maxCols) ? maxCols : count;
    CGFloat width = cols * LBPictureSizeWH + (cols - 1) * LBPictureMargin;
    
    NSInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat height = rows * LBPictureSizeWH + (rows - 1) * LBPictureMargin;
    
    return CGSizeMake(width, height);
}


@end
