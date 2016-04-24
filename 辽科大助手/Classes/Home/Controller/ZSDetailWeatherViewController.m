//
//  ZSDetailWeatherViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSDetailWeatherViewController.h"
#import "ZSHttpTool.h"
#import "ZSDetailWeatherModel.h"
#import "ZSDetailWeatherCell.h"
#import "ZSDetailWeatherFrameModel.h"
#import "ZSDetailWeatherView.h"
#import "SVProgressHUD.h"

#import "MJRefresh.h"

#import "MBProgressHUD+MJ.h"


@interface ZSDetailWeatherViewController ()

@property (nonatomic, strong) ZSDetailWeatherModel *detailWeatherModel;

@property (nonatomic, strong) ZSDetailWeatherFrameModel *detailWeatherFrameModel;

@property (nonatomic, strong) ZSDetailWeatherView *detailWeatherView;

@end

@implementation ZSDetailWeatherViewController

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
 
    //获取天气信息
    [self getDetailWeatherInfo];
    
    //添加下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(getDetailWeatherInfo)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 获取详细天气信息模型*/

- (void)getDetailWeather
{
    //
    ZSDetailWeatherView *detailWeatherView = [[ZSDetailWeatherView alloc] init];

    detailWeatherView.detailWeatherModel = self.detailWeatherModel;
    self.detailWeatherView = detailWeatherView;
        
    self.tableView.tableHeaderView = detailWeatherView;
}

/** 获取天气信息*/
- (void)getDetailWeatherInfo
{
    
    [MBProgressHUD showMessage:@"正在加载天气信息..." toView:self.view];

    //获取天气信息
    [ZSHttpTool GET:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/detailWeather" parameters:nil success:^(id responseObject) {
        
        ZSDetailWeatherModel *detailWeatherModel = [ZSDetailWeatherModel objectWithKeyValues:responseObject];
        
        self.detailWeatherModel = detailWeatherModel;
        
        [self.tableView reloadData];
        //结束刷新
        [self.tableView headerEndRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self getDetailWeather];
        
    } failure:^(NSError *error) {
        
        ZSLog(@"获取详细天气信息失败");
//        [MBProgressHUD showMessage:@"您的网速太慢了..." toView:self.view];
        
        [SVProgressHUD showInfoWithStatus:@"您的网速太慢了..."];
        
        
        self.detailWeatherModel = nil;
        
        [self.tableView reloadData];
        //结束刷新
        [self.tableView headerEndRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self getDetailWeather];
        //结束刷新
        [self.tableView headerEndRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    }];
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZSDetailWeatherCell *cell = [ZSDetailWeatherCell cellWithTableView:tableView];
    
    ZSDetailWeatherFrameModel *frameModel = [[ZSDetailWeatherFrameModel alloc] init];
    self.detailWeatherFrameModel = frameModel;
    
    switch (indexPath.section) {
        case 0:
            self.detailWeatherModel.title = @"穿衣";
            break;
        case 1:
            self.detailWeatherModel.title = @"感冒";
            break;
        case 2:
            self.detailWeatherModel.title = @"运动";
            break;
        case 3:
            self.detailWeatherModel.title = @"防晒";
            break;
        default:
            break;
    }
    frameModel.detailWeatherModel = self.detailWeatherModel;
    
    cell.detailWeatherFrameModel = frameModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.detailWeatherFrameModel.cellHeight;
}


@end
