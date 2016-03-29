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

#import "ZSMyInfoViewController.h"

@interface ZSInfoViewController ()

@end

@implementation ZSInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初始化tableView
//    [self initHeaderView];
    
    //设置数据
    [self initModelData];
}

/** 初始化headerView*/
- (void)initHeaderView
{
    
    //headerView的大背景
    UIView *headerView = [[UIView alloc] init];
    headerView.width = ZSScreenW;
    headerView.height = 330;
    headerView.x = 0;
    headerView.y = 0;
    
    //大图片
    UIImageView *myImage = [[UIImageView alloc] init];
    myImage.width = ZSScreenW;
    myImage.height = 300;
    myImage.x = 0;
    myImage.y = 0;
    
    //网址
    NSString *urlStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg", self.whoNickName];
    
    myImage.image = [UIImage imageNamed:@"about_lkdhelper"];
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
    
}

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
//初始化模型数据
- (void)initModelData
{
    
    //去掉分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //标题
    self.title = [NSString stringWithFormat:@"%@的信息", self.whoNickName];
    
    
    ZSModel *item1 = [ZSModel itemWithIcon:@"me" title:@"学校"detailTitle:@"辽宁科技大学"  vcClass:[ZSMyInfoViewController class]];
    ZSModel *item2 = [ZSModel itemWithIcon:@"mynovelty" title:@"专业" detailTitle:@"软件工程"];
    ZSModel *item3 = [ZSModel itemWithIcon:@"mylost_found" title:@"故乡" detailTitle:@"辽宁葫芦岛"];
    
    ZSGroupModel *group1 = [[ZSGroupModel alloc] init];
    group1.items = @[item1,item2,item3];
    [self.cellData addObject:group1];
    
    ZSModel *item4 = [ZSModel itemWithIcon:@"setting" title:@"联系我" detailTitle:@"18341269171"];
    ZSModel *item5 = [ZSModel itemWithIcon:@"ring" title:@"QQ" detailTitle:@"1621635881"];
    
    ZSModel *item6 = [ZSModel itemWithIcon:@"setting" title:@"微信号" detailTitle:@"wfnaskcs"];
    ZSModel *item7 = [ZSModel itemWithIcon:@"ring" title:@"微博" detailTitle:@"yyue等你来访问"];
    
    
    ZSGroupModel *group2 = [[ZSGroupModel alloc] init];
   
    group2.items = @[item4,item5,item6, item7];
    [self.cellData addObject:group2];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
