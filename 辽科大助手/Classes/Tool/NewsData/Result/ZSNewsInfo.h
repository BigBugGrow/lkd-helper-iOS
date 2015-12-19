//
//  ZSNewsInfo.h
//  辽科大助手
//
//  Created by DongAn on 15/12/9.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 id	:	2
 
 title	:	辽科大助手功能你都了解么？
 
 time	:	11月10日
 
 pic	:	1
 
 text	:	——辽科大助手功能你都了解么？
 
 url	:	http://mp.weixin.qq.com/s?__biz=MjM5OTczMzE0MQ==&mid=400525581&idx=3&sn=a508e1351523d84641bacba7d1b64969&scene=0#wechat_redirect
 
 commentnum	:
 */

@interface ZSNewsInfo : NSObject

@property (nonatomic,strong)NSNumber *id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,strong)NSNumber *commentnum;

@end
