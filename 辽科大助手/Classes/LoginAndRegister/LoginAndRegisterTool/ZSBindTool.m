//
//  ZSBindTool.m
//  辽科大助手
//
//  Created by DongAn on 16/2/11.
//  Copyright © 2016年 DongAn. All rights reserved.
//

#import "ZSBindTool.h"

#import "ZSBindParam.h"

#import "ZSAccountTool.h"
#import "ZSAccount.h"

#import "ZSHttpTool.h"

#import "MJExtension.h"

#import "NSDate+Utilities.h"

@implementation ZSBindTool
+ (void)bindWithUser:(NSString *)nickname key:(NSString *)key zjh:(NSString *)zjh Andmm:(NSString *)mm success:(void(^)(NSInteger code))success failure:(void(^)(NSError *error))failure
{
    
    ZSBindParam *params = [[ZSBindParam alloc] init];
    params.nickname = nickname;
    params.key =key;
    params.zjh = zjh;
    params.mm = mm;
    
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/Bind" parameters:params.keyValues success:^(id responseObject) {
        
//warning 新接口课表不再是以字符串返回，而是字典数组，下面这个方法用不上了
        //        //字符串转字典数组
        //        NSArray *dictArr = [NSString stringTimeTableConvertToDictArray:responseObject[@"timetable"]];
        
        NSMutableDictionary *accountDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//warning 新接口返回的课表中的周，还是以字符串形式返回的，还是得重新处理，烦人

        
        ZSLog(@"%@", responseObject[@"state"]);
        
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
        
        //字典转模型
        ZSAccount *account = [ZSAccount objectWithKeyValues:accountDict];
        
        if (success) {
            
            success(account.state);
            
            if (account.state == 100) {
                
                
                account.nickname = nickname;
                account.key = key;
                
//                ZSLog(@"%@", key);
                //保存账户信息
                [ZSAccountTool saveAccount:account];
                
                //单独保存账号和密码，key，用用户偏好设置
//                [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:ZSUser];
//                [[NSUserDefaults standardUserDefaults] setObject:key forKey:ZSKey];
//                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"zjh"] forKey:ZSZjh];
//                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"mm"] forKey:ZSMm];
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"sex"] forKey:ZSSex];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } 
        }
        
        
    } failure:^(NSError *error) {
        
        
        
        if (failure) {
            
            [ZSAccountTool saveAccount:nil];
            failure(error);
        }
        
    }];
    
}

+ (NSArray *)timetableDictArrConvertToPlanarArr:(NSArray *)dictArr
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
