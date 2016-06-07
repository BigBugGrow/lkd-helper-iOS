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
#import "MBProgressHUD+MJ.h"


@interface ZSSendInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *qqNum;
@property (weak, nonatomic) IBOutlet UITextField *wechatNum;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveInfo;
- (IBAction)back;

@end

#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]
#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@implementation ZSSendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    
    self.saveBtn.enabled = NO;
    
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateHighlighted];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_register_background"]];
    
    self.title = @"修改个人联系信息";
    
    
    // 1.addTarget
    [self.qqNum addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self.wechatNum addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneNum addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    //添加监听
    [self textChange];
    

    
}


- (void)textChange
{
    // 判断两个文本框的内容
    self.saveBtn.enabled =  _phoneNum.text.length || _qqNum.text.length || _wechatNum.text.length;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    
    [MBProgressHUD showMessage:@"正在修改联系信息..." toView:self.view];
    
    NSString *phone = self.phoneNum.text ? self.phoneNum.text : @"暂无";
    
    NSString *qq = self.qqNum.text ? self.qqNum.text : @"暂无";
    
    NSString *wechat = self.wechatNum.text ? self.wechatNum.text : @"暂无";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"nickname"] = nickName;
    params[@"key"] = key;
    params[@"phone"] = phone;
    params[@"qq"] = qq;
    params[@"wechat"] = wechat;
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/userInfoWrite" parameters:params success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"state"] integerValue] == 100) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
            
        } else if([responseObject[@"state"] integerValue] == 602) {
            
            [SVProgressHUD showInfoWithStatus:@"您的账号在其它机器登陆，请注销重新登陆"];
        } else {
            
            [SVProgressHUD showInfoWithStatus:@"您输入的字符格式有误，请重新输入"];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      
    } failure:^(NSError *error) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD showSuccessWithStatus:@"请检查网络！"];
    }];
    
    
}

- (IBAction)back {
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UItextFildDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.y -= 100;
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.y += 100;
    }];
    
}


@end
