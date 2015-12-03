//
//  ZSAccountTool.h
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSAccount;
@interface ZSAccountTool : NSObject
+ (void)saveAccount:(ZSAccount *)account;
+ (ZSAccount *)account;
@end
