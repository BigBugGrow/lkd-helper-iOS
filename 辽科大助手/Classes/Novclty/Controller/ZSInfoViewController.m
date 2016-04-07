//
//  ZSProfileViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSInfoViewController.h"
#import "ZSTableViewCell.h"
#import "ZSModel.h"
#import "ZSGroupModel.h"
#import "UIImageView+WebCache.h"
#import "ZSAccountTool.h"
#import "ZSAccount.h"
#import "ZSHttpTool.h"
#import "ZSPersonalUser.h"
#import "ZSSendInfoViewController.h"

#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSInfoViewController ()

@property (nonatomic, weak) UIButton *backBtn;

@end

@implementation ZSInfoViewController


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //初始化tableView
    [self initHeaderView];
    
    //设置数据
    [self initModelData];
}


//初始化模型数据
- (void)initModelData
{
    //去掉分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //标题
    self.title = [NSString stringWithFormat:@"%@的信息", self.whoNickName];
    
    ZSModel *item0 = [ZSModel itemWithIcon:@"name" title:@"姓名" detailTitle:self.user.name];
    
    ZSModel *item1 = [ZSModel itemWithIcon:@"age" title:@"性别" detailTitle:self.user.sex];
    ZSModel *item2 = [ZSModel itemWithIcon:@"class" title:@"班级" detailTitle:self.user.class];
    
    ZSModel *item3 = [ZSModel itemWithIcon:@"major" title:@"专业" detailTitle:self.user.major];
    ZSModel *item4 = [ZSModel itemWithIcon:@"college" title:@"学院" detailTitle:self.user.college];
    ZSModel *item5 = [ZSModel itemWithIcon:@"home" title:@"故乡" detailTitle:self.user.home];
    
    ZSGroupModel *group1 = [[ZSGroupModel alloc] init];
    group1.items = @[item0,item1,item2,item3, item4, item5];
    [self.cellData addObject:group1];
    
    
    NSString *phone = self.user.phone;
    NSString *qq = self.user.qq;
    NSString *wechat = self.user.wechat;
    if ([phone isEqualToString:@"暂无"] && [self.whoNickName isEqualToString:nickName]) {
      
        phone = @"添加";
    }
    if ([qq isEqualToString:@"暂无"] && [self.whoNickName isEqualToString:nickName]) {
        
        qq = @"添加";
    }
    if ([wechat isEqualToString:@"暂无"] && [self.whoNickName isEqualToString:nickName]) {
        
        wechat = @"添加";
    }
    
    ZSModel *item6 = [[ZSModel alloc] init];
    
    ZSModel *item7 = [[ZSModel alloc] init];
    
    ZSModel *item8 = [[ZSModel alloc] init];
    
    if ([self.whoNickName isEqualToString:nickName]) {
        
        item6 = [ZSModel itemWithIcon:@"phone" title:@"电话" detailTitle:phone vcClass:[ZSSendInfoViewController class]];
        item7 = [ZSModel itemWithIcon:@"qq" title:@"QQ" detailTitle:qq vcClass:[ZSSendInfoViewController class]];
        
        item8 = [ZSModel itemWithIcon:@"weichat" title:@"微信号" detailTitle:wechat vcClass:[ZSSendInfoViewController class]];
    } else {
        item6 = [ZSModel itemWithIcon:@"phone" title:@"电话" detailTitle:phone];
        item7 = [ZSModel itemWithIcon:@"qq" title:@"QQ" detailTitle:qq];
        
        item8 = [ZSModel itemWithIcon:@"weichat" title:@"微信号" detailTitle:wechat ];

    }
    
    ZSGroupModel *group2 = [[ZSGroupModel alloc] init];
    
    group2.items = @[item6, item7, item8];
    [self.cellData addObject:group2];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"在校信息";
    } else {
        return @"联系方式";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/** 初始化headerView*/
- (void)initHeaderView
{
    //headerView的大背景
    UIView *headerView = [[UIView alloc] init];
    headerView.width = ZSScreenW;
    headerView.height = 300;
    headerView.x = 0;
    headerView.y = 0;
    
    
    //大图片
    UIImageView *myImage = [[UIImageView alloc] init];
    myImage.width = ZSScreenW;
    myImage.height = 270;
    myImage.x = 0;
    myImage.y = -20;
    
    
    myImage.backgroundColor = RGBColor(234, 234, 234, 0.5);
    
    //网址
    NSString *urlStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", self.whoNickName];
    
    NSString *urlBigStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", self.whoNickName];
    
    [myImage sd_setImageWithURL:[NSURL URLWithString:urlBigStr]];
    myImage.backgroundColor = [UIColor blackColor];
    [headerView addSubview:myImage];
    self.tableView.tableHeaderView = headerView;
    
    
    //边界宽度
    CGFloat marginWidth = 20;
    
    //小头像
    UIImageView *smallImageView = [[UIImageView alloc] init];
    
    smallImageView.width = 60;
    smallImageView.height = 60;
    smallImageView.x = ZSScreenW - marginWidth - smallImageView.width;
    smallImageView.y = myImage.height * 0.85;
    
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
    backBtn.y = 15;
    
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [backBtn addTarget:self action:@selector(exitViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = backBtn;
    
    [window addSubview:backBtn];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
}

- (void)exitViewController
{
    
    //除掉返回按钮
    [self.backBtn removeFromSuperview];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

// scroView的代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ZSLog(@"%lf", scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y >= 190) {
    
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.hidden = NO;
            self.backBtn.hidden = YES;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.navigationController.navigationBar.hidden = YES;
            self.backBtn.hidden = NO;
        }];
    }
    
}



@end
