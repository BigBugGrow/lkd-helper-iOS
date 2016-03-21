//
//  LBEmotion.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/15.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSEmotion : NSObject
//cht = [奥特曼],
//gif = d_aoteman.gif,
//chs = [奥特曼],
//png = d_aoteman.png,
//type = 0
/** 文字*/
@property (nonatomic, copy) NSString *cht;

/** 图片png*/
@property (nonatomic, copy) NSString *png;

//code = 0x1f625,
/**Emoji图片表情cide*/
@property (nonatomic, copy) NSString *code;


@end
