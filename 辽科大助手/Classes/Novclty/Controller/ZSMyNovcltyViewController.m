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

#import "ZSNovcltyTool.h"

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
@property (nonatomic, weak) UIImageView *topView;

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
    [self getNewData];
    
    //初始化headerView
    [self initHeaderView];

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
    label.text = @" 全部动态";
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
    topLine.x = 0;
    topLine.y = headerView.height - topLine.height - label.height - 5;
    

    UIView *buttomLine = [[UIView alloc] init];
    buttomLine.backgroundColor = topLine.backgroundColor;
    buttomLine.width = 65;
    buttomLine.height = 1;
    buttomLine.x = 0;
    buttomLine.y = headerView.height - 1 - 5;

    [headerView addSubview:topLine];
    [headerView addSubview:buttomLine];
    [headerView addSubview:label];
    
    UILabel *middleLabel = [[UILabel alloc] init];
    middleLabel.text = @"下拉会放大图片哦";
    middleLabel.frame = CGRectMake(0, headerView.height - 75, ZSScreenW, 30);
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.textColor = [UIColor lightGrayColor];
    middleLabel.font = label.font;
    [headerView addSubview:middleLabel];
    
    
    //大图片
    UIImageView *myImage = [[UIImageView alloc] init];
    myImage.width = ZSScreenW;
    myImage.height = 300;
    myImage.x = 0;
    myImage.y = -HMTopViewH;
    
    // 设置内边距(让cell往下移动一段距离)
    self.tableView.contentInset = UIEdgeInsetsMake(HMTopViewH * 0.5, 0, 0, 0);
    self.topView = myImage;
    
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
    
    
    //激活图片点击事件
    headerView.userInteractionEnabled = YES;
    myImage.userInteractionEnabled = YES;
    smallImageView.userInteractionEnabled = YES;
    [smallImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRightBtn)]];
    
    [smallImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *picture = smallImageView.image;
        
        //制作头像的圆形形状
        [smallImageView.layer setCornerRadius:CGRectGetHeight([smallImageView bounds]) / 2];
        smallImageView.layer.masksToBounds = YES;
        //        然后再给图层添加一个有色的边框，类似qq空间头像那样
        smallImageView.layer.borderWidth = 2;
        smallImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        smallImageView.image = picture;
        
    }];
    
    [myImage addSubview:smallImageView];
    
    //昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.width = 200;
    nameLabel.height = 30;
    nameLabel.x = smallImageView.x - marginWidth + 3 - nameLabel.width;
    nameLabel.y = CGRectGetMaxY(smallImageView.frame) - marginWidth - nameLabel.height;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.text = self.whoNickName;
    nameLabel.font = [UIFont systemFontOfSize:20 weight:5];
    nameLabel.textColor = [UIColor whiteColor];
    [myImage addSubview:nameLabel];
    
}

/** 添加下拉刷新*/
- (void)settingRefresh
{
    // 添加下拉刷新
//    [self.tableView addHeaderWithTarget:self action:@selector(refreshDown)];
//    [self.tableView headerBeginRefreshing];
    
    //添加上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(refreshMoreData)];
}

- (void)refreshMoreData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @(self.endId);
    params[@"nickname"] = self.whoNickName;
    
    //结束下拉刷新
    [self.tableView headerEndRefreshing];
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/noveltyRead" parameters:params success:^(NSDictionary *responseObject) {
        
        //保存上一次访问的一条数据的最后一个
        self.endId = [responseObject[@"endId"] integerValue];
        
        NSArray *dynamics = responseObject[@"data"];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        
        for (NSDictionary *dict in dynamics) {
            
            //模型数据
            ZSAllDynamic *dynamic = [ZSAllDynamic objectWithKeyValues:dict];
            
            //赋值自己的nickname
            dynamic.nickname = nickName;
            
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
            
            
            //            [MBProgressHUD showMessage:@"刷新成功"];
            
        }
        [self.allDynamicFrames addObjectsFromArray:arrayM];
        
        //结束下拉刷新
        [self.tableView headerEndRefreshing];
        
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

        
        NSArray *dynamics = responseObject[@"data"];
        //保存上一次访问的一条数据的最后一个
        self.lastDynamicId = [responseObject[@"endId"] integerValue];
        
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
            
            if ([dynamic.ID integerValue] > self.lastDynamicId) {
                
                [arrayM addObject:allDynamicFrame];
            } else {
                break;
            }
            
            
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
/** */
- (void)clickRightBtn
{
    
    ZSLog(@"cdsh");
    ZSInfoViewController *info = [[ZSInfoViewController alloc] init];
    
    info.whoNickName = self.whoNickName;
    
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
    ZSLog(@"输出");
    //刷新数据
    [self getNewData];
}

#pragma mark - UISCrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 向下拽了多少距离
    CGFloat down = -(HMTopViewH * 0.5) - scrollView.contentOffset.y;
    if (down < 0) return;
    
    CGRect frame = self.topView.frame;
    // 5决定图片变大的速度,值越大,速度越快
//    frame.size.width = ZSScreenW + down * 0.2;
    frame.size.height = HMTopViewH + down * 0.8;
    self.topView.frame = frame;
    
    
}



@end
