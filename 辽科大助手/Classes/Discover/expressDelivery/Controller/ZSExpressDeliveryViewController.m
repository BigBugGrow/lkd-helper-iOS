//
//  ZSExpressDeliveryViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/6.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSExpressDeliveryViewController.h"
#import "MBProgressHUD+MJ.h"

@interface ZSExpressDeliveryViewController () <UIWebViewDelegate>

@end

@implementation ZSExpressDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"快递查询";
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    //拼接URL字符串
    //创建URL
    NSURL *url = [NSURL URLWithString:@"http://www.kuaidi100.com"];
    
//    NSString *body = [NSString stringWithFormat:@"nickname=%@&key=%@", account.nickname, account.key];
//    
//    //创建请求
//    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    //设置为post请求
    [request setHTTPMethod:@"GET"];
    
    //设置请求体
//    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]
    
    //加载请求
    [webView loadRequest:request];
    
    //设置代理
    webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** webView的代理方法*/

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
