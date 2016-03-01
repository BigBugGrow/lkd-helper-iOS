//
//  ZSInquireWebViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSInquireWebViewController.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"
#import "MBProgressHUD+MJ.h"

@interface ZSInquireWebViewController ()<UIWebViewDelegate>


@end

@implementation ZSInquireWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    //展示登录的网页->UIWebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview: webView];
    
    //加载网页
    
    
    //获取account
    ZSAccount *account = [ZSAccountTool account];
    
    //拼接URL字符串
    //创建URL
    NSURL *url = [NSURL URLWithString:self.inquireURL];
    
    NSString *body = [NSString stringWithFormat:@"nickname=%@&key=%@", account.nickname, account.key];
    
    //创建请求
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //设置为post请求
    [request setHTTPMethod:@"POST"];
    
    //设置请求体
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //加载请求
    [webView loadRequest:request];
    
    //设置代理
    webView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //提示用户正在加载
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"网络可能有问题咯~~"];
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
