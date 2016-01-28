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

#import "ZSTabBarController.h"

#import "MBProgressHUD+MJ.h"


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
    
    NSDictionary *parameters = @{@"nickname":nickName,@"key":key,@"zjh":xh,@"mm":pwd};
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=app/appBind" parameters:parameters success:^(id responseObject) {
        
        
        
        if (![responseObject[@"code"] isEqualToString:@"1"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showError:@"绑定失败"];
                
            });
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
        
    }];
    
}

- (IBAction)enterHomeButtonClicked:(id)sender {
    
    ZSTabBarController *tabBarVC = [[ZSTabBarController alloc] init];
    ZSKeyWindow.rootViewController = tabBarVC;
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
