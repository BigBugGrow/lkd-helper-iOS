//
//  ZSCourseViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/26.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSCourseViewController.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"

#import "NSDate+Utilities.h"


@interface ZSCourseViewController ()
/** 加号按钮*/
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

/** 当前天号*/
@property (nonatomic, assign) NSInteger currentDay;

/** 当前月份*/
@property (nonatomic, assign) NSInteger month;

/** 当前日期*/
@property (nonatomic, strong) NSDate *date;

- (IBAction)clcikPlusBtn;
- (IBAction)clickNextCourseBtn;
- (IBAction)clickLastCourseBtn;


/** 背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *backGroudImageView;

/** 下个月*/
@property (nonatomic, assign) NSInteger nextMouth;

/** 上个月*/
@property (nonatomic, assign) NSInteger lastMouth;

/** 标题*/
@property (nonatomic, weak) UIButton *titleBtn;

/** 当前周*/
@property (nonatomic, assign) NSInteger currentWeek;

/** 第几月*/
@property (nonatomic, weak) UILabel *currentMouth;

/** 日期时间背景*/
@property (nonatomic, weak) UIView *dateBackView;

@end

@implementation ZSCourseViewController


//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/** 获取月结束的时的天数*/
- (NSInteger)getCriticalDayWith:(BOOL)flag
{
    
    //初始化课表数据
    //1.计算当前是第几周，星期几
    NSDate *currentDay = [NSDate date];
    
    
    NSInteger year = currentDay.year;
    NSInteger mouth = flag ? self.month - 1 : self.month;
    
    //临界天
    NSInteger criticalDay = (year % 4 == 0 && year % 100 != 0) || (year % 100 == 0) ? 29 : 28;
    
    if (mouth != 2) {
        
        if (mouth == 4 || mouth == 6 || mouth == 9 || mouth == 11) {
            
            return 30;
        } else {
            
            return 31;
            
        }
    }
    return criticalDay;
}


- (void)initNav
{

    // 标题
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.frame = CGRectMake(0, 0, 150, 30);
    self.navigationItem.titleView = titleButton;
    self.titleBtn = titleButton;
    //下面加好按钮
    self.plusBtn.backgroundColor = RGBColor(3, 169, 244, 1);
    
}

/** 获取时间数组*/
- (NSArray *)getTimeArrayWithDay:(NSInteger)day month:(NSInteger)month
{
    NSDate *currentDay = [NSDate date];

    NSInteger weekDay = currentDay.weekday;
//    NSInteger day = currentDay.day;
    NSMutableArray *days = [NSMutableArray array];
    NSMutableArray *agoDays = [NSMutableArray array];
    
    NSInteger currentStaticDay = 0;
    for (int i = 1; i <= 7; i ++) {
        
        if (i < weekDay) {
            
            NSInteger d = day - i;
            
            NSInteger criticalDay = [self getCriticalDayWith:YES];
            
            if (d <= 0) {
                
                self.lastMouth = month - 1;
                NSInteger dd = d + criticalDay;
                [agoDays addObject:@(dd)];
                
            } else {
                
                [agoDays addObject:@(d)];
            }
            
        }else if (i > weekDay) {
            
            NSInteger d = day + i - weekDay;
            
            //获得边界天
            NSInteger criticalDay = [self getCriticalDayWith:NO];
            
            if (d > criticalDay) {
                
                self.nextMouth = month + 1;
                currentStaticDay ++;
                [days addObject:@(currentStaticDay)];
                
            }else{
                
                [days addObject:@(d)];
            }
            
        } else {
            [days addObject:@(day)];
        }
        
    }
    
    NSInteger agoCount = agoDays.count;
    for (int i = 0; i < agoCount / 2; i ++) {
        
        NSNumber *temp = agoDays[i];
        agoDays[i] = agoDays[agoCount - i - 1];
        agoDays[agoCount - i - 1] = temp;
        
    }
    
    NSRange range = NSMakeRange(0, agoDays.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    //将新的数据添加到大数组的最前面
    [days insertObjects:agoDays atIndexes:indexSet];
    
    return days;
    
}

/** 初始化时间日期控件*/
- (void)initTimeDateLabel
{
    
    UIView *dateBackView = [[UIView alloc] init];
    dateBackView.frame = CGRectMake(0, 0, ZSScreenW, 40);
    [self.view addSubview:dateBackView];
    self.dateBackView = dateBackView;
    
    NSInteger labelCount = 8;
    CGFloat labelWidth = ZSScreenW / 8;
    CGFloat labelHeight = 20;
    
    
    for (int i = 0; i < 2; i ++) {
        
        for (int j = 1; j < labelCount; j ++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.width = labelWidth;
            label.height = labelHeight;
            label.x = labelWidth * j;
            label.y = label.height * i;
            
            label.textColor = RGBColor(3, 169, 244, 1.0);
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [dateBackView addSubview:label];
            
            
            if (i == 1) {
                
                switch (j) {
                    case 1:
                        label.text = @"周一";
                        break;
                    case 2:
                        label.text = @"周二";
                        break;
                    case 3:
                        label.text = @"周三";
                        break;
                    case 4:
                        label.text = @"周四";
                        break;
                    case 5:
                        label.text = @"周五";
                        break;
                    case 6:
                        label.text = @"周六";
                        break;
                    case 7:
                        label.text = @"周日";
                        break;
                        
                    default:
                        break;
                }
            }
            
            
        }
    }
    
}


/** 初始化所有的label*/
- (void)initLabelWithDay:(NSInteger)day month:(NSInteger)month
{
    
    //获取时间数组
    NSArray *days = [self getTimeArrayWithDay:day month:month];
    NSInteger labelCount = 7;

    
    //1.计算当前是第几周，星期几
    NSDate *currentDay = [NSDate date];

    for (int i = 0; i < 2; i ++) {
        
        for (int j = 0; j < labelCount; j ++) {

    
            if (i == 1) {
                continue;
            }
            
            UILabel *label = self.dateBackView.subviews[j];
            
            if (j == currentDay.weekday - 1) {
                
//                label.backgroundColor = RGBColor(255, 0, 0, 0.5);
                label.textColor = RGBColor(255, 0, 0, 1);
            } else {
                label.textColor = RGBColor(3, 169, 244, 1.0);
//                label.backgroundColor = [UIColor whiteColor];
            }
            
            NSInteger currentD = [days[j] integerValue];
            
            NSInteger lastDay = 0;
            
            if (j - 1 >= 0) {
                 lastDay = [days[j - 1] integerValue];
            }
            
            if (lastDay == [self getCriticalDayWith:NO]) {
                
                NSInteger currentMouth = self.lastMouth ? self.lastMouth : self.nextMouth;
                label.text = [NSString stringWithFormat:@"%ld月", currentMouth];
                
                if (self.lastMouth) {
                    
                    self.currentMouth.text = [NSString stringWithFormat:@"%ld", self.lastMouth];
                    label.text = [NSString stringWithFormat:@"%ld月", currentMouth + 1];
                    
                } else {
                    
                    self.currentMouth.text = [NSString stringWithFormat:@"%ld", month];
                }
                
                
            } else {
                label.text = [NSString stringWithFormat:@"%ld", currentD];
            }
            
            
        }
        
        
        self.lastMouth = 0;
        self.nextMouth = 0;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.plusBtn.userInteractionEnabled = NO;
    
    
    NSDate *date = [NSDate date];
    
    self.currentWeek = 4;
    self.month = date.month;
    self.currentDay = date.day;
    
//    self.date = date;
    
    //设置标题
    [self initNav];
    
    //初始化第几节课
    [self initCourseTime];
    
    //添加日期星期按钮
    [self initTimeDateLabel];
    
    
    //设置星期， 月
    [self initLabelWithDay:self.currentDay month:self.month];
    

    //设置课表
    [self initCourseWithCurrentWeek:self.currentWeek];
    
    [self settingTitleWithWeek:self.currentWeek];
}

/** 初始化课程时间*/
- (void)initCourseTime
{
    
    
    UILabel *mouthLabel = [[UILabel alloc] init];
    mouthLabel.frame = CGRectMake(0, 0, ZSScreenW / 8, 40);
    mouthLabel.textColor = [UIColor redColor];
    mouthLabel.font = [UIFont systemFontOfSize:15];
    mouthLabel.backgroundColor = [UIColor whiteColor];
    mouthLabel.textAlignment = NSTextAlignmentCenter;
    self.currentMouth = mouthLabel;
    [self.view addSubview:mouthLabel];
    
    NSArray *courseArray = @[@"第一节", @"第二节", @"第三节", @"第四节", @"第五节"];
    
    for (int i = 0; i < 5; i ++) {
        
        UILabel *courseLabel = [[UILabel alloc] init];
        CGFloat mLabelWidth = ZSScreenW / 8;
        CGFloat mLabelHeight = 80;
        CGFloat mLabelY = i * mLabelHeight + 40;
        
        courseLabel.frame = CGRectMake(0, mLabelY, mLabelWidth, mLabelHeight);
        courseLabel.textColor = RGBColor(3, 169, 244, 1.0);
        courseLabel.font = [UIFont systemFontOfSize:11];
        courseLabel.backgroundColor = [UIColor clearColor];
        courseLabel.textAlignment = NSTextAlignmentCenter;
        courseLabel.text = courseArray[i];
        [self.view addSubview:courseLabel];
        
    }
    
}


/** 设置标题*/
- (void)settingTitleWithWeek:(NSInteger)week
{
    
    NSString *titleStr = [NSString stringWithFormat:@"第%ld/20周", week];
    [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
    self.currentMouth.text = [NSString stringWithFormat:@"%ld月", self.month];
    
}


- (void)initCourseWithCurrentWeek:(NSInteger)currentWeek
{
    
    for (UILabel *label in self.backGroudImageView.subviews) {
        
        [label removeFromSuperview];
    }
    
    ZSAccount *account = [ZSAccountTool account];
    
    for (int i = 0; i < 7; i ++) {
        
        for (int j = 0; j < 5; j ++) {
            
            
            NSArray *dayCourseArray = account.timetable[currentWeek][i];
            if (dayCourseArray.count) {
                
                NSDictionary *dayCourseDict = (NSDictionary *)dayCourseArray;
                
                NSNumber *num = @(j);
                
                CGFloat margin = 2;
                
                UILabel *courseLabel = [[UILabel alloc] init];
                
                
                courseLabel.width = ZSScreenW / 8 - 2 * margin;
                courseLabel.height = 80 - 2 * margin;
                courseLabel.x = i * (ZSScreenW / 8) + margin;
                courseLabel.y = j * (courseLabel.height + margin) + margin;
                
                NSDictionary *c = dayCourseDict[num];
                
                NSString *courseString = [NSString stringWithFormat:@"%@ #%@", c[@"course"], c[@"classroom"]];
                
                courseLabel.text = c[@"course"] ? courseString : @"无";
                
                if ([courseLabel.text isEqualToString:@"无"]) {
                    courseLabel.hidden = YES;
                } else {
                    courseLabel.hidden = NO;
                }
                
                //                courseLabel.text = @"市场上的v";
                courseLabel.numberOfLines = 0;
                courseLabel.font = [UIFont systemFontOfSize:10];
                courseLabel.textAlignment = NSTextAlignmentCenter;
                courseLabel.textColor = [UIColor whiteColor];
                courseLabel.backgroundColor = RGBColor(100, 100, 100, 0.5);
                [self.backGroudImageView addSubview:courseLabel];
                
            }
        }
    }
}


- (void)changeTitleWithWeek:(NSInteger)week
{
    NSString *weekStr = [NSString stringWithFormat:@"第%ld周", week];
    [self.titleBtn setTitle:weekStr forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clcikPlusBtn {
    
    
}

- (IBAction)clickNextCourseBtn {
    
    self.currentWeek ++;
    if (self.currentWeek > 20) {
        
        self.currentWeek --;
        return;
    }
    
    self.currentDay += 7;
    
    NSInteger criticalDay = [self getCriticalDayWith:NO];
    
    if (self.currentDay > criticalDay) {
        
        self.currentDay = self.currentDay - criticalDay;
        self.month += 1;
    }
    
    [self initLabelWithDay:self.currentDay month:self.month];
    
    [self settingTitleWithWeek:self.currentWeek];
    [self initCourseWithCurrentWeek:self.currentWeek];
}

- (IBAction)clickLastCourseBtn {
    
    
    self.currentWeek --;
    if (self.currentWeek <= 0) {
        
        self.currentWeek ++;
        return;
        
    }
    
    self.currentDay -= 7;
    
    NSInteger criticalDay = [self getCriticalDayWith:YES];
    
    if (self.currentDay <= 0) {
        
        self.currentDay = self.currentDay + criticalDay;
        self.month -= 1;
    }
    
    [self initLabelWithDay:self.currentDay month:self.month];
    
    
    
    [self settingTitleWithWeek:self.currentWeek];
    [self initCourseWithCurrentWeek:self.currentWeek];

}
@end
