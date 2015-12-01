//
//  ZSProfileModel.h
//  辽科大助手
//
//  Created by DongAn on 15/11/30.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OperationBlock)();

@interface ZSProfileModel : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *icon;

@property (nonatomic,assign)Class vcClass;

@property (nonatomic,copy)OperationBlock operation;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title vcClass:(Class)vcClass;
@end
