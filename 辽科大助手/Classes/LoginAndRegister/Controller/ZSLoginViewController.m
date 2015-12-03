//
//  ZSLoginViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSLoginViewController.h"
#import "ZSTabBarController.h"
#import "ZSHttpTool.h"
#import "ZSAccount.h"
#import "ZSTimeTable.h"
#import "ZSAccountTool.h"

#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+ReplaceUnicode.h"

#define ZSUser @"user"
#define ZSPassword @"password"

@interface ZSLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property  (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ZSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"辽科大助手登录";
    self.activityIndicator.hidden = YES;
    self.userNameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser];
    self.passwordText.text = [[NSUserDefaults standardUserDefaults] objectForKey:ZSPassword];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(UIButton *)sender
{
    NSString *userName = self.userNameText.text;
    NSString *pwd = self.passwordText.text;
    //保存账号和密码
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:ZSUser];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:ZSPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ZSUser] = userName;
    params[ZSPassword] = pwd;
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=site/login" parameters:params success:^(id responseObject) {
        
        
        NSArray *dictArr = [self stringTimeTableConvertToDictArray:responseObject[@"timetable"]];
        
        NSMutableDictionary *accountDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
       

         accountDict[@"timetable"] = dictArr;
        //字典转模型

        ZSAccount *account = [ZSAccount objectWithKeyValues:accountDict];

        if (account.code != 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
      
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showError:@"登录失败,账户或密码错误"];
                
            });
        } else {
            [ZSAccountTool saveAccount:account];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showSuccess:@"登录成功"];
            });
            
            ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
            
            ZSKeyWindow.rootViewController = tabBarVC;
        }
        
    } failure:^(NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [MBProgressHUD showError:@"网络错误"];
    }];
}
- (IBAction)registerButtonClicked:(id)sender
{
    
}

- (NSArray *)stringTimeTableConvertToDictArray:(NSString *)stringTimeTable
{
    NSMutableArray *dictArr = [NSMutableArray array];
    
  //  NSLog(@"%@",stringTimeTable);
    
    NSArray *dictStringArr = [stringTimeTable componentsSeparatedByString:@"},"];
    for (NSString *dictStr in dictStringArr) {
        
       // NSLog(@"%@\n",dictStr);
        NSArray *keyValueStrArr = [dictStr componentsSeparatedByString:@"\","];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *keyValueStr in keyValueStrArr) {
            
          //  NSLog(@"%@\n",keyValueStr);
            
            if ([keyValueStr containsString:@"name"]) {
                NSRange nameRange = [keyValueStr rangeOfString:@"name"];
                NSString *nameKey = [keyValueStr substringWithRange:nameRange];
                NSString *nameValue = [keyValueStr substringFromIndex:nameRange.location + nameRange.length + 3];
                dict[nameKey] = nameValue;
            }
            if ([keyValueStr containsString:@"week"]) {
                NSRange weekRange = [keyValueStr rangeOfString:@"week"];
                NSString *weekKey = [keyValueStr substringWithRange:weekRange];
                NSString *weekValue = [keyValueStr substringFromIndex:weekRange.location + weekRange.length + 3];
                
                //取出头和尾 []
                NSString *weekValueSubPre = [weekValue substringFromIndex:1];
                NSString *weekValueSubPreAndSuf = [weekValueSubPre substringToIndex:weekValueSubPre.length];
                
                NSArray *weekStrNumArr = [weekValueSubPreAndSuf componentsSeparatedByString:@","];
                NSMutableArray *weekNumArr = [NSMutableArray array];
                for (NSString *str in weekStrNumArr) {
                    [weekNumArr addObject:[NSNumber numberWithInteger:[str integerValue]]];
                }
                
                dict[weekKey] = weekNumArr;
            }
            if ([keyValueStr containsString:@"course"]) {
                NSRange courseRange = [keyValueStr rangeOfString:@"course"];
                NSString *courseKey = [keyValueStr substringWithRange:courseRange];
                NSString *courseValue = [keyValueStr substringFromIndex:courseRange.location + courseRange.length + 3];
                [courseValue stringByAppendingString:@"\""];
                dict[courseKey] = [NSString replaceUnicode:courseValue];
            }
            if ([keyValueStr containsString:@"classroom"]) {
                NSRange classroomRange = [keyValueStr rangeOfString:@"classroom"];
                NSString *classroomKey = [keyValueStr substringWithRange:classroomRange];
                NSString *classroomValue = [keyValueStr substringFromIndex:classroomRange.location + classroomRange.length + 3];
                dict[classroomKey] = [NSString replaceUnicode:classroomValue];
            }
            if ([keyValueStr containsString:@"mark"]) {
                NSRange markRange = [keyValueStr rangeOfString:@"mark"];
                NSString *markKey = [keyValueStr substringWithRange:markRange];
                NSString *markValueTemp = [keyValueStr substringFromIndex:markRange.location + markRange.length + 3];
                NSString *markValue = [markValueTemp componentsSeparatedByString:@"\""][0];
                dict[markKey] = [NSString replaceUnicode:markValue];
            }

        }
        [dictArr addObject:dict];
    }
    
//    NSLog(@"++++++++%@\n",dictArr);
//    for (NSDictionary *dict in dictArr) {
//        NSLog(@"%@",dict);
//    }

    
    
    
    return dictArr;
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
