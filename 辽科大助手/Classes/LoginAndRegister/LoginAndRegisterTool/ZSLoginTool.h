//
//  ZSLoginTool.h
//  辽科大助手
//
//  Created by DongAn on 15/12/7.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSLoginTool : NSObject

+ (void)loginWithUser:(NSString *)user AndPassword:(NSString *)password success:(void(^)(NSInteger code))success failure:(void(^)(NSError *error))failure;



@end
