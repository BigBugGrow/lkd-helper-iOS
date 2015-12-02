//
//  ZSMyInfoHeader.h
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSmyIofoHeaderDelegate <NSObject>
@optional
- (void)backButtonClick;

@end

@interface ZSMyInfoHeader : UITableViewCell

@property (nonatomic,weak)id<ZSmyIofoHeaderDelegate> delegate;

@end
