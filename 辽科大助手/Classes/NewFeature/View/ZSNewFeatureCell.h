//
//  ZSNewFeatureCell.h
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSNewFeatureCell : UICollectionViewCell
@property (nonatomic,strong)UIImage *image;

//判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
