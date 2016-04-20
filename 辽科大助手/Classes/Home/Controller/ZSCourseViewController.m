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
//#import <AudioToolbox/AudioToolbox.h>
#import "NSDate+Utilities.h"
#import <AVFoundation/AVFoundation.h>
#import "ZSAudioTool.h"
#import "QRadioButton.h"
#import "SSCheckBoxView.h"
#import "ZSCourse.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+Extension.h"
#import "ZSCourseRightView.h"
#import "ZSRightButton.h"
#import "ZSDropDownMenu.h"
#import "ZSCourseMenuViewController.h"

#define ZSBackGroudImage @"timeTableBackGroudImage"

#define CHTopPadingY 100
#define CHRight 250
#define CHLeft -250

@interface ZSCourseViewController ()<QRadioButtonDelegate, UITextFieldDelegate,ZSDropDownMenuDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 加号按钮*/
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

/** 当前天号*/
@property (nonatomic, assign) NSInteger currentDay;

/** 当前月份*/
@property (nonatomic, assign) NSInteger month;

/** 蒙板*/
@property (nonatomic, weak) UIView *cover;

/** 课程信息背景*/
@property (nonatomic, weak) UIView *courseBgView;

/** 滚动条的背景*/
@property (nonatomic, weak) UIView *allView;

/** 选择周几的背景*/
@property (nonatomic, weak) UIView *weekDayView;


/** 选择周几的背景*/
@property (nonatomic, weak) UIView *weekBgView;


/** 选择当天第几节的背景*/
@property (nonatomic, weak) UIView *courseDayView;

/** 添加课程名*/
@property (nonatomic, weak) UITextField *courseName;

/** 添加上课地点*/
@property (nonatomic, weak) UITextField *coursePlace;

/** 当前日期*/
@property (nonatomic, strong) NSDate *date;

/** course*/
@property (nonatomic, strong) ZSCourse *course;

/**下一步btn*/
@property (nonatomic, weak) UIButton *nextBtn;

/**取消btn*/
@property (nonatomic, weak) UIButton *cancelBtn;


/**menu*/
@property (nonatomic, strong) ZSDropDownMenu *menu;

//侧栏
@property(nonatomic,weak)UIView *rightView;
@property(nonatomic,assign)BOOL draging;

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

/**account*/
@property (nonatomic, strong) ZSAccount *account;


@end

@implementation ZSCourseViewController

/** 懒加载*/
- (ZSCourse *)course
{
    if (_course == nil) {
        _course = [[ZSCourse alloc] init];
    }
    return _course;
}

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - 计算月份有多少天数

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

#pragma mark - 初始化navigation

- (void)initNav
{

    // 标题
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.frame = CGRectMake(0, 0, 120, 30);
    self.navigationItem.titleView = titleButton;
    self.titleBtn = titleButton;
    //下面加好按钮
    self.plusBtn.backgroundColor = RGBColor(3, 169, 244, 1);
    
    //设置标题按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    rightBtn.width = 55;
    rightBtn.height = 30;
    rightBtn.x = 0;
    rightBtn.y = 0;
    
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];;
    
    
    [ZSNotificationCenter addObserver:self selector:@selector(changeBgImage) name:@"changeBgImage" object:nil];

    
    [ZSNotificationCenter addObserver:self selector:@selector(initTimeTable) name:@"initTimetable" object:nil];

    
    [ZSNotificationCenter addObserver:self selector:@selector(changeBgDefaultImage) name:@"changeBgDefaultImage" object:nil];

    
    [ZSNotificationCenter addObserver:self selector:@selector(clickPlusBtn) name:@"addCourse" object:nil];

    //如果本地存在背景图片， 就用本地背景图片
    if ([self LocalHaveImage:ZSBackGroudImage]) {
        
        self.backGroudImageView.image = [self GetImageFromLocal:ZSBackGroudImage];
    }
    
}


#pragma mark - 通知方法

- (void)changeBgDefaultImage
{
    [self.menu dismiss];
    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
    UIImage *defaultImage = [UIImage imageNamed:@"back"];
    self.backGroudImageView.image = defaultImage;
    [self SaveImageToLocal:defaultImage Keys:ZSBackGroudImage];
}

- (void)initTimeTable
{
    
    [self.menu dismiss];
    
    [SVProgressHUD showSuccessWithStatus:@"初始化成功"];
    //设置课表
    [self initCourseWithCurrentWeek:self.currentWeek];
}

- (void)changeBgImage
{
    [self.menu dismiss];
    [self openAlbum];
}

#pragma mark - 代开相册

- (void)openAlbum
{
    //    UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //获得所有图片
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)ImagePickerControllerSourceType
{
    //若相机在没摔坏 没故障的情况下，就打开相机
    if (![UIImagePickerController isSourceTypeAvailable:ImagePickerControllerSourceType]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = ImagePickerControllerSourceType;
    //监听她的图片
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
/**
 *  从UIImagePickerControllerDelegate选择图片后就调用（拍完照完毕或者选择相册图片完毕）
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //拿出info中包含选择的图片
    UIImage *picture = info[UIImagePickerControllerOriginalImage];
    
    [self SaveImageToLocal:picture Keys:ZSBackGroudImage];
    
    self.backGroudImageView.image = picture;
    
    [SVProgressHUD showSuccessWithStatus:@"修改背景成功"];
}

#pragma mark - 保存图片

//将图片保存到本地
- (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//本地是否有相关图片
- (BOOL)LocalHaveImage:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
- (UIImage*)GetImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        ZSLog(@"未从本地获得图片");
    }
    return image;
}



#pragma mark - 点击右边按钮

//点击标题按钮
- (void)clickTitleBtn:(UIButton *)titleBtn
{
    //1.创建菜单
    ZSDropDownMenu *menu = [ZSDropDownMenu menu];
    
    self.menu = menu;
    //4.设置代理
    menu.delegate = self;
    
    ZSCourseMenuViewController *menuVc = [[ZSCourseMenuViewController alloc] init];
    
    //设置高度
    menuVc.view.height = 220;
    menuVc.view.width = 150;
    //2.添加内容
    menu.contentViewController = menuVc;
    //3.显示菜单
    [menu show:titleBtn];
    
}

#pragma mark - LNDropDownMenuDelegate代理方法
- (void)dropDownMenuDidDismiss:(ZSDropDownMenu *)menu
{
    //获取UINavogation
    UIButton *titleBtn = (UIButton *)self.navigationItem.rightBarButtonItem;
    
    //4.换标题按钮图片
    //    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    titleBtn.selected = NO;
}

- (void)dropDownMenuDidShow:(ZSDropDownMenu *)menu
{
    //获取UINavogation
    UIButton *titleBtn = (UIButton *)self.navigationItem.rightBarButtonItem;
    
    //4.换标题按钮图片
    //    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    titleBtn.selected = YES;
}



#pragma mark - 获取时间数组

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


#pragma mark - 格式化时间

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



- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSDate *date = [NSDate date];
    
    ZSAccount *account = [ZSAccountTool account];
    self.account = account;
    
    //开学日期
    NSInteger count = [self getUTCFormateDate:account.termBeginTime];
    
    self.currentWeek = count / 7 + 1;
    self.month = date.month;
    self.currentDay = date.day;
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.menu dismiss];
}

#pragma mark - 初始化课表

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
    
    
    for (int i = 0; i < 7; i ++) {
        
        for (int j = 0; j < 5; j ++) {
            
            
            NSArray *dayCourseArray = self.account.timetable[currentWeek][i];

            
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

#pragma mark - 点击添加课程

- (IBAction)clickPlusBtn {
    
    //除去菜单
    [self.menu dismiss];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = RGBColor(123, 123, 123, 0.7);
    cover.frame = window.bounds;
    [window addSubview:cover];
    
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyBoard)]];
    
    self.cover = cover;
    

    CGFloat marginW = 20;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(marginW, 120, ZSScreenW - 2 * marginW, 330);
    view.backgroundColor = [UIColor whiteColor];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyBoard)]];
    
    [window addSubview:view];
    self.courseBgView = view;
    

    UILabel *courseLabel = [[UILabel alloc] init];
    courseLabel.frame = CGRectMake(marginW, 10, ZSScreenW - 4 * marginW, 30);
    courseLabel.text = @"请输入课程信息:";
    [view addSubview:courseLabel];
    
    UITextField *courseName = [[UITextField alloc] init];
    courseName.delegate = self;
    courseName.placeholder = @"课程名";
    courseName.x = courseLabel.x;
    courseName.y = CGRectGetMaxY(courseLabel.frame) + 20;
    courseName.width = courseLabel.width;
    courseName.height = courseLabel.height;
    [view addSubview:courseName];
    self.courseName = courseName;
    
    
    UITextField *coursePlace = [[UITextField alloc] init];
    coursePlace.delegate = self;
    coursePlace.placeholder = @"上课地点";
    coursePlace.x = courseLabel.x;
    coursePlace.y = CGRectGetMaxY(courseName.frame) + 2 * marginW;
    coursePlace.width = courseLabel.width;
    coursePlace.height = courseLabel.height;
    [view addSubview:coursePlace];
    self.coursePlace = coursePlace;
    
    QRadioButton *radio1 = [[QRadioButton alloc]initWithDelegate:self groupId:@"remaind"];
    
    radio1.width = 50;
    radio1.height = 30;
    radio1.x = view.width - 4 * marginW - radio1.width;
    radio1.y = CGRectGetMaxY(coursePlace.frame) + 10;
    
    [radio1 setTitle:@"必修" forState:UIControlStateNormal];
    [radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [view addSubview:radio1];
    [radio1 setChecked:YES];
    
    QRadioButton *radio2 = [[QRadioButton alloc]initWithDelegate:self groupId:@"remaind"];
    radio2.width = 50;
    radio2.height = 30;
    radio2.x = view.width - marginW - radio2.width;
    radio2.y = CGRectGetMaxY(coursePlace.frame) + 10;
    
    [radio2 setTitle:@"选修" forState:UIControlStateNormal];
    [radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [view addSubview:radio2];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.width = 50;
    cancelBtn.height = 30;
    cancelBtn.x = view.width - cancelBtn.width - 5 * marginW;
    cancelBtn.y = CGRectGetMaxY(radio1.frame) + 2 * marginW;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:RGBColor(13, 148, 252, 1) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [view addSubview:cancelBtn];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.width = 60;
    nextBtn.height = 30;
    nextBtn.x = view.width - nextBtn.width - marginW;
    nextBtn.y = CGRectGetMaxY(radio1.frame) + 2 * marginW;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextBtn setTitleColor:RGBColor(13, 148, 252, 1) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [nextBtn addTarget:self action:@selector(clickSelectWeekDay) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    [view addSubview:nextBtn];
    
    // 1.addTarget
    [self.courseName addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.coursePlace addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //添加监听
    [self textChange];
    
}


- (void)textChange
{
    // 判断两个文本框的内容
    self.nextBtn.enabled =  self.courseName.text.length && self.coursePlace.text.length;
}

- (void)clickCancelBtn
{
    [self.allView removeFromSuperview];
    [self.cover removeFromSuperview];
    [self.courseBgView removeFromSuperview];
}


- (void)clickNextBtn:(UIButton *)btn
{

    
    [self.courseDayView removeFromSuperview];
    [self.courseBgView removeFromSuperview];
    
    self.course.courseNum = btn.tag;
    
    //    [cbv setStateChangedTarget:self
    //                      selector:@selector(checkBoxViewChangedState:)];
    
//    [cbv setStateChangedBlock:^(SSCheckBoxView *v) {
//        [self checkBoxViewChangedState:v];
//    }];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    /** 滚动条的背景*/
    UIView *allView = [[UIView alloc] init];
    allView.width = ZSScreenW - 40;
    allView.height = ZSScreenH - 40;
    allView.x = 20;
    allView.y = 20;
    [window addSubview:allView];
    self.allView = allView;
    
    UIScrollView *weekBgView = [[UIScrollView alloc] init];
    weekBgView.frame = CGRectMake(0, 30, ZSScreenW - 40, ZSScreenH - 100);

//    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:10];
    
    SSCheckBoxView *cbv = nil;
    CGRect frame = CGRectMake(30, 0, ZSScreenW - 40, 30);
    for (int i = 0; i < 20; ++i) {
        SSCheckBoxViewStyle style = 2;
        
        
        cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                              style:style
                                            checked:NO];
        cbv.tag = i;
        [cbv setText:[NSString stringWithFormat:@"第%02d周", (i + 1)]];
        [weekBgView addSubview:cbv];
        
        frame.origin.y += 36;
    }
    
//    frame.origin.y += 24;
//    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
//                                          style:kSSCheckBoxViewStyleGlossy
//                                        checked:NO];
//    [cbv setText:@"Enable All"];
    
    weekBgView.contentSize = CGSizeMake(ZSScreenW - 40, 36 * 20);
    
    [weekBgView addSubview:cbv];

    weekBgView.backgroundColor = [UIColor whiteColor];
    
    /** titleLabel*/
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.width = ZSScreenW - 70;
    titleLabel.height = 30;
    titleLabel.x = 30;
    titleLabel.y = 0;
    titleLabel.text = @"第几周添加课程";
    [allView addSubview:titleLabel];

    /** titleLabel*/
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.width = 80;
    nextBtn.height = 30;
    
    nextBtn.x = CGRectGetMaxX(weekBgView.frame) - nextBtn.width - 10;
    nextBtn.y = CGRectGetMaxY(allView.frame) - nextBtn.height - 20;
    [nextBtn setTitle:@"完成添加" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(clickOKBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [allView addSubview:nextBtn];
    
    
    /** 取消添加*/
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.width = 80;
    cancelBtn.height = 30;
    
    cancelBtn.x = CGRectGetMaxX(weekBgView.frame) - cancelBtn.width - 20 - nextBtn.width;
    cancelBtn.y = CGRectGetMaxY(allView.frame) - cancelBtn.height - 20;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [allView addSubview:cancelBtn];
    
    
    allView.backgroundColor = [UIColor whiteColor];
    [allView addSubview:weekBgView];
    self.weekBgView = weekBgView;
    
}

- (void)clickOKBtn
{
    
    [self clickCancelBtn];
    
    [SVProgressHUD showSuccessWithStatus:@"成功添加新课程"];
    
    NSMutableArray *courseArr = [NSMutableArray array];
    
    for (SSCheckBoxView *checkBoxView in self.weekBgView.subviews) {
        
        if ([checkBoxView isKindOfClass:[SSCheckBoxView class]]) {
            
            if (checkBoxView.checked) {
                
                [courseArr addObject:@(checkBoxView.tag + 1)];
            }
            
        }
    }
    self.course.weekCourses = courseArr;

    
    NSArray *timeTable = self.account.timetable;
    
    ZSCourse *course = self.course;
    
    NSInteger count = self.course.weekCourses.count;
    
    NSMutableDictionary *dictCourse = [NSMutableDictionary dictionary];
    
    dictCourse[@"classroom"] = course.coursePlace;
    dictCourse[@"course"] = course.courseName;
    dictCourse[@"orderLesson"] = @(course.courseNum);
    
    for (int i = 0; i < count; i ++) {
        
        int k = [course.weekCourses[i] intValue];
        NSInteger j = course.weekCourse + 1;
        
        NSArray *arr = timeTable[k];
        
        NSMutableDictionary *dictM = arr[j];
        
        dictM[@(course.weekCourse)] = dictCourse;
    }
    
    //保存新课表
    [ZSAccountTool saveAccountTimeTable:timeTable];
    self.account = [ZSAccountTool account];
    //设置课表
    [self initCourseWithCurrentWeek:self.currentWeek];
    
}

- (void)clickSelectWeekDay
{
   [self.courseBgView removeFromSuperview];
    [self.courseName endEditing:YES];
    [self.coursePlace endEditing:YES];

    
    self.course.courseName = self.courseName.text;
    self.course.coursePlace = self.coursePlace.text;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *weekDayView = [[UIView alloc] init];
    weekDayView.backgroundColor = [UIColor whiteColor];
    weekDayView.width = ZSScreenW - 40;
    weekDayView.height = ZSScreenH - 150;
    weekDayView.x = 20;
    weekDayView.y = 80;
    [window addSubview:weekDayView];
    
    self.weekDayView = weekDayView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(40, 5, ZSScreenW - 80, 30);
    titleLabel.text = @"   请选择上课周";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [weekDayView addSubview:titleLabel];
    
    NSArray *arr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    
    for (int i = 0; i < 7; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = weekDayView.width;
        btn.height = 45;
        btn.x = 0;
        btn.y = i * (btn.height + 10) + 40;
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(clickCourse:) forControlEvents:UIControlEventTouchUpInside];
        
        [weekDayView addSubview:btn];
    }
    
}

- (void)clickCourse:(UIButton *)btn
{
    
    [self.weekDayView removeFromSuperview];
    
    self.course.weekCourse = btn.tag;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *courseDayView = [[UIView alloc] init];
    courseDayView.backgroundColor = [UIColor whiteColor];
    courseDayView.width = ZSScreenW - 40;
    courseDayView.height = ZSScreenH - 200;
    courseDayView.x = 20;
    courseDayView.y = 100;
    [window addSubview:courseDayView];
    
    self.courseDayView = courseDayView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(40, 5, ZSScreenW - 80, 30);
    titleLabel.text = @"请选择上课节次";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [courseDayView addSubview:titleLabel];
    
    NSArray *arr = @[@"第一大节", @"第二大节", @"第三大节", @"第四大节", @"第五大节"];
    
    for (int i = 0; i < 5; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = courseDayView.width;
        btn.height = 45;
        btn.x = 0;
        btn.y = i * (btn.height + 10) + 40;
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [courseDayView addSubview:btn];
    }
    
}


/**
 *  点击单选按钮
 */

-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"必修"]) {
        
        ZSLog(@"必修");
        self.course.neccesaryCourse = @"必修";
    }
    if ([radio.titleLabel.text isEqualToString:@"选修"]) {
        NSLog(@"选修");
        self.course.neccesaryCourse = @"选修";
    }
    
}


#pragma mark - 点击上周下周课表

- (IBAction)clickNextCourseBtn {
    
    //播放音效
    [ZSAudioTool playAudioWithFilename:@"sonar_pop.aif"];

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
    
    
    //播放音效
    [ZSAudioTool playAudioWithFilename:@"sonar_pop.aif"];

//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
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

#pragma mark - 退出键盘

- (void)exitKeyBoard
{
    [self.courseName endEditing:YES];
    [self.coursePlace endEditing:YES];
}

#pragma mark - UItextFildDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    ZSLog(@"wwww");
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.courseBgView.y -= 100;
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
       
        self.courseBgView.y += 100;
    }];
    
}

@end
