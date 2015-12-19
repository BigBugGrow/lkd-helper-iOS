//
//  ZSInquireWebViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSInquireWebViewController.h"

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
    
    
    //拼接URL字符串
    
    //创建URL
    NSURL *url = [NSURL URLWithString:self.inquireURL];
    
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [webView loadRequest:request];
    
    //设置代理
    webView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //提示用户正在加载
   // [MBProgressHUD showMessage:@"正在加载..."];
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view];
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
