//
//  ZSDynamicPicturesView.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/6.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSDynamicPicturesView : UIView

/**装有图片模型的数组*/
@property (nonatomic, strong) NSArray *pictrueArr;


/**
 *  根据图片的个数计算view的大小
 */
+ (CGSize)sizeWithPicturesCount:(NSInteger)count;



@end
