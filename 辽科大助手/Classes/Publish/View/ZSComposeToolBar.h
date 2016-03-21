//
//  ZSComposeToolBar.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/13.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    ZSComposeToolBarButtonTypeCamera = 1, //相机
    ZSComposeToolBarButtonTypePicture, //图库
    ZSComposeToolBarButtonTypeTrend, //#
    ZSComposeToolBarButtonTypeEmotion, //表情
    ZSComposeToolBarButtonTypeMention //关注
    
}ZSComposeToolBarButtonType;

@class ZSComposeToolBar;

//添加按钮点击监听方法
@protocol ZSComposeToolBarDelegate <NSObject>

@optional
- (void)composeToolBar:(ZSComposeToolBar *)composeToolBar didClickButton:(ZSComposeToolBarButtonType)btnType;

@end

@interface ZSComposeToolBar : UIView

@property (nonatomic, weak) id<ZSComposeToolBarDelegate> delegate;

/**
 *  转化键盘的图片转换
 */
- (void)switchKeyboardWitgImage:(NSString *)image highLightImage:(NSString *)highLightImage;

@end
