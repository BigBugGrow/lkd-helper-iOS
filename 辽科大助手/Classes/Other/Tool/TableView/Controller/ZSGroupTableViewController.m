//
//  ZSGroupTableViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSGroupTableViewController.h"
#import "ZSModel.h"
#import "ZSGroupModel.h"
#import "ZSTableViewCell.h"
#import "ZSInfoViewController.h"
#import "ZSAccountTool.h"
#import "ZSPersonalUser.h"
#import "ZSHttpTool.h"
#import "ZSAccount.h"
#import "SVProgressHUD.h"
#import "ZSStudentNumBindViewController.h"


#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSGroupTableViewController ()

@end

@implementation ZSGroupTableViewController

- (NSMutableArray *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableArray array];
    }
    return _cellData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.rowHeight = 54;
}
//初始化模型数据
- (void)initModelData
{
    
}
//配置headerView
- (void)setUpTableHeaderView:(NSString *)headViewName
{
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:headViewName owner:nil options:nil] lastObject];
    
    headerView.height = 130;
    
    //添加点击事件
    headerView.userInteractionEnabled = YES;
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView)]];
    
    self.tableView.tableHeaderView = headerView;
}

/** 点击headerView*/
- (void)clickHeaderView
{
    ZSInfoViewController *infoViewCV = [[ZSInfoViewController alloc] init];
    infoViewCV.whoNickName = nickName;
    
    ZSLog(@"%@", nickName);

    [self.navigationController pushViewController:infoViewCV animated:YES];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZSGroupModel *group = [[ZSGroupModel alloc] init];
    group = self.cellData[section];
    return group.items.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSTableViewCell *cell = [ZSTableViewCell cellWithTableView:tableView];
    ZSGroupModel *group = self.cellData[indexPath.section];
    ZSModel *item = group.items[indexPath.row];
    cell.item = item;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSGroupModel *group = self.cellData[indexPath.section];
    ZSModel *item = group.items[indexPath.row];
    
    if (item.operation) {
        item.operation();
    } else if(item.class) {
        
        id vc = [[item.vcClass alloc] init];
        
        if (vc == nil) {
            return;
        }
        
        ZSAccount *account = [ZSAccountTool account];
        if (account.zjh && [vc isKindOfClass:[ZSStudentNumBindViewController class]]) {
            
            [SVProgressHUD showErrorWithStatus:@"该账号以绑定学号！"];
            return;
        }
        
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
