//
//  ZSMessageViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSMessageViewController.h"
#import "ZSMessageGroupModel.h"
#import "ZSMessageModel.h"
#import "ZSMessageCell.h"

#import "ZSNewsController.h"

@interface ZSMessageViewController ()

@property (nonatomic,strong)NSMutableArray *cellData;

@end

@implementation ZSMessageViewController

- (NSMutableArray *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableArray array];
    }
    return _cellData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initModelData];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.rowHeight = 84;
    
    self.tableView.sectionFooterHeight = 10;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//初始化模型数据
- (void)initModelData
{
    ZSMessageModel *item1 = [ZSMessageModel itemWithIcon:@"news_lkdhelper" title:@"辽科大助手"detailTitle:@"消息：辽科大助手的功能你都了解么？"  vcClass:[ZSNewsController class]];
    ZSMessageGroupModel *group1 = [[ZSMessageGroupModel alloc] init];
    group1.items = @[item1];
    [self.cellData addObject:group1];
    
    ZSMessageModel *item2 = [ZSMessageModel itemWithIcon:@"news_ustl" title:@"科大资讯" detailTitle:@"消息： 暂无" vcClass:[ZSNewsController class]];
    
    ZSMessageGroupModel *group2 = [[ZSMessageGroupModel alloc] init];
    group2.items = @[item2];
    [self.cellData addObject:group2];
    
    
    ZSMessageModel *item3 = [ZSMessageModel itemWithIcon:@"privatenews" title:@"私信" detailTitle:@"消息： 暂无"];

    ZSMessageGroupModel *group3 = [[ZSMessageGroupModel alloc] init];
    group3.items = @[item3];
    [self.cellData addObject:group3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.cellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ZSMessageGroupModel *group = [[ZSMessageGroupModel alloc] init];
    group = self.cellData[section];
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZSMessageCell *cell = [ZSMessageCell cellWithTableView:tableView];
    ZSMessageGroupModel *group = self.cellData[indexPath.section];
    ZSMessageModel *item = group.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSMessageGroupModel *group = self.cellData[indexPath.section];
    ZSMessageModel *item = group.items[indexPath.row];
    
    if(item.class) {
        
        if (indexPath.section == 0) {
            
            ZSNewsController *vc = [[item.vcClass alloc] init];
//            vc.newsType = @"newslkdhelperread";
            vc.newsPictureType = @"pic_news_lkdhelper";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.section == 1) {
            ZSNewsController *vc = [[item.vcClass alloc] init];
            vc.newsType = @"newsustlread";
            vc.newsPictureType = @"pic_news_ustl";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
