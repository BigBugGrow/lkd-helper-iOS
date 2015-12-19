//
//  ZSNewsController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/8.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewsController.h"
#import "ZSNewsCell.h"
#import "ZSNewsResult.h"
#import "ZSNewsDataTool.h"

#import "ZSNewsDataTool.h"
#import "ZSNewsTool.h"
#import "ZSNewsInfo.h"

#import "ZSNewsWebViewController.h"

#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

#import "UIImageView+WebCache.h"

@interface ZSNewsController ()
@property (nonatomic,strong)NSMutableArray *newsArr;
@end

@implementation ZSNewsController

- (NSMutableArray *)newsArr
{
    if (_newsArr == nil) {
        _newsArr = [NSMutableArray array];
    }
    return _newsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self latestNewsDataSaved];
    
    [self.tableView addHeaderWithTarget:self action:@selector(requestLatestNewsData)];
    
    self.tableView.rowHeight = 250;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    
  //  DALog(@"%@",[ZSNewsTool newsHelperResult].latestNews);
    
}

- (void)latestNewsDataSaved
{
    
    ZSNewsResult *newsResult = [ZSNewsTool newsResultWithType:self.newsType];
    
    if (newsResult.latestNews.count == 0) {
        [self requestLatestNewsData];
        return;
    }

    [self.newsArr removeAllObjects];
    [self.newsArr addObjectsFromArray:newsResult.latestNews];

    [self.tableView reloadData];
}

- (void)requestLatestNewsData
{
    
    NSString *item_start = @"00";
    
    [ZSNewsDataTool getNewsWithType:self.newsType item_start:item_start AndItem_end:nil success:^(ZSNewsResult *newsResult) {
        
        [self.tableView headerEndRefreshing];
        
        [self.newsArr removeAllObjects];
        [self.newsArr addObjectsFromArray:newsResult.latestNews];
        
        [self.tableView reloadData];
        
        [ZSNewsTool saveNewsResult:newsResult WithType:self.newsType];
        
    } failure:^(NSError *error) {
        if (error) {
            
            DALog(@"%@",error);
            [MBProgressHUD showError:@"网络问题"];
            [self.tableView headerEndRefreshing];
        }
    }];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.newsArr.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ZSNewsCell *cell = [ZSNewsCell cellWithTableView:tableView];
    ZSNewsInfo *item = self.newsArr[indexPath.row];
    cell.model = item;
    cell.newsPictureType = self.newsPictureType;
    
    
    //3.图片imageView
    NSString *url = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/%@/%@.jpg",self.newsPictureType,item.pic];
    
    NSURL *URL = [NSURL URLWithString:url];
    
    //    [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //        NSLog(@"----------------------");
    //    }];
    [cell.image sd_setImageWithPreviousCachedImageWithURL:URL andPlaceholderImage:[UIImage imageNamed:@"placeholder"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSNewsInfo *item = self.newsArr[indexPath.row];
    
    ZSNewsWebViewController *webVC = [[ZSNewsWebViewController alloc] init];
    
    webVC.url = item.url;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
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
