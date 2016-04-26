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
#import "ZSCourseViewController.h"
#import "SVProgressHUD.h"

#import "ZSLostAndFoundViewController.h"
#import "ZSAboutViewController.h"


@interface ZSHomeViewController ()<ZSWeatherViewDelegate>

@property (nonatomic,strong)NSDictionary *weatherData;

@property (nonatomic,strong)NSMutableArray *cellData;

@property (nonatomic, strong) ZSWeatherView *weathrView;

@property (nonatomic,strong)ZSTimeTableCell *timeTable;

@property (nonatomic,assign)long currentWeek;

/**account*/
@property (nonatomic, strong) ZSAccount *account;

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

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    //消除通知对象
    [ZSNotificationCenter removeObserver:self];
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
    
    [ZSNotificationCenter addObserver:self selector:@selector(refreshWeatherDataAndTimeTableData) name:@"overAddCourse" object:nil];
    
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



-(NSInteger)getUTCFormateDate:(NSString *)newsDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    
    int days=((int)time)/(3600*24);
    
    return days;
}


- (void)initTimeTabelData
{
    //得到账户信息
    ZSAccount *account = [ZSAccountTool account];
    self.account = account;
    
//    ZSLog(@"%@", account.key);
    
     //1.计算当前是第几周，星期几
    NSDate *currentDay = [NSDate date];
    NSInteger count = [self getUTCFormateDate:account.termBeginTime];

    //第几周
    self.currentWeek = count / 7 + 1;
    
    NSInteger weekday = currentDay.weekday;
    
    if (weekday == 7) {
        weekday = 0;
    }
    
    if (![account.hasTimetable isEqualToString:@"no"] || account == nil) {
        
        //1.得到当天的课表字典
        NSDictionary *dayDict = account.timetable[self.currentWeek][weekday];
        
        ZSTimeTabelModel *timetable0 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@0]];
        ZSTimeTabelModel *timetable1 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@1]];
        ZSTimeTabelModel *timetable2 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@2]];
        ZSTimeTabelModel *timetable3 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@3]];
        ZSTimeTabelModel *timetable4 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@4]];
        
        
//        3.使用NSDateFormatter可以将字符串转换成NSDate类型。同样需要注意格式的问题。
        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"HH:mm"];
        
        [formatter setTimeZone:localzone];
        
        NSString * dateStr = [formatter stringFromDate:[NSDate date]];
        
        
        [formatter setDateFormat:@"HH:mm"];
        
        if (timetable0 && [timetable0.timeOfLesson isEqualToString:dateStr]) {
            
            //1.创建本地通知对对象
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            
            //指定通知发送的时间
            noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            //指定时区
            noti.timeZone = [NSTimeZone defaultTimeZone];
            noti.alertBody = @"马上要上课喽";
            
            noti.alertAction = @"查看消息";
            noti.alertLaunchImage = @"splash_tops";
            noti.soundName = UILocalNotificationDefaultSoundName;
            
            
            //2注册通知
            UIApplication *app = [UIApplication sharedApplication];
            
            [app scheduleLocalNotification:noti];
            
        }
        
    
        
        ZSHomeGroupModel *group1 = [[ZSHomeGroupModel alloc] init];
        group1.items = @[timetable0,timetable1,timetable2,timetable3,timetable4];
        
        self.cellData[0] = group1;
        
    } else {
        
        ZSTimeTabelModel *timetable = [[ZSTimeTabelModel alloc] init];
        ZSHomeGroupModel *group1 = [[ZSHomeGroupModel alloc] init];
        group1.items = @[timetable,timetable,timetable,timetable,timetable];
        
        self.cellData[0] = group1;
    
    }
    

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
    
    ZSInquireModel *item4 = [ZSInquireModel itemWithIcon:@"test" title:@"考试报名" vcClass:[ZSInquireWebViewController class]];

    ZSInquireModel *item5 = [ZSInquireModel itemWithIcon:@"queryScore" title:@"成绩查询" vcClass:[ZSInquireWebViewController class]];
    ZSInquireModel *item6 = [ZSInquireModel itemWithIcon:@"classroom" title:@"空教室" vcClass:[ZSInquireWebViewController class]];
    
    ZSInquireModel *item7 = [ZSInquireModel itemWithIcon:@"plan" title:@"培养计划" vcClass:[ZSInquireWebViewController class]];
    ZSInquireModel *item8 = [ZSInquireModel itemWithIcon:@"student" title:@"学生信息" vcClass:[ZSInquireWebViewController class]];
    
    ZSHomeGroupModel *group2 = [[ZSHomeGroupModel alloc] init];
    group2.items = @[item1,item2,item3,item4,item5,item6,item7,item8];
    [self.cellData addObject:group2];

}

#pragma mark -  设置导航栏按钮
- (void)setUpNavigtionItem
{
    
    NSMutableDictionary *attris = [NSMutableDictionary dictionary];
    
    attris[NSFontAttributeName] = [UIFont systemFontOfSize:23.0];
    attris[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:attris];
    self.navigationItem.title = @"辽科大助手";
    
    
    UIImage *leftImage = [UIImage imageCompressForSize:[UIImage imageNamed:@"top_title"] targetSize:CGSizeMake(44, 44)];
    UIImage *rightImage = [UIImage imageCompressForSize:[UIImage imageNamed:@"top_search"] targetSize:CGSizeMake(44, 44)];
    
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:leftImage highImage:nil target:self action:@selector(kdLogClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:rightImage highImage:nil target:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)kdLogClick
{
    ZSAboutViewController *about = [[ZSAboutViewController alloc] init];
    
    [self.navigationController pushViewController:about animated:YES];
}

- (void)find
{
    ZSLostAndFoundViewController *lostAndFoundViewVC = [[ZSLostAndFoundViewController alloc] init];

    //寻找丢失物品
    [self.navigationController pushViewController:lostAndFoundViewVC animated:YES];
}

#pragma mark - ZSWeather的代理方法

- (void)weatherDetailController
{
    //详细天气界面
    ZSDetailWeatherViewController *detailWeatherViewController = [[ZSDetailWeatherViewController alloc] init];
    
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
    
    ZSCourseViewController *courseViewController = [[ZSCourseViewController alloc] init];
    
    if (indexPath.section == 1) {
        
        if(item.class) {
            
           // id vc = [[item.vcClass alloc] init];
            ZSInquireWebViewController *inquireVC = [[ZSInquireWebViewController alloc] init];
            ZSAccount *account = [ZSAccountTool account];
            
            if ([account.hasTimetable isEqualToString:@"no"] || account == nil) {
                
                [SVProgressHUD showErrorWithStatus:@"亲， 你还没绑定学号哦！"];
                return;
            }
            
            switch (indexPath.row + 1) {
                case 1:
                    if (![account.hasTimetable isEqualToString:@"no"]) {
                    
                        [self.navigationController pushViewController:courseViewController animated:YES];
                        return;
                    break;
                case 2:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/teachingEvaluation"];
                    
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
                case 8:
                    inquireVC.inquireURL = [NSString stringWithFormat:@"http://infinitytron.sinaapp.com/tron/index.php?r=ustl/studentinfo"];
                    break;
                default:
                    break;
            }
        }
            
            inquireVC.title = item.title;
            
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
