//
//  ZSBindTool.h
//  辽科大助手
//
//  Created by DongAn on 16/2/11.
//  Copyright © 2016年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBindTool : NSObject

+ (void)bindWithUser:(NSString *)nickname key:(NSString *)key zjh:(NSString *)zjh Andmm:(NSString *)mm success:(void(^)(NSInteger code))success failure:(void(^)(NSError *error))failure;

@end
