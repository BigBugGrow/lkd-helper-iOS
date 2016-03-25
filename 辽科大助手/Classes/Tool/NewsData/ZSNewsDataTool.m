//
//  ZSNewsDataTool.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsDataTool.h"
#import "ZSNewsParams.h"
#import "ZSNewsResult.h"

#import "ZSHttpTool.h"
#import "ZSNewsTool.h"

#import "MJExtension.h"

@implementation ZSNewsDataTool
+ (void)getNewsWithType:(NSString *)newsType item_start:(NSString *)item_start AndItem_end:(NSString *)item_end success:(void(^)(ZSNewsResult *newsResult))success failure:(void(^)(NSError *error))failure
{
    //创建参数模型
    ZSNewsParams *params = [[ZSNewsParams alloc] init];
    params.item_start = item_start;
    params.item_end = item_end;

    [ZSHttpTool POST:[NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=site/%@",newsType] parameters:params.keyValues success:^(id responseObject) {
        
        //把网络请求到的 可变字典 转化成 字典，字典中把所有新闻存到一个数组中

        int num = [responseObject[@"info_num"] intValue];
        
        NSMutableArray *news = [NSMutableArray arrayWithCapacity:num+1];
        
        for (int i = 0; i <= num; i++) {
            [news addObject:@"5"];
        }
        
        for (id key in responseObject) {
            
            if ([responseObject[key] isKindOfClass:[NSDictionary class]]) {
                
                [news replaceObjectAtIndex:[key integerValue] withObject:responseObject[key]];
            }
        }
        [news removeObjectAtIndex:0];

        
        NSMutableDictionary *newsDict =[NSMutableDictionary dictionaryWithDictionary:responseObject];
        newsDict[@"latestNews"] = news;
        
        //字典转模型
        ZSNewsResult *newsResult = [ZSNewsResult objectWithKeyValues:newsDict];
        
        if (success) {
            success(newsResult);
            
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
