//
//  ZSNewsTool.h
//  辽科大助手
//
//  Created by DongAn on 15/12/9.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSNewsResult;
@interface ZSNewsTool : NSObject

//存取 助手新闻
+ (void)saveNewsResult:(ZSNewsResult *)account WithType:(NSString *)newType;
+ (ZSNewsResult *)newsResultWithType:(NSString *)newType;



@end
