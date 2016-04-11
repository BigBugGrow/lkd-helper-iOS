//
//  ZSAudioTool.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/10.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSAudioTool : NSObject
//播放音效
// 传入音效的名称
+ (void)playAudioWithFilename:(NSString *)fileName;

//销毁音效
+ (void)disposeAudioWithFilename:(NSString *)fileName;
@end
