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


- (void)reLoadTimeTable
{
    
//    [MBProgressHUD showMessage:@"正在从服务器获取课表..."];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser];
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nickname"] = userName;
    params[@"key"] = key;
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/reGetTimetable" parameters:params success:^(id responseObject) {
        
        
        if ([responseObject[@"state"] integerValue] == 603) {
            
            return ;
        }
        
        
        NSMutableDictionary *accountDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        //warning 新接口返回的课表中的周，还是以字符串形式返回的，还是得重新处理，烦人
        
        if (![@"<null>" isEqualToString:accountDict[@"timetable"]]) {
            
            
//            [MBProgressHUD hideHUD];
            
//            [MBProgressHUD showSuccess:@"获取课表成功"];
            
            //初始化一个 课表 的可变数组
            NSMutableArray *timetableArrayM = [NSMutableArray arrayWithArray:accountDict[@"timetable"]];
            int i = 0;
            for (NSMutableDictionary *d in accountDict[@"timetable"]) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:d];
                
                //取出头和尾 []
                NSString *weekValueSubPre = [dict[@"week"] substringFromIndex:1];
                NSString *weekValueSubPreAndSuf = [weekValueSubPre substringToIndex:weekValueSubPre.length];
                
                NSArray *weekStrNumArr = [weekValueSubPreAndSuf componentsSeparatedByString:@","];
                NSMutableArray *weekNumArr = [NSMutableArray array];
                for (NSString *str in weekStrNumArr) {
                    [weekNumArr addObject:[NSNumber numberWithInteger:[str integerValue]]];
                }
                
                [dict setObject:weekNumArr forKey:@"week"];
                
                [timetableArrayM setObject:dict atIndexedSubscript:i];
                i++;
                
            }
            
            [accountDict setObject:timetableArrayM forKey:@"timetable"];
            
            //字典数组转存放天课表，周课表的二维数组
            NSArray *planarArr = [self timetableDictArrConvertToPlanarArr:accountDict[@"timetable"]];
            
            
            [NSKeyedArchiver archiveRootObject:planarArr toFile:ZSTimeTablePath];
            
            
            accountDict[@"timetable"] = planarArr;
            
            NSLog(@"%@", planarArr);
            
            [ZSAccountTool saveAccountTimeTable:planarArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self initTimeTabelData];
            });
            
            
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"由于服务器问题， 未获取到课表, 请重新登录获取课表..."];
        }
        
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"由于网络问题， 未获取到课表, 请重新登录获取课表..."];
    }];
    

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
    
//    [self reLoadTimeTable];
    
    if ( account.zjh != nil && account.timetable != nil &&![account.hasTimetable isEqualToString:@"no"]&& ![account.zjh isEqualToString:@"暂无"]) {
        
        //1.得到当天的课表字典
        NSDictionary *dayDict = account.timetable[self.currentWeek][weekday];
        
        ZSTimeTabelModel *timetable0 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@0]];
        ZSTimeTabelModel *timetable1 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@1]];
        ZSTimeTabelModel *timetable2 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@2]];
        ZSTimeTabelModel *timetable3 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@3]];
        ZSTimeTabelModel *timetable4 = [ZSTimeTabelModel objectWithKeyValues:dayDict[@4]];
        
#warning 实现本地推送， 暂时还没有实现
        
//        NSString *course0 = [NSString stringWithFormat:@"第一大节: %@", timetable0.course ? timetable0.course : @"无"];
//        
//        NSString *course1 = [NSString stringWithFormat:@"第二大节: %@", timetable1.course ? timetable1.course : @"无"];
//        
//        NSString *course2 = [NSString stringWithFormat:@"第三大节: %@", timetable2.course ? timetable2.course : @"无"];
//        
//        NSString *course3 = [NSString stringWithFormat:@"第四大节: %@", timetable3.course ? timetable3.course : @"无"];
//        
//        NSString *course4 = [NSString stringWithFormat:@"第五大节: %@", timetable4.course ? timetable4.course : @"无"];
        
//        NSString *course = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", course0, course1, course2, course3, course4];
//        
////        3.使用NSDateFormatter可以将字符串转换成NSDate类型。同样需要注意格式的问题。
//        NSTimeZone* localzone = [NSTimeZone localTimeZone];
//        
//        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//        
//        [formatter setDateFormat:@"HH:mm"];
//        
//        [formatter setTimeZone:localzone];
//        
//        NSInteger hour = currentDay.hour;
//        NSInteger minute = currentDay.minute;
//        
//        
//        if (hour == 7 && minute == 30) {
//
//            [self registerLocalNotification:15 withCourseStr:course];
//            
////            //1.创建本地通知对对象
////            UILocalNotification *noti = [[UILocalNotification alloc] init];
////            
////            //指定通知发送的时间
////            noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
////            //指定时区
////            noti.timeZone = [NSTimeZone defaultTimeZone];
////            noti.alertBody = @"马上要上课喽";
////            
////            noti.alertAction = @"查看消息";
////            noti.alertLaunchImage = @"splash_tops";
////            noti.soundName = UILocalNotificationDefaultSoundName;
////            
////            //2注册通知
////            UIApplication *app = [UIApplication sharedApplication];
////            
////            [app scheduleLocalNotification:noti];
//            
//        }
        
    
        
        ZSHomeGroupModel *group1 = [[ZSHomeGroupModel alloc] init];
        group1.items = @[timetable0,timetable1,timetable2,timetable3,timetable4];
        
        self.cellData[0] = group1;
        
    } else {
        
        [self reLoadTimeTable];
        
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
            
            if (([account.zjh isEqualToString:@"暂无"] && [account.hasTimetable isEqualToString:@"no"]) || account.zjh == nil) {
                
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

#pragma mark - 本地通知
// 设置本地通知
- (void)registerLocalNotification:(NSInteger)alertTime withCourseStr:(NSString *)courseStr{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];

    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];

    //计算世界时间与本地时区的时间偏差值
    NSInteger offset = [localTimeZone secondsFromGMTForDate:fireDate];

    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate = [fireDate dateByAddingTimeInterval:offset];

    ZSLog(@"fireDate=%@",fireDate);

    ZSLog(@"fireDate=%@",localDate);

    notification.fireDate = fireDate;
    //    notification.fireDate = [NSDate dateWithTimeIntervalSince1970:];
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitDay;

    // 通知内容
    notification.alertBody =  courseStr;
//        notification.applicationIconBadgeNumber = 20;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
//    // 通知参数
//    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始新的一天喽！" forKey:@"key"];
//    notification.userInfo = userDict;

    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }

    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}



#pragma mark - 获取课表
- (NSArray *)timetableDictArrConvertToPlanarArr:(NSArray *)dictArr
{
    //获得课表信息
    
    // 1>用MJExtension得到课表的字典数组，每一个字典是一个课程的信息，包括周，地点，老师，课程名
    //    NSArray *timetableModel = [ZSAccountTool account].timetable;
    //    NSArray *allCourseInfoWithDictArr = [ZSTimeTable keyValuesArrayWithObjectArray:timetableModel];
    // NSLog(@"%@",allCourseInfoWithDictArr);
    //2>分割字典数组，把信息按周次，星期几，生成课表
    
    
    
    //初始化20*7个字典，每个字典存每天的课表
    //1>周课表数组（20周）
    NSMutableArray *weeksSyllabus = [NSMutableArray array];
    //2>天课表数组（7天）
    NSMutableArray *daysSyllabus = [NSMutableArray array];
    //3>当天课表的字典
    NSMutableDictionary *daySyllabus = [NSMutableDictionary dictionary];
    //4>初始化二维数组
    for (int week = 1; week <= 21 ; week++) {
        
        daysSyllabus = [NSMutableArray array];
        
        for (int day = 1; day <= 7 ; day++) {
            
            daySyllabus = [NSMutableDictionary dictionary];
            [daysSyllabus addObject:daySyllabus];
        }
        [weeksSyllabus addObject:daysSyllabus];
    }
    
    //遍历 网络请求 返回的字典数组(allCourseInfoWithDictArr) 中的每个字典取出需要的信息进行保存，保存到二维数组中
    for (NSDictionary *timetable in dictArr) {
        //遍历字典中以week为关键字的数组
        for (NSNumber *week in timetable[@"week"]) {
            //这个只是把OC中Numer对象转换成一个整形值，整形值才能作为二维数组的下标
            int weekInt = [week intValue];
            //得到name的整形值,不再使用name,改成day和period
            // int dayAndTime = [timetable[@"name"] intValue];
            //得到星期几
            int day = [timetable[@"day"] intValue];
            //得到第几节课，这样那个麻烦的转换也是因为OC的限制，因为OC中字典的关键字只能是对象
            NSNumber *time = [NSNumber numberWithInt:[timetable[@"period"] intValue]];
            
            //初始化一个字典，保存第几节课的课程信息，比如第一节课的信息
            NSMutableDictionary *timeCourseInfo = [NSMutableDictionary dictionary];
            [timeCourseInfo setObject:timetable[@"classroom"] forKey:@"classroom"];
            [timeCourseInfo setObject:timetable[@"mark"] forKey:@"mark"];
            [timeCourseInfo setObject:timetable[@"course"] forKey:@"course"];
            [timeCourseInfo setObject:time forKey:@"orderLesson"];
            NSString *timeString = [NSString string];
            NSDate *date = [NSDate date];
            
            NSInteger mouth = date.month;
            
            if (mouth >= 5 && mouth < 10) {
                
                switch ([time integerValue]) {
                    case 0:
                        timeString = @"8:00";
                        break;
                    case 1:
                        timeString = @"10:00";
                        break;
                    case 2:
                        timeString = @"14:00";
                        break;
                    case 3:
                        timeString = @"16:00";
                        break;
                    case 4:
                        timeString = @"19:00";
                        break;
                        
                    default:
                        break;
                }
            } else {
                switch ([time integerValue]) {
                        
                    case 0:
                        timeString = @"8:00";
                        break;
                    case 1:
                        timeString = @"10:00";
                        break;
                    case 2:
                        timeString = @"13:30";
                        break;
                    case 3:
                        timeString = @"15:30";
                        break;
                    case 4:
                        timeString = @"18:00";
                        break;
                        
                    default:
                        break;
                }
                
            }
            [timeCourseInfo setObject:timeString forKey:@"timeOfLesson"];
            
            //给二维数组中的  第几节课的字典  赋值
            [weeksSyllabus[weekInt][day] setObject:timeCourseInfo forKey:time];
        }
        
    }
    
    // 测试
    //        for (int i = 1; i <= 20; i++) {
    //            NSLog(@"%@",weeksSyllabus[i]);
    //        }
    //        NSDictionary *day = weeksSyllabus[14][1];
    //        NSLog(@"%@",day);
    //        NSLog(@"%@",[day objectForKey:@2]);
    //        NSDictionary *classs = [day objectForKey:@2];
    //        NSLog(@"%@",classs[@"mark"]);
    
    return weeksSyllabus;
}




@end
