//
//  ZSRegisterViewController.m
//  辽科大助手
//
//  Created by DongAn on 16/1/7.
//  Copyright © 2016年 DongAn. All rights reserved.
//

#import "ZSRegisterViewController.h"

#import "ZSHttpTool.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"

#import "ZSStudentNumBindViewController.h"

#import "MBProgressHUD+MJ.h"

@interface ZSRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property  (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlButton;

@end

@implementation ZSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"辽科大助手注册";
    self.activityIndicator.hidden = YES;
}

- (IBAction)registerButtonClicked:(id)sender {
    
    NSString *userName = self.userNameText.text;
    NSString *pwd = self.passwordText.text;
    NSString *sex = self.segmentedControlButton.selectedSegmentIndex ? @"girl" : @"boy";
 
    NSDictionary *parameters = @{@"nickname":userName,@"password":pwd,@"sex":sex};
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=app/appRegister" parameters:parameters success:^(id responseObject) {
        
       
        
        if (![responseObject[@"code"] isEqualToString:@"100"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showError:@"注册失败"];
                
            });
        } else if([responseObject[@"code"] isEqualToString:@"2"]) {
            
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [MBProgressHUD showError:@"该昵称已被占用"];
            
        }else if([responseObject[@"code"] isEqualToString:@"3"]) {
            
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [MBProgressHUD showError:@"用户名由字母和数字组成"];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showSuccess:@"注册成功"];
            });
            
            //保存账号和密码,key(randString等价)
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:ZSUser];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:ZSPassword];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"randString"] forKey:ZSKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ZSStudentNumBindViewController *studentNumBindVC = [[ZSStudentNumBindViewController alloc] init];
            [self presentViewController:studentNumBindVC animated:YES completion:nil];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


@end
