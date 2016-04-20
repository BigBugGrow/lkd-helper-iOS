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
#import "UpYun.h"
#import "ZSAccountTool.h"

#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

#import "ZSLoginTool.h"

#import "ZSStudentNumBindViewController.h"
#import "ZSRegisterViewController.h"
#import "ZSNavigationController.h"

@interface ZSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property  (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)exitLogin;

@end

@implementation ZSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.activityIndicator.hidden = YES;
    self.userNameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser];
    self.passwordText.text = [[NSUserDefaults standardUserDefaults] objectForKey:ZSPassword];
    
    //设置返回按钮文字
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    // 1.addTarget
    [self.userNameText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    //添加监听
    [self textChange];
    
}

- (void)textChange
{
    // 判断两个文本框的内容
    self.loginBtn.enabled = self.userNameText.text.length && self.passwordText.text.length;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(UIButton *)sender
{
    NSString *userName = self.userNameText.text;
    NSString *pwd = self.passwordText.text;
    
    [self.view endEditing:YES];
    
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];

    
    [ZSLoginTool loginWithUser:userName AndPassword:pwd success:^(NSInteger code) {
        
        if (code != 100) {
            
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
            
//            ZSAccount *account = [[ZSAccount alloc] init];
//            account.
            
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
    ZSLog(@"wwww");
    
    ZSRegisterViewController *registerVC = [[ZSRegisterViewController alloc] init];
    
//    ZSNavigationController *nav = [[ZSNavigationController alloc] initWithRootViewController:registerVC];
    
//    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [root presentViewController:registerVC animated:YES completion:nil];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}


- (IBAction)goBindX {
    
    ZSStudentNumBindViewController *bindVc = [[ZSStudentNumBindViewController alloc] init];
    
    [self.navigationController pushViewController:bindVc animated:YES];
}



- (IBAction)exitLogin {
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [root dismissViewControllerAnimated:YES completion:nil];
    
    
    ZSLog(@"ddd");
}
@end
