//
//  ZSStudentNumBindViewController.m
//  辽科大助手
//
//  Created by DongAn on 16/1/7.
//  Copyright © 2016年 DongAn. All rights reserved.
//

#import "ZSStudentNumBindViewController.h"
#import "ZSHttpTool.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"

#import "ZSBindTool.h"

#import "ZSTabBarController.h"

#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD.h"



@interface ZSStudentNumBindViewController ()
@property (weak, nonatomic) IBOutlet UITextField *xHText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property  (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ZSStudentNumBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.activityIndicator.hidden = YES;
     self.navigationItem.title = @"学号绑定";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)xHBindButtonClicked:(id)sender {
    
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser];
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey];
    NSString *xh = self.xHText.text;
    NSString *pwd = self.passwordText.text;
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [ZSBindTool bindWithUser:nickName key:key zjh:xh Andmm:pwd success:^(NSInteger code) {
        if (code == 600) {
           // [responseObject[@"state"] isEqualToString:@"600"]
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showError:@"绑定失败"];
                
            });
        } else if (code == 601) {
            //[responseObject[@"state"] isEqualToString:@"601"]
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [MBProgressHUD showError:@"学号已被绑定"];
            
        } else if (code == 701){
            
            //圆圈停止转动
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            
            //再次点击按钮 识别验证码
            [self xHBindButtonClicked:nil];

            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showSuccess:@"绑定成功"];
            });
            
            
            
            ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
            ZSKeyWindow.rootViewController = tabBarVC;
            
        }
     } failure:^(NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [MBProgressHUD showError:@"网络错误"];
        
    }];
    
    [self.view endEditing:YES];

}

- (IBAction)enterHomeButtonClicked:(id)sender {
    
    ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
    ZSKeyWindow.rootViewController = tabBarVC;
    
    //结束键盘
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}


@end
