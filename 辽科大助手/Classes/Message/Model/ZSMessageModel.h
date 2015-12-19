//
//  ZSMessageModel.h
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OperationBlock)();

@interface ZSMessageModel : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *detailTitle;

@property (nonatomic,assign)Class vcClass;

@property (nonatomic,copy)OperationBlock operation;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle vcClass:(Class)vcClass;

@end
