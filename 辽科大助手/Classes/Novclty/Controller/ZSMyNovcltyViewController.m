//
//  ZSMyNovcltyViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/23.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSMyNovcltyViewController.h"
#import "ZSAllDynamicFrame.h"
#import "ZSCommenViewController.h"
#import "ZSAllDynamicCell.h"
#import "MJRefresh.h"
#import "ZSHttpTool.h"
#import "UIImageView+WebCache.h"
#import "ZSAllDynamic.h"
#import "ZSInfoViewController.h"
#import "ZSPersonalUser.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD.h"

#define HMTopViewH 300

#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSMyNovcltyViewController ()<commenViewControllerDelegate>

/**
 *  动态模型数组
 */
@property (nonatomic, strong) NSMutableArray *allDynamicFrames;

/**
 *  cell的frame模型
 */
@property (nonatomic, strong) ZSAllDynamicFrame *allDynamicFrame;

/** item*/
@property (nonatomic, assign) NSInteger endId;

/** 上一个动态的ID*/
@property (nonatomic, assign) NSInteger lastDynamicId;

/**cell*/
@property (nonatomic, strong) ZSAllDynamicCell *cell;

/** topView*/
@property (nonatomic, weak) UIImageView *bigImageView;

/** 返回按钮*/
@property (nonatomic, weak) UIButton *backBtn;

/** 更多按钮*/
@property (nonatomic, weak) UIButton *moreBtn;

/** 小头像*/
@property (nonatomic, weak) UIImageView *smallImageView;
@end

@implementation ZSMyNovcltyViewController

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/** 懒加载*/
- (NSMutableArray *)allDynamicFrames
{
    if (_allDynamicFrames == nil) {
        
        _allDynamicFrames = [NSMutableArray array];
    }
    return _allDynamicFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置nav
    [self initNav];
    
    //添加刷新下拉刷新
    [self settingRefresh];
    
    //初始化headerView
    [self initHeaderView];
    
    [ZSNotificationCenter addObserver:self selector:@selector(updateImage) name:@"swapImage" object:nil];

}

- (void)updateImage
{
    self.bigImageView.image = [UIImage GetImageFromLocal:ZSIconImageStr];
    self.smallImageView.image = self.bigImageView.image;
    
    [self.tableView reloadData];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加按钮
    [self settingBackBtn];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    self.navigationController.navigationBarHidden = NO;
    [self.backBtn removeFromSuperview];
    [self.moreBtn removeFromSuperview];
}

/** 添加返回按钮*/
- (void)settingBackBtn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [backBtn setImage:[UIImage imageNamed:@"rightBack"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(70, 30);
    //设置按钮的内容靠左边
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //设置按钮的切割
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    backBtn.x = 20;
    backBtn.y = 25;
    
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [backBtn addTarget:self action:@selector(exitViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = backBtn;
    
    
    //更多信息按钮
    UIButton *moreBtn = [[UIButton alloc] init];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    moreBtn.size = CGSizeMake(40, 30);
    //设置按钮的内容靠左边
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //设置按钮的切割
    moreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    moreBtn.x = ZSScreenW - moreBtn.width;
    moreBtn.y = 25;
    
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [moreBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.moreBtn = moreBtn;
    
    
    [window addSubview:self.moreBtn];
    [window addSubview:self.backBtn];

}

/** 初始化headerView*/
- (void)initHeaderView
{
    
    //headerView的大背景
    UIView *headerView = [[UIView alloc] init];
    headerView.width = ZSScreenW;
    headerView.height = 90;
    headerView.x = 0;
    headerView.y = 0;
    
    
    //添加文字说明
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  全部动态";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    label.width = ZSScreenW;
    label.height = 30;
    label.x = 0;
    label.y = headerView.height - 1 - label.height - 5;
    
    //添加分割线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = RGBColor(242, 242, 242, 0.9);
    topLine.width = 65;
    topLine.height = 1;
    topLine.x = 10;
    topLine.y = headerView.height - topLine.height - label.height - 5;
    

    UIView *buttomLine = [[UIView alloc] init];
    buttomLine.backgroundColor = topLine.backgroundColor;
    buttomLine.width = 65;
    buttomLine.height = 1;
    buttomLine.x = 10;
    buttomLine.y = headerView.height - 1 - 5;

    [headerView addSubview:topLine];
    [headerView addSubview:buttomLine];
    [headerView addSubview:label];
    
    UIImageView *middleImageView = [[UIImageView alloc] init];
    
    middleImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    middleImageView.image = [UIImage imageNamed:@"topBg"];
    
    middleImageView.frame = CGRectMake(25, headerView.height - 75, ZSScreenW - 50, 30);
//    middleLabel.textAlignment = NSTextAlignmentCenter;
//    middleLabel.textColor = [UIColor lightGrayColor];
//    middleLabel.font = label.font;
    [headerView addSubview:middleImageView];
    
    
    //大图片
    UIImageView *myImage = [[UIImageView alloc] init];
    myImage.width = ZSScreenW;
    myImage.height = 300;
    myImage.x = 0;
    myImage.y = -HMTopViewH;
    
    // 设置内边距(让cell往下移动一段距离)
    self.tableView.contentInset = UIEdgeInsetsMake(HMTopViewH * 0.5, 0, 0, 0);
    self.bigImageView = myImage;
    
    NSString *nickNameStr = self.whoNickName ? self.whoNickName : nickName;
    
    //网址
    NSString *urlStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", nickNameStr];
    
    [myImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    [headerView addSubview:myImage];
    
    self.tableView.tableHeaderView = headerView;
    
    //边界宽度
    CGFloat marginWidth = 20;

    //小头像
    UIImageView *smallImageView = [[UIImageView alloc] init];
    
    smallImageView.width = 60;
    smallImageView.height = 60;
    smallImageView.x = ZSScreenW - marginWidth - smallImageView.width;
    smallImageView.centerY = myImage.height * 0.9 + 15;
    
 
    
    [smallImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *picture = smallImageView.image;
        
        //制作头像的圆形形状
        [smallImageView.layer setCornerRadius:CGRectGetHeight([smallImageView bounds]) / 2];
        smallImageView.layer.masksToBounds = YES;
        //        然后再给图层添加一个有色的边框，类似qq空间头像那样
        smallImageView.layer.borderWidth = 2;
        smallImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        smallImageView.userInteractionEnabled = YES;
        [smallImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRightBtn1)]];
        
        smallImageView.image = picture;
    }];
    

    self.smallImageView = smallImageView;
    
    [myImage addSubview:smallImageView];
    
    //昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.width = 100;
    nameLabel.height = 30;
    nameLabel.x = smallImageView.x - marginWidth + 3 - nameLabel.width;
    nameLabel.y = CGRectGetMaxY(smallImageView.frame) - marginWidth - nameLabel.height;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.text = self.whoNickName ? self.whoNickName : nickName;
    nameLabel.font = [UIFont systemFontOfSize:20 weight:20];
    nameLabel.textColor = [UIColor whiteColor];
    [myImage addSubview:nameLabel];
    
}

- (void)clickRightBtn1
{
    ZSLog(@"%p", __func__);
}

- (void)dealloc
{
    [ZSNotificationCenter removeObserver:self];
}


/** 添加下拉刷新*/
- (void)settingRefresh
{
    // 添加下拉刷新

    [self refreshDown];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(refreshMoreData)];
}

- (void)refreshMoreData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @(self.endId);
    params[@"nickname"] = self.whoNickName ? self.whoNickName : nickName;
    
    
    ZSLog(@"%@", params[@"nickname"]);
    
    //结束下拉刷新
    [self.tableView headerEndRefreshing];
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/myNoveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        //保存上一次访问的一条数据的最后一个
        self.endId = [responseObject[@"endId"] integerValue];
        
        NSArray *dynamics = responseObject[@"data"];
        
      
        if (self.endId == 0 || [responseObject[@"endId"] isKindOfClass:[NSNull class]]){
            
            [SVProgressHUD showSuccessWithStatus:@"已经没有数据了哦..."];
            //结束下拉刷新
            [self.tableView footerEndRefreshing];
            return;
        }

        if (dynamics.count < 9) {
            
            self.endId = 0;
        }
        

        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (NSDictionary *dict in dynamics) {
            
            //模型数据
            ZSAllDynamic *dynamic = [ZSAllDynamic objectWithKeyValues:dict];
            
            //赋值自己的nickname
            //赋值自己的nickname
            dynamic.nickname = self.whoNickName ? self.whoNickName : nickName;
            
            NSString *picPreSubStr = [dict[@"pic"] substringFromIndex:1];
            NSString *picSufSubStr = [picPreSubStr substringToIndex:picPreSubStr.length - 1];
            
            if (![picSufSubStr isEqualToString:@""]) {
                
                NSArray *pics = [picSufSubStr componentsSeparatedByString:@","];
                dynamic.pic = pics;
            } else {
                dynamic.pic = nil;
            }
            
            ZSAllDynamicFrame *allDynamicFrame = [[ZSAllDynamicFrame alloc] init];
            allDynamicFrame.allDynamic = dynamic;
            
            [arrayM addObject:allDynamicFrame];
            
            
        }
        [self.allDynamicFrames addObjectsFromArray:arrayM];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束下拉刷新
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        
        //结束下拉刷新
        [self.tableView footerEndRefreshing];
        
        ZSLog(@"获取信息失败");
    }];
    
}

- (void)refreshDown
{
    
    //结束上拉刷新
    [self.tableView footerEndRefreshing];
    [self getNewData];
    
}

//获取模型信息
- (void)getNewData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @"00";
    params[@"nickname"] = self.whoNickName ? self.whoNickName : nickName;

    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/myNoveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        NSString *endId = [NSString stringWithFormat:@"%@", responseObject[@"endId"]];
        
        if ([endId isEqualToString:@"<null>"] || [endId isEqualToString:@"0"]) {
            return ;
        }
        
        NSArray *dynamics = [NSArray array];
        
        dynamics = responseObject[@"data"];
        //保存上一次访问的一条数据的最后一个
        self.endId = [responseObject[@"endId"] integerValue];
        
        NSMutableArray *arrayM = [NSMutableArray array];
       
        for (NSDictionary *dict in dynamics) {
            
            //模型数据
            ZSAllDynamic *dynamic = [ZSAllDynamic objectWithKeyValues:dict];
            
            //赋值自己的nickname
            dynamic.nickname = self.whoNickName ? self.whoNickName : nickName;
            
            NSString *picPreSubStr = [dict[@"pic"] substringFromIndex:1];
            NSString *picSufSubStr = [picPreSubStr substringToIndex:picPreSubStr.length - 1];
            
            if (![picSufSubStr isEqualToString:@""]) {
                
                NSArray *pics = [picSufSubStr componentsSeparatedByString:@","];
                dynamic.pic = pics;
            } else {
                dynamic.pic = nil;
            }
            
            ZSAllDynamicFrame *allDynamicFrame = [[ZSAllDynamicFrame alloc] init];
            allDynamicFrame.allDynamic = dynamic;
            
            [arrayM addObject:allDynamicFrame];
            
        }
    
        NSRange range = NSMakeRange(0, arrayM.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        //将新的数据添加到大数组的最前面
        [self.allDynamicFrames insertObjects:arrayM atIndexes:indexSet];
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
        //刷新表格
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        ZSLog(@"获取信息失败");
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
    }];
    
}


/** 初始化*/
- (void)initNav
{
    NSString *nickNameStr = self.whoNickName ? self.whoNickName : nickName;
    self.title = [NSString stringWithFormat:@"%@的糯米粒", nickNameStr];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backIndicatorImage = nil;
    
    //添加导航栏右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //去掉分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)exitViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}



/** */
- (void)clickRightBtn
{
    
    ZSInfoViewController *info = [[ZSInfoViewController alloc] init];
    
    info.whoNickName = self.whoNickName ? self.whoNickName : nickName;
        
    [self.navigationController pushViewController:info animated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allDynamicFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //自定义cell
    ZSAllDynamicCell *cell = [ZSAllDynamicCell cellWithTableView:tableView];
    
    //赋值模型
    cell.allDynamicFrame = self.allDynamicFrames[indexPath.row];
    
    self.cell = cell;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.allDynamicFrames[indexPath.row] cellHeight];
}


/** 监听cell的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCommenViewController *commenView = [[ZSCommenViewController alloc] init];
    commenView.allDynamicFrame = self.allDynamicFrames[indexPath.row];
    commenView.title = @"评论";
    [self.navigationController pushViewController:commenView animated:YES];
    
    
    commenView.delegate = self;

}

#pragma mark - ZSCommentViewControllerDelegate

- (void)loadNewData
{
//    ZSLog(@"输出");
    //刷新数据
    [self getNewData];
}

#pragma mark - UISCrollView的代理方法

// scroView的代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y >= -45) {
        
        [UIView animateWithDuration:0.01 animations:^{
            self.navigationController.navigationBarHidden = NO;
            self.backBtn.hidden = YES;
            self.moreBtn.hidden = YES;
            
        }];
        
    } else {
        
    
            self.navigationController.navigationBarHidden = YES;
            self.backBtn.hidden = NO;
            self.moreBtn.hidden = NO;
    }
    // 向下拽了多少距离
    CGFloat down = -(HMTopViewH * 0.5) - scrollView.contentOffset.y;
    if (down < 0) return;
    
    CGRect frame = self.bigImageView.frame;
    // 5决定图片变大的速度,值越大,速度越快
    
    frame.size.width = ZSScreenW + down * 0.4;
    frame.size.height = HMTopViewH + down * 0.8;
    self.bigImageView.frame = frame;
    
}

/** 设置头像*/
- (void)swapImage
{
    self.bigImageView.image = [UIImage GetImageFromLocal:ZSIconImageStr];
    self.smallImageView.image = self.bigImageView.image;

}




@end
