//
//  ZSMyInfoViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/30.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSMyInfoViewController.h"
#import "ZSMyInfoCell.h"
#import "ZSModel.h"
#import "ZSGroupModel.h"
#import "ZSMyInfoHeader.h"
#import "ZSAccountTool.h"
#import "ZSAccount.h"


@interface ZSMyInfoViewController () <ZSmyIofoHeaderDelegate>

@end

@implementation ZSMyInfoViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return self = [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initModelData]
    
    ;
    [self setUpTableHeaderView:@"ZSMyInfoHeader"];
    
    //设置cell的类型， 隐藏导航栏
    [self setBase];
    
    //接收cell发过来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickBackBtn) name:ZSDidClickBackBtn object:nil];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//设置cell界面的位置
- (void)setBase
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
}


//初始化模型数据
- (void)initModelData
{
    
    ZSAccount *account = [ZSAccountTool account];
    

    ZSModel *item1 = [ZSModel itemWithIcon:nil title:@"学号" detailTitle:account.zjh];
    ZSModel *item2 = [ZSModel itemWithIcon:nil title:@"学院" detailTitle:@"软件学院"];
    ZSModel *item3 = [ZSModel itemWithIcon:nil title:@"专业" detailTitle:@"计算机"];

    ZSModel *item4 = [ZSModel itemWithIcon:nil title:@"家乡" detailTitle:@"四川南充"];
    ZSModel *item5 = [ZSModel itemWithIcon:nil title:@"生日" detailTitle:@"1995-1-22"];

    ZSModel *item6 = [ZSModel itemWithIcon:nil title:@"微信" detailTitle:@"da747478541"];
    ZSModel *item7 = [ZSModel itemWithIcon:nil title:@"微博" detailTitle:@"DongAn1995"];
    ZSGroupModel *group1 = [[ZSGroupModel alloc] init];
    group1.items = @[item1,item2,item3,item4,item5,item6,item7];
    [self.cellData addObject:group1];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyInfoCell";
    ZSMyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZSMyInfoCell" owner:nil options:nil] lastObject];
    }
    
    ZSGroupModel *group = [[ZSGroupModel alloc] init];
    group = self.cellData[indexPath.section];
    ZSModel *item = group.items[indexPath.row];
    
    cell.infoLabel.text = item.title;
    cell.infoDetailLabel.text = item.detailTitle;
    
    return cell;
}


#pragma mark 通知方法
- (void)didClickBackBtn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
