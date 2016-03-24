//
//  ZSMyNovcltyViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/23.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSMyNovcltyViewController.h"
#import "ZSAllDynamicFrame.h"
#import "ZSCommenViewController.h"
#import "ZSAllDynamicCell.h"
#import "MJRefresh.h"
#import "ZSHttpTool.h"
#import "ZSAllDynamic.h"


@interface ZSMyNovcltyViewController ()<commenViewControllerDelegate>


/**
 *  动态模型数组
 */
@property (nonatomic, strong) NSMutableArray *allDynamicFrames;

/**
 *  cell的frame模型
 */
@property (nonatomic, strong) ZSAllDynamicFrame *allDynamicFrame;

/** item*/
@property (nonatomic, assign) NSInteger endId;

/** 上一个动态的ID*/
@property (nonatomic, assign) NSInteger lastDynamicId;

/**cell*/
@property (nonatomic, strong) ZSAllDynamicCell *cell;


@end

@implementation ZSMyNovcltyViewController

/** 懒加载*/
- (NSMutableArray *)allDynamicFrames
{
    if (_allDynamicFrames == nil) {
        
        _allDynamicFrames = [NSMutableArray array];
    }
    return _allDynamicFrames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置nav
//    [self initTableView];h
    
    //添加刷新下拉刷新
    [self settingRefresh];
    
    //获取数据
    [self getNewData];
    
    
}

/** 添加下拉刷新*/
- (void)settingRefresh
{
    // 添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(refreshDown)];
    [self.tableView headerBeginRefreshing];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(refreshMoreData)];
}

- (void)refreshMoreData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @"00";
    params[@"nickname"] = @"yyuee";
    
    //结束下拉刷新
    [self.tableView headerEndRefreshing];
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/noveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        //保存上一次访问的一条数据的最后一个
        self.endId = [responseObject[@"endId"] integerValue];
        
        NSArray *dynamics = responseObject[@"data"];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        
        for (NSDictionary *dict in dynamics) {
            
            //模型数据
            ZSAllDynamic *dynamic = [ZSAllDynamic objectWithKeyValues:dict];
            
            NSString *picPreSubStr = [dict[@"pic"] substringFromIndex:1];
            NSString *picSufSubStr = [picPreSubStr substringToIndex:picPreSubStr.length - 1];
            
            if (![picSufSubStr isEqualToString:@""]) {
                
                NSArray *pics = [picSufSubStr componentsSeparatedByString:@","];
                dynamic.pic = pics;
            } else {
                dynamic.pic = nil;
            }
            
            ZSAllDynamicFrame *allDynamicFrame = [[ZSAllDynamicFrame alloc] init];
            allDynamicFrame.allDynamic = dynamic;
            
            [arrayM addObject:allDynamicFrame];
            
            //结束下拉刷新
            [self.tableView headerEndRefreshing];
            
            //            [MBProgressHUD showMessage:@"刷新成功"];
            
        }
        [self.allDynamicFrames addObjectsFromArray:arrayM];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        
        //结束下拉刷新
        [self.tableView footerEndRefreshing];
        
        ZSLog(@"获取信息失败");
    }];
    
}

- (void)refreshDown
{
    [self.tableView headerEndRefreshing];
    [self getNewData];
    
}

//获取模型信息
- (void)getNewData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @"00";
    params[@"nickname"] = @"yyuee";
    
    //结束上拉刷新
    [self.tableView footerEndRefreshing];
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/myNoveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        
        ZSLog(@"%@", responseObject);
        
        //保存上一次访问的一条数据的最后一个
        self.endId = [responseObject[@"endId"] integerValue];
        
        NSArray *dynamics = responseObject[@"data"];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (NSDictionary *dict in dynamics) {
            
            //模型数据
            ZSAllDynamic *dynamic = [ZSAllDynamic objectWithKeyValues:dict];
            
            NSString *picPreSubStr = [dict[@"pic"] substringFromIndex:1];
            NSString *picSufSubStr = [picPreSubStr substringToIndex:picPreSubStr.length - 1];
            
            if (![picSufSubStr isEqualToString:@""]) {
                
                NSArray *pics = [picSufSubStr componentsSeparatedByString:@","];
                dynamic.pic = pics;
            } else {
                dynamic.pic = nil;
            }
            
            ZSAllDynamicFrame *allDynamicFrame = [[ZSAllDynamicFrame alloc] init];
            allDynamicFrame.allDynamic = dynamic;
            
            if ([dynamic.ID integerValue] > self.lastDynamicId ) {
                
                [arrayM addObject:allDynamicFrame];
            } else {
                break;
            }
            
            //结束下拉刷新
            [self.tableView headerEndRefreshing];
            
        }
        
        
        NSRange range = NSMakeRange(0, arrayM.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        //将新的数据添加到大数组的最前面
        [self.allDynamicFrames insertObjects:arrayM atIndexes:indexSet];
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        ZSLog(@"获取信息失败");
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
    }];
    
}


/** 初始化*/
- (void)initTableView
{
    //设置内边距
    CGFloat top = 30;
    CGFloat bottom = self.tabBarController.tabBar.height + 20;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    //设置tableView的滚动范围
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allDynamicFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //自定义cell
    ZSAllDynamicCell *cell = [ZSAllDynamicCell cellWithTableView:tableView];
    
    //赋值模型
    cell.allDynamicFrame = self.allDynamicFrames[indexPath.row];
    
    self.cell = cell;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.allDynamicFrames[indexPath.row] cellHeight];
}


/** 监听cell的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCommenViewController *commenView = [[ZSCommenViewController alloc] init];
    commenView.allDynamicFrame = self.allDynamicFrames[indexPath.row];
    commenView.title = @"评论";
    [self.navigationController pushViewController:commenView animated:YES];
    
    
    commenView.delegate = self;
    
    //    __weak typeof(self) weakSelf = self;
    //
    //    commenView.loadNewData = ^(){
    //
    //        ZSLog(@"输出");
    //        //刷新数据
    //        [weakSelf getNewData];
    //    };
    //
    
}


#pragma mark - ZSCommentViewControllerDelegate

- (void)loadNewData
{
    ZSLog(@"输出");
    //刷新数据
    [self getNewData];
}


@end
