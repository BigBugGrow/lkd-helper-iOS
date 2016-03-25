//
//  ZSHomeViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSHomeViewController.h"

#import "NSDate+Convert.h"
#import "NSDate+Utilities.h"

#import "UIImage+Image.h"
#import "UIBarButtonItem+Item.h"
#import "ZSHttpTool.h"

#import "ZSHomeGroupModel.h"
#import "ZSWeatherModel.h"

#import "ZSWeatherView.h"
#import "ZSTimeTabelModel.h"
#import "ZSTimeTableCell.h"
#import "ZSInquireModel.h"
#import "ZSInquireCell.h"

#import "ZSAccount.h"
#import "ZSAccountTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

#import "ZSInquireWebViewController.h"
#import "ZSDetailWeatherViewController.h"


@interface ZSHomeViewController ()<ZSWeatherViewDelegate>

@property (nonatomic,strong)NSDictionary *weatherData;

@property (nonatomic,strong)NSMutableArray *cellData;

@property (nonatomic, strong) ZSWeatherView *weathrView;

@property (nonatomic,strong)ZSTimeTableCell *timeTable;

@property (nonatomic,assign)long currentWeek;

@end

@implementation ZSHomeViewController

- (NSMutableArray *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableArray array];
    }
    return _cellData;
}

-(NSDictionary *)weatherData:(NSDictionary *)dict
{
    if (_weatherData == nil) {
        _weatherData = [NSDictionary dictionaryWithDictionary:dict];
    }
    return  _weatherData;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏按钮
    [self setUpNavigtionItem];
    
    //请求天气数据
    [self getWeatherData];
    
    //配置课表数据
    [self initTimeTabelData];
    
    //配置查询表格数据
    [self initInquireData];
    
    self.tableView.rowHeight = 66;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    //设置显示天气信息
    [self exhibitWeatherInfo];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(refreshWeatherDataAndTimeTableData)];
}

- (void)refreshWeatherDataAndTimeTableData
{
    [self initTimeTabelData];
    [self getWeatherData];
}

#pragma mark -配置表格数据'

- (void)exhibitWeatherInfo
{
    //添加天气信息
    ZSWeatherView *weatherView = [[[NSBundle mainBundle] loadNibNamed:@"ZSWeatherView" owner:nil options:nil] lastObject];
    weatherView.delegate = self;
    
    [weatherView addTarget:self action:@selector(weatherDetailController) forControlEvents:UIControlEventTouchUpInside];
    
    ZSWeatherModel *weatherModel = [ZSWeatherModel objectWithKeyValues:self.weatherData];
    
    weatherView.weatherModel = weatherModel;
    self.weathrView = weatherView;
    self.tableView.tableHeaderView = self.weathrView;

}


- (void)initWeatherData
{
    //初始化天气数据
    ZSWeatherModel *weathItem = [ZSWeatherModel objectWithKeyValues:self.weatherData];
//    self.weathrHeader.item = weathItem;
    self.weathrView.weatherModel = weathItem;
    
}

//请求天气数据
- (void)getWeatherData
{
    [ZSHttpTool GET:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/simpleWeather" parameters:nil success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *weatherDictWithCurrentWeek = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            weatherDictWithCurrentWeek[@"currentWeek"] = [NSNumber numberWithLong: self.currentWeek];
            self.weatherData = [NSDictionary dictionaryWithDictionary:weatherDictWithCurrentWeek];
            
            //配置表格数据
            [self initWeatherData];
        });
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"联网获取天气信息"];
    }];
}

- (void)initTimeTabelData
{
    //得到账户信息
    ZSAccount *account = [ZSAccountTool account];
    
    if ([account.zjh isEqualToString:@"null"]) {
        return;
    }
    
    //初始化课表数据
    //1.计算当前是第几周，星期几
    NSDate *currentDay = [NSDate date];
    
    ZSLog(@"%@", currentDay);
    
    //星期几
    long weekday = currentDay.weekday - 1;
    if (weekday == 0) weekday = 7;
    
    ZSLog(@"一周中第几天%ld", weekday);
    
#warning 这里周数计算有问题
    //第几周
    
//    self.currentWeek = currentDay.week + 51 - [account.startweek intValue] + 1;
    
    self.currentWeek = 3;
    
//    NSLog(@"ccc%@",currentDay);
    
    
    NSLog(@"------%@",account.timetable[self.currentWeek][weekday]);
    
    
    //1.得到当天的课表字典
    NSDictionary *dayDict = account.timetable[self.currentWeek][weekday];

    ZSTimeTabelModel *timetable0 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@0]];
    ZSTimeTabelModel *timetable1 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@1]];
    ZSTimeTabelModel *timetable2 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@2]];
    ZSTimeTabelModel *timetable3 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@3]];
    ZSTimeTabelModel *timetable4 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@4]];
    
    ZSHomeGroupModel *group1 = [[ZSHomeGroupModel alloc] init];
    group1.items = @[timetable0,timetable1,timetable2,timetable3,timetable4];
    
    self.cellData[0] = group1;
    
    [self.tableView reloadData];
    
    //结束下拉刷新
    [self.tableView headerEndRefreshing];

   // NSLog(@"%@",timetable2.orderLesson);
    
}

- (void)initInquireData
{
    ZSInquireModel *item1 = [ZSInquireModel itemWithIcon:@"timetable" title:@"详细课表"];
    ZSInquireModel *item2 = [ZSInquireModel itemWithIcon:@"evaluate" title:@"评教" vcClass:[ZSInquireWebViewController class]];
    ZSInquireModel *item3 = [ZSInquireModel itemWithIcon:@"select" title:@"选课" vcClass:[ZSInquireWebViewController class]];
    
    ZSInquireModel *item4 = [ZSInquireModel itemWithIcon:@"archives" title:@"考试报名" vcClass:[ZSInquireWebViewController class]];

    ZSInquireModel *item5 = [ZSInquireModel itemWithIcon:@"mark" title:@"成绩查询" vcClass:[ZSInquireWebViewController class]];
    ZSInquireModel *item6 = [ZSInquireModel itemWithIcon:@"classroom" title:@"空教室" vcClass:[ZSInquireWebViewController class]];
    
    ZSInquireModel *item7 = [ZSInquireModel itemWithIcon:@"select" title:@"培养计划" vcClass:[ZSInquireWebViewController class]];
    
    
    ZSHomeGroupModel *group2 = [[ZSHomeGroupModel alloc] init];
    group2.items = @[item1,item2,item3,item4,item5,item6,item7];
    [self.cellData addObject:group2];

}

#pragma mark -  设置导航栏按钮
- (void)setUpNavigtionItem
{
    UIImage *leftImage = [UIImage imageCompressForSize:[UIImage imageNamed:@"top_title"] targetSize:CGSizeMake(44, 44)];
    UIImage *rightImage = [UIImage imageCompressForSize:[UIImage imageNamed:@"top_search"] targetSize:CGSizeMake(44, 44)];
    
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:leftImage highImage:nil target:self action:@selector(kdLogClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:rightImage highImage:nil target:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)kdLogClick
{
    
}

- (void)find
{
    
}

#pragma mark - ZSWeather的代理方法

- (void)weatherDetailController
{
    
    ZSDetailWeatherViewController *detailWeatherViewController = [[ZSDetailWeatherViewController alloc] init];
    
//    [self.navigationController presentViewController:detailWeatherViewController animated:YES completion:nil];
    
    detailWeatherViewController.title = @"详细天气";
    
    [self.navigationController pushViewController:detailWeatherViewController animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return self.cellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ZSHomeGroupModel *group = [[ZSHomeGroupModel alloc] init];
    group = self.cellData[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
//    if (indexPath.section == 0) {
//
//
//    }
    if (indexPath.section == 1) {
        ZSInquireCell *cell = [ZSInquireCell cellWithTableView:tableView];
        ZSHomeGroupModel *group = self.cellData[indexPath.section];
        ZSInquireModel *item = group.items[indexPath.row];
        cell.item = item;
        
        return cell;

    }
    ZSTimeTableCell *cell = [ZSTimeTableCell timeTabelCellWithTableView:tableView];
    ZSHomeGroupModel *group = self.cellData[indexPath.section];
    ZSTimeTabelModel *item = group.items[indexPath.row];
    cell.model = item;
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZSHomeGroupModel *group = self.cellData[indexPath.section];
    ZSInquireModel *item = group.items[indexPath.row];
    
    if (indexPath.section == 1) {
        
        if(item.class) {
            
           // id vc = [[item.vcClass alloc] init];
            ZSInquireWebViewController *inquireVC = [[ZSInquireWebViewController alloc] init];
//            ZSAccount *account = [ZSAccountTool account];
            switch (indexPath.row + 1) {
                case 1:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/timetable"];
                    break;
                case 2:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/teachingEvaluation"];
                    break;

                case 3:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/selectclass"];
                    break;

                case 4:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/ExamApply"];
                    break;
                case 5:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/score"];
                    break;
                    
                case 6:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/EmptyClassroom"];
                    break;
    
                case 7:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/TrainingPlan"];
                    break;
                default:
                    break;
            }
        
            [self.navigationController pushViewController:inquireVC animated:YES];
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
