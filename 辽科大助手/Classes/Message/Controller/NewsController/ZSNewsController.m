//
//  ZSNewsController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsController.h"
#import "ZSNewsCell.h"
#import "ZSNewsResult.h"
#import "ZSNewsDataTool.h"

#import "ZSNewsTool.h"
#import "ZSNewsInfo.h"

#import "ZSNewsWebViewController.h"

#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

#import "UIImageView+WebCache.h"

@interface ZSNewsController ()
@property (nonatomic,strong)NSMutableArray *newsArr;

/**最后的id*/
@property (nonatomic, strong) NSString *endID;

/**开始的id*/
@property (nonatomic, strong) NSString *item_start;

@end

@implementation ZSNewsController

- (NSMutableArray *)newsArr
{
    if (_newsArr == nil) {
        _newsArr = [NSMutableArray array];
    }
    return _newsArr;
}

/** 懒加载*/
-(NSString *)endID
{
    if (_endID == nil) {
        _endID = [NSString string];
    }
    return _endID;
}

/** 懒加载*/
-(NSString *)item_start
{
    if (_item_start == nil) {
        _item_start = [NSString string];
    }
    return _item_start;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.item_start = @"00";
    
    self.navigationItem.title = @"新鲜事儿";
    
    //开始加载数据
   [self latestNewsDataSaved];
    
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(requestLatestNewsData)];
    
    [self.tableView addFooterWithTarget:self action:@selector(reloadAgoNewsData)];
    
    
    //cell的高度
    self.tableView.rowHeight = 300;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //背景颜色
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
}

- (void)reloadAgoNewsData
{
    
    NSString *item_start = self.endID;
    
//    NSLog(@"");
    
    [ZSNewsDataTool getNewsWithType:self.newsType item_start:item_start AndItem_end:nil success:^(ZSNewsResult *newsResult) {
        
        [self.tableView footerEndRefreshing];
        
        
        if (newsResult.latestNews.count == 0) {
            
            [MBProgressHUD showError:@"已经是最后一条消息了哦"];
            return ;
        }
        
        [self.newsArr addObjectsFromArray:newsResult.latestNews];
        
        self.endID = newsResult.end_ID;
        
        [self.tableView reloadData];
        
//        [ZSNewsTool saveNewsResult:newsResult WithType:self.newsType];
        
        
    } failure:^(NSError *error) {
        if (error) {
            
            [MBProgressHUD showError:@"网络问题"];
            [self.tableView headerEndRefreshing];
        }
    }];

    
}


- (void)latestNewsDataSaved
{
    
//    ZSNewsResult *newsResult = [ZSNewsTool newsResultWithType:self.newsType];
    
    
//    if (newsResult.latestNews.count == 0) {
    [self requestLatestNewsData];
//        return;
//    }

    
}

- (void)requestLatestNewsData
{
    NSString *item_start = @"00";
    
    [ZSNewsDataTool getNewsWithType:self.newsType item_start:item_start AndItem_end:nil success:^(ZSNewsResult *newsResult) {
        
        [self.tableView headerEndRefreshing];
        
        
        ZSNewsInfo *newsInfoLast = [self.newsArr firstObject];
        
        NSMutableArray *arr = [NSMutableArray array];
        if (newsInfoLast != nil) {
            
            
            
            for (ZSNewsInfo *newsInfo in self.newsArr) {
                
                if ([newsInfo.ID integerValue] > [newsInfoLast.ID integerValue]) {
                    
                    [arr addObject:newsInfo];
                } else {
                    break;
                }
                
            }
            
            
            if (arr.count == 0) {
                
                [MBProgressHUD showError:@"已经是最新消息，请稍后再刷新"];
                return ;
            } else {
                [MBProgressHUD showError:@"刷新成功"];
                newsResult.latestNews = arr;
            }
            
        }
        NSRange range = NSMakeRange(0, newsResult.latestNews.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        //将新的数据添加到大数组的最前面
        [self.newsArr insertObjects:newsResult.latestNews atIndexes:indexSet];
        
        [arr removeAllObjects];
        
        self.endID = newsResult.end_ID;
        

        [self.tableView reloadData];
        
//        [ZSNewsTool saveNewsResult:newsResult WithType:self.newsType];
        
    } failure:^(NSError *error) {
        if (error) {
            
            [MBProgressHUD showError:@"网络问题"];
            [self.tableView headerEndRefreshing];
        }
    }];
    
    [MBProgressHUD hideHUD];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.newsArr.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ZSNewsCell *cell = [ZSNewsCell cellWithTableView:tableView];
    ZSNewsInfo *item = self.newsArr[indexPath.row];
    cell.model = item;
    cell.newsPictureType = self.newsPictureType;
    
    
    //3.图片imageView
    NSString *url = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picNewsUstl/%@.jpg", item.pic];
    
    NSURL *URL = [NSURL URLWithString:url];
    
    //    [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //        NSLog(@"----------------------");
    //    }];
    [cell.image sd_setImageWithPreviousCachedImageWithURL:URL andPlaceholderImage:[UIImage imageNamed:@"gray"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSNewsInfo *item = self.newsArr[indexPath.row];
    
    ZSNewsWebViewController *webVC = [[ZSNewsWebViewController alloc] init];
    
    webVC.title = @"详情";
    
    webVC.url = item.url;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}


@end
