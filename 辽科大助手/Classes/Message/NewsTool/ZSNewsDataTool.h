//
//  ZSNewsDataTool.h
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSNewsResult;
@interface ZSNewsDataTool : NSObject

+ (void)getNewsWithType:(NSString *)newsType item_start:(NSString *)item_start AndItem_end:(NSString *)item_end success:(void(^)(ZSNewsResult *newsResult))success failure:(void(^)(NSError *error))failure;

@end
