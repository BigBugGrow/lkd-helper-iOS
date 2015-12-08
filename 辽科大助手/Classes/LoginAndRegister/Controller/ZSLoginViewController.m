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

#import "ZSAccountTool.h"

#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

#import "ZSLoginTool.h"

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
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];

    
    [ZSLoginTool loginWithUser:userName AndPassword:pwd success:^(NSInteger code) {
        
        if (code != 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showError:@"登录失败,账户或密码错误"];
                
            });
        } else {
            
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
