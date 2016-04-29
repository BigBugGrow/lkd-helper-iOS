//
//  ZSAllViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/17.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSBasicViewController.h"
#import "ZSHttpTool.h"
#import "ZSAllDynamic.h"
#import "ZSAllDynamicFrame.h"
#import "ZSAllDynamicCell.h"
#import "MBProgressHUD+MJ.h"
#import "ZSCommenViewController.h"
#import "ZSNavigationController.h"
#import "MJRefresh.h"
#import "ZSMyNovcltyViewController.h"
#import "SVProgressHUD.h"


@interface ZSBasicViewController () <commenViewControllerDelegate, ZSAllDynamicCellDelegate>

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
@property (nonatomic, assign) NSInteger lastFirstDynamicId;

/**cell*/
@property (nonatomic, strong) ZSAllDynamicCell *cell;

/** 判断是否第一次加载数据*/
@property (nonatomic, assign) BOOL flag;

/**点击的行*/
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation ZSBasicViewController

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


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
    [self initTableView];
    
    //添加刷新下拉刷新
    [self settingRefresh];
    
    [ZSNotificationCenter addObserver:self selector:@selector(updateImage) name:@"swapImage" object:nil];
    
}

- (void)dealloc
{
    [ZSNotificationCenter removeObserver:self];
}


- (void)updateImage
{
    [self.tableView reloadData];
}


/** 添加下拉刷新*/
- (void)settingRefresh
{
    
    // 添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(refreshDown)];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(refreshMoreData)];
    
    [self.tableView headerBeginRefreshing];
    
    
}


/** 转换为frame模型*/
- (NSMutableArray *)dynamicsTodynamicFrameArray:(NSArray *)dynamics
{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (ZSAllDynamic *dynamic in dynamics) {
        
        ZSAllDynamicFrame *allDynamicFrame = [[ZSAllDynamicFrame alloc] init];
        allDynamicFrame.allDynamic = dynamic;
        
        [arrayM addObject:allDynamicFrame];
        
    }
    return arrayM;
}

- (void)refreshMoreData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @(self.endId);
    params[@"class"] = self.type;
    
    //结束下拉刷新
    [self.tableView headerEndRefreshing];
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/noveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        //保存上一次访问的一条数据的最后一个
        self.endId = [responseObject[@"endId"] integerValue];
              NSArray *dynamics = responseObject[@"data"];
      
        
        if (self.endId == 0){
            
            [SVProgressHUD showSuccessWithStatus:@"已经没有数据了哦..."];
            //结束下拉刷新
            [self.tableView footerEndRefreshing];
            return;
        }
        

        if (dynamics.count < 9) {
            
            self.endId = 0;
        }
        
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
            
            
        }
        
        
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        
        [self.allDynamicFrames addObjectsFromArray:arrayM];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络！！"];
        
        //结束下拉刷新
        [self.tableView footerEndRefreshing];
        
        ZSLog(@"获取信息失败");
    }];
    
}

- (void)refreshDown
{
    [self.tableView footerEndRefreshing];
    [self getNewData];
    
}

// 添加额外数组
- (NSArray *)getNewDynamicWithSavedArray:(NSArray *)savedDynamics newDynamicArray:(NSMutableArray *)arrayM
{
    //将要保存的最新的数组
    NSMutableArray *nowDynamics = [NSMutableArray array];
    
    if (savedDynamics.count) {
        
        //第一个数据的id
        NSInteger dynamicFirstID = [[[savedDynamics firstObject] ID] integerValue];
        
        for (ZSAllDynamic *allDynamic in arrayM) {
            
            if ([[allDynamic ID] integerValue] > dynamicFirstID) {
                
                //最新的加在最前面
                [nowDynamics addObject:allDynamic];
            }
        }
    } else {
        
        //如果保存的没有数据
        nowDynamics = arrayM;
    }

    return nowDynamics;
}

//获取模型信息
- (void)getNewData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @"00";
    params[@"class"] = self.type;
    
    //结束上拉刷新
    [self.tableView footerEndRefreshing];
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/noveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        //保存上一次访问的一条数据的最后一个
        if (!self.flag) {
            self.flag = true;
            self.endId = [responseObject[@"endId"] integerValue];
        }
        
        //最新的加载的数据
        NSArray *dynamics = responseObject[@"data"];
        
        //存储dynamic的模型
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
            
            //保存最新的数据
            if ([dynamic.ID integerValue] > self.lastFirstDynamicId) {
                
                [arrayM addObject:dynamic];
            }
            
        }
        
//        self.lastFirstDynamicId = [[arrayM ID] integerValue];
        
        if (arrayM.count == 0) {
            
            //结束下拉刷新
            [self.tableView headerEndRefreshing];
            return ;
        }
        
        self.lastFirstDynamicId = [[arrayM[0] ID] integerValue];
        
        //保存起来的数组
        NSArray *savedDynamics = [NSArray array];
        
        //新来的最新数据
        NSArray *nowDynamics = [self getNewDynamicWithSavedArray:savedDynamics newDynamicArray:arrayM];

        NSArray *arrayFrames = [self dynamicsTodynamicFrameArray:nowDynamics];
        
        NSRange range = NSMakeRange(0, arrayFrames.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        //将新的数据添加到大数组的最前面
        [self.allDynamicFrames insertObjects:arrayFrames atIndexes:indexSet];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        ZSLog(@"获取信息失败");
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络！！"];
        
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
    
    cell.delegate = self;
    
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
    
    //记录点击的行
    self.selectedRow = indexPath.row;
    
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
    //刷新表格
    [self.tableView reloadData];
    
}


#pragma mark - ZSAllDynamicCellDelegate的代理方法

/** 跳转到我的糯米粒信息*/
- (void)pushToMyNovcltyViewController:(ZSAllDynamicCell *)allDynamicCell nickName:(NSString *)nickName
{
    ZSMyNovcltyViewController *myNovcltyViewController = [[ZSMyNovcltyViewController alloc] init];
    
    myNovcltyViewController.whoNickName = nickName;
    
    [self.navigationController pushViewController:myNovcltyViewController animated:YES];
}



@end
