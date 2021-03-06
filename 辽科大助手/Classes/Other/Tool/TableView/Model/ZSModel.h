//
//  ZSModel.h
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OperationBlock)();
@interface ZSModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *detailTitle;

@property (nonatomic,assign)Class vcClass;

@property (nonatomic,copy)OperationBlock operation;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle vcClass:(Class)vcClass;
@end
