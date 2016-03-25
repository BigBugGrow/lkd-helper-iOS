//
//  BSNovcltyViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/17.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSNovcltyViewController.h"
#import "ZSBasicViewController.h"
#import "ZSPublishView.h"
#import "ZSComposeViewController.h"

@interface ZSNovcltyViewController () <UIScrollViewDelegate, ZSPublishViewDelegate>

/** scroView*/
@property (nonatomic, weak) UIScrollView *scrollView;

/** 当前高亮按钮*/
@property (nonatomic, weak) UIButton *currentHighLightBtn;

/** 指示器*/
@property (nonatomic, weak) UIView *indecatorView;

/** titlesView*/
@property (nonatomic, weak) UIView *titlesView;

@end

@implementation ZSNovcltyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加子控制器
    [self settingUpChildController];
    
    //设置导航title条
    [self settingUpTitle];
    
    //设置scroView
    [self settingUpScroView];
    
}

/** 添加子控制器*/
- (void)settingUpChildController
{
    //全部动态
    ZSBasicViewController *allVC = [[ZSBasicViewController alloc] init];
    allVC.type = @"all";
    [self addChildViewController:allVC];
    
    //吐槽
    ZSBasicViewController *debunkVC = [[ZSBasicViewController alloc] init];
    debunkVC.type = @"discloseBoard";
    [self addChildViewController:debunkVC];

    //表白
    ZSBasicViewController *professVC = [[ZSBasicViewController alloc] init];
    professVC.type = @"confessionWall";
    [self addChildViewController:professVC];
    
    //话题
    ZSBasicViewController *topicVC = [[ZSBasicViewController alloc] init];
    topicVC.type = @"topics";
    [self addChildViewController:topicVC];
    
}

//设置scroView
- (void)settingUpScroView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(self.view.width * self.childViewControllers.count, 0);
    scrollView.frame = self.view.bounds;
    
    scrollView.pagingEnabled = YES;
    
    scrollView.delegate = self;
    
    self.scrollView = scrollView;
    
    [self.view insertSubview:scrollView atIndex:0];
    
    //开始显示第一个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}

/** 设置导航条*/
- (void)settingUpTitle
{

    //控制器的标题
    self.navigationItem.title = @"糯米粒";
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    //设置navigation阴影
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"blueShdow"];
    
    //添加右边发送按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_write_penicon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSendBtn)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //添加titiles
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = RGBColor(3, 169, 244, 1);
    titlesView.frame = CGRectMake(0, 0, ZSScreenW, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    NSArray *titles = @[@"全部动态", @"吐槽榜", @"表白墙", @"今日话题"];
    
    CGFloat titleBtnWidth = ZSScreenW / 4.0;
    CGFloat titleBtnHeight = 35;
    
    //3.设置指示器
    UIView *indecatorView = [[UIView alloc] init];
    indecatorView.width = titleBtnWidth;
    indecatorView.height = 2;
    indecatorView.y = titlesView.height - indecatorView.height;
    indecatorView.backgroundColor = [UIColor whiteColor];
    self.indecatorView = indecatorView;
    
    //2.添加按钮
    for (int i = 0; i < titles.count; i ++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.width = titleBtnWidth;
        button.height = titleBtnHeight;
        button.x = i * titleBtnWidth;
        button.y = 0;
        
        button.tag = i;
        
        //设置内容
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(255, 255, 255, 0.5) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        //添加点击监听
        [button addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {

            button.enabled = NO;
            self.currentHighLightBtn = button;
            
            [button.titleLabel sizeToFit];
            
            self.indecatorView.width = button.titleLabel.width;
            self.indecatorView.centerX = button.centerX;
            
        }
        
        [titlesView addSubview:button];
    }
    
    [titlesView addSubview:indecatorView];
}


/** 点击发送消息按钮*/
- (void)clickSendBtn
{
    
    ZSPublishView *publish = [ZSPublishView publishView];
    
    publish.delegate = self;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:publish];
}


/** 点击按钮*/
- (void)clickTitleBtn:(UIButton *)btn
{
    
    self.currentHighLightBtn.enabled = YES;
    btn.enabled = NO;
    self.currentHighLightBtn = btn;
    
    //改变指示器的x值
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indecatorView.width = btn.titleLabel.width;
        self.indecatorView.centerX = btn.centerX;
    }];
    
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x = btn.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offSet animated:YES];

}

#pragma mark - scroView的代理方法

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int btnI = scrollView.contentOffset.x / scrollView.width;
    
    //取出子控制器
    UIViewController *viewController = self.childViewControllers[btnI];
    
    viewController.view.y = 0;
    viewController.view.x = scrollView.contentOffset.x;
    viewController.view.width = self.scrollView.width;
    viewController.view.height = self.scrollView.height;
    
    [self.scrollView addSubview:viewController.view];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    int btnI = scrollView.contentOffset.x / scrollView.width;
    
    [self clickTitleBtn:self.titlesView.subviews[btnI]];
}


#pragma mark - ZSPublishView的代理方法
- (void)pushToPublishViewController:(ZSPublishView *)allDynamicCell ComposeViewController:(ZSComposeViewController *)composeViewController
{
    [self.navigationController pushViewController:composeViewController animated:YES];
}

@end
