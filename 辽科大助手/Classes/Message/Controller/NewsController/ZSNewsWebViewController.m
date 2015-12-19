//
//  ZSNewsWebViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/9.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsWebViewController.h"
#import "MBProgressHUD+MJ.h"

@interface ZSNewsWebViewController ()<UIWebViewDelegate>

@end

@implementation ZSNewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //展示登录的网页->UIWebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview: webView];
    
    //加载网页
    
    
    //拼接URL字符串
    
    //创建URL
    NSURL *url = [NSURL URLWithString:self.url];
    
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


@end
