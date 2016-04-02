//
//  ZSSaveNotes.h
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSNoteModel;

@interface ZSSaveNotes : NSObject


+ (void)saveresentNotes:(NSArray *)resentNotes;

+ (NSArray *)resentNotes;

+ (void)removeNote:(NSInteger)index;

@end
