//
//  ZSProfileViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSProfileViewController.h"
#import "ZSProfileImageCell.h"
#import "ZSTableViewCell.h"
#import "ZSModel.h"
#import "ZSGroupModel.h"

#import "ZSMyInfoViewController.h"

@interface ZSProfileViewController ()

@end

@implementation ZSProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTableHeaderView:@"ZSProfileImageCell"];
    [self initModelData];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
//初始化模型数据
- (void)initModelData
{
    ZSModel *item1 = [ZSModel itemWithIcon:@"me" title:@"我"detailTitle:@""  vcClass:[ZSMyInfoViewController class]];
    ZSModel *item2 = [ZSModel itemWithIcon:@"mynovelty" title:@"我的糯米粒" detailTitle:@""];
    ZSModel *item3 = [ZSModel itemWithIcon:@"mylost_found" title:@"我的寻物公告" detailTitle:@""];
    
    ZSGroupModel *group1 = [[ZSGroupModel alloc] init];
    group1.items = @[item1,item2,item3];
    [self.cellData addObject:group1];
    
    ZSModel *item4 = [ZSModel itemWithIcon:@"setting" title:@"设置" detailTitle:@""];
    ZSModel *item5 = [ZSModel itemWithIcon:@"ring" title:@"消息提醒模式" detailTitle:@""];
    item5.operation = ^(){
        if ([item5.title isEqualToString:@"消息提醒模式"]) {
            item5.title = @"静音模式";
            item5.icon = @"quiet";
            [self.tableView reloadData];
        } else {
            item5.title = @"消息提醒模式";
            item5.icon = @"ring";
            [self.tableView reloadData];

        }
    };
    ZSModel *item6 = [ZSModel itemWithIcon:@"about" title:@"关于辽科大助手" detailTitle:@""];
    
    ZSGroupModel *group2 = [[ZSGroupModel alloc] init];
    group2.items = @[item4,item5,item6];
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
