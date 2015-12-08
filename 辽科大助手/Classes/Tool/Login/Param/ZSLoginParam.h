//
//  ZSLoginParam.h
//  辽科大助手
//
//  Created by DongAn on 15/12/7.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSLoginParam : NSObject
/**
 *  登录用户名
 */
@property (nonatomic,copy)NSString *user;
/**
 *  登录密码
 */
@property (nonatomic,copy)NSString *password;
@end
