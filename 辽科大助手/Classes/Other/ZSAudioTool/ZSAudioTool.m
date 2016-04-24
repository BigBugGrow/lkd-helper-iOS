//
//  ZSAudioTool.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/10.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAudioTool.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_soundIDs;

@implementation ZSAudioTool

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
}


+ (void)playAudioWithFilename:(NSString *)fileName
{
    
    if (fileName == nil) return;
    
    //1.从字典里面取出音效
    SystemSoundID soundID = [_soundIDs[fileName] unsignedIntValue];
    
    if (!soundID) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    
        if (!url) return;
        
        //创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        
        _soundIDs[fileName] = @(soundID);
    }
    
    //播放音乐
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithFilename:(NSString *)fileName
{
    // 0.判断文件名是否为nil
    if (fileName == nil) {
        return;
    }
    
    // 1.从字典中取出音效ID
    SystemSoundID soundID = [_soundIDs[fileName] unsignedIntValue];
    
    if (soundID) {
        // 2.销毁音效ID
        AudioServicesDisposeSystemSoundID(soundID);
        
        // 3.从字典中移除已经销毁的音效ID
        [_soundIDs removeObjectForKey:fileName];
    }

}

@end
