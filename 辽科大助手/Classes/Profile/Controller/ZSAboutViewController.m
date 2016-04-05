//
//  ZSAboutViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAboutViewController.h"

@interface ZSAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *abloutLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;


@property (nonatomic, weak) UIView *cover;

@property (nonatomic, weak) UIScrollView *scroView;

@property (nonatomic, weak) UIButton *kownBtn;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation ZSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于辽科大助手";

    NSString *about = @"辽科大助手 由辽宁科技大学学生处（思政中心）管理，（网络文化工作室）负责运营，秉承“励志、利生、力行” 学生工作理念，发布大学生思想政治教育、日常管理、校园文化活动等信息，为广大师生提供校园最新资讯、查询等服务平台。";
    
    self.abloutLabel.text = about;
    
    
    [self.chargeBtn addTarget:self action:@selector(clickChargeBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickChargeBtn
{
    
    self.navigationController.navigationBar.hidden = YES;
    
    CGFloat margin = 15;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = RGBColor(123, 123, 123, 0.7);
    cover.frame = self.view.bounds;
    [self.view addSubview:cover];
    self.cover = cover;
    
    window.backgroundColor = RGBColor(123, 123, 123, 0.5);
    
    UIScrollView *scroView = [[UIScrollView alloc] init];
    scroView.width = ZSScreenW - margin * 2;
    scroView.height = ZSScreenH - margin * 2 - 30 - 40;
    scroView.x = margin;
    scroView.y = margin + 40;
    scroView.backgroundColor = [UIColor whiteColor];
    [window addSubview:scroView];
    self.scroView = scroView;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"    免责声明";
    titleLabel.width = ZSScreenW - margin * 2;
    titleLabel.height = 40;
    titleLabel.x = margin;
    titleLabel.y = margin;
    [window addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *kownBtn = [[UIButton alloc] init];
    [kownBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [kownBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    kownBtn.width = ZSScreenW - 2 * margin;
    kownBtn.height = 30;
    kownBtn.x = margin;
    kownBtn.y = window.height - kownBtn.height - 20;
    kownBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [window addSubview:kownBtn];
    [kownBtn addTarget:self action:@selector(clickKownBtn) forControlEvents:UIControlEventTouchUpInside];
    kownBtn.backgroundColor = [UIColor whiteColor];
    self.kownBtn = kownBtn;
    
    NSString *content = @"1、一切辽科大助手用户在下载并浏览辽科大助手APP时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接适应本APP资料者，均被视为自愿接受本声明和用户服务协议的约束。2、辽科大助手APP用户转载的内容并不代表辽科大助手APP之意见及观点，也不意味着辽科大助手APP赞同其观点或证实其内容的真实性。3、市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局势的市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局市场上的v讲述了独具阿斯顿送单据上来的聚少离多是大V领束带结发V领就hi阿斯顿局势的几率是历代撒绿色的局势的v按实际大V领山东卷拍摄角度 阿什利第三季度v LASDVNSDVA;Asjsdv速度v 俺是女的数据的；你啊；涉及到v；OSJV  ASIVNLOASDNJNBSVDLJI接收到了局";
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(ZSScreenW - 4 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    contentLabel.x = margin;
    contentLabel.y = 30 + 10;
    contentLabel.size = size;
    contentLabel.text = content;
    
    [scroView addSubview:contentLabel];
    
    scroView.contentSize = CGSizeMake(0, size.height + 30 + 30);
    
}

- (void)clickKownBtn
{
    self.navigationController.navigationBar.hidden = NO;
    [self.cover removeFromSuperview];
    [self.scroView removeFromSuperview];
    [self.kownBtn removeFromSuperview];
    [self.titleLabel removeFromSuperview];
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

@end
