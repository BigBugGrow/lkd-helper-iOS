//
//  ZSSendInfoViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSSendInfoViewController.h"
#import "ZSHttpTool.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"
#import "SVProgressHUD.h"

@interface ZSSendInfoViewController ()


@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *qqNum;
@property (weak, nonatomic) IBOutlet UITextField *wechatNum;
- (IBAction)saveInfo;

@end

#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]
#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@implementation ZSSendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改个人联系信息";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (IBAction)saveInfo {
    
    NSString *phone = self.phoneNum.text ? self.phoneNum.text : @"暂无";
    
    NSString *qq = self.qqNum.text ? self.qqNum.text : @"暂无";
    
    NSString *wechat = self.wechatNum.text ? self.wechatNum.text : @"暂无";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"nickname"] = nickName;
    params[@"key"] = key;
    params[@"phone"] = phone;
    params[@"qq"] = qq;
    params[@"wechat"] = wechat;
    
    ZSLog(@"%@", key);
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/userInfoWrite" parameters:params success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"state"] integerValue] == 100) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
@end
