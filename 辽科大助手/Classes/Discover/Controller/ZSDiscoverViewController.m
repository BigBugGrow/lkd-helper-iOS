//
//  ZSDiscoverViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSDiscoverViewController.h"
#import "ZSDiscoverCell.h"
#import "ZSDiscoverModel.h"
#import "ZSDiscoverGroupModel.h"

#import "ZSNovcltyViewController.h"
#import "ZSNoteViewController.h"

@interface ZSDiscoverViewController ()

@property (nonatomic,strong)NSMutableArray *cellData;

@end

@implementation ZSDiscoverViewController

- (NSMutableArray *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableArray array];
    }
    return _cellData;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
     
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self initModelData];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.rowHeight = 74;
    
    self.tableView.sectionFooterHeight = 10;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    }

//初始化模型数据
- (void)initModelData
{
    ZSDiscoverModel *item1 = [ZSDiscoverModel itemWithIcon:@"tab03_novelty" title:@"糯米粒"detailTitle:@"新鲜事，随笔，表白，吐槽，全在这里啦！"  vcClass:[ZSNovcltyViewController class]];
    ZSDiscoverGroupModel *group1 = [[ZSDiscoverGroupModel alloc] init];
    group1.items = @[item1];
    [self.cellData addObject:group1];
    
    ZSDiscoverModel *item2 = [ZSDiscoverModel itemWithIcon:@"tab03_shop" title:@"科大商城" detailTitle:@"在这里重新定义微商！"];
    
    ZSDiscoverGroupModel *group2 = [[ZSDiscoverGroupModel alloc] init];
    group2.items = @[item2];
    [self.cellData addObject:group2];
    
    
    ZSDiscoverModel *item3 = [ZSDiscoverModel itemWithIcon:@"express" title:@"找快递" detailTitle:@""];
    ZSDiscoverModel *item4 = [ZSDiscoverModel itemWithIcon:@"lost_found" title:@"寻物公告" detailTitle:@""];
    
    ZSDiscoverGroupModel *group3 = [[ZSDiscoverGroupModel alloc] init];
    group3.items = @[item3,item4];
    [self.cellData addObject:group3];
    
    ZSDiscoverModel *item5 = [ZSDiscoverModel itemWithIcon:@"note" title:@"笔记本" detailTitle:nil vcClass:[ZSNoteViewController class]];
    
    ZSDiscoverGroupModel *group4 = [[ZSDiscoverGroupModel alloc] init];
    group4.items = @[item5];
    [self.cellData addObject:group4];

    
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
    
    ZSDiscoverGroupModel *group = [[ZSDiscoverGroupModel alloc] init];
    group = self.cellData[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSDiscoverCell *cell = [ZSDiscoverCell cellWithTableView:tableView];
    ZSDiscoverGroupModel *group = self.cellData[indexPath.section];
    ZSDiscoverModel *item = group.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSDiscoverGroupModel *group = self.cellData[indexPath.section];
    ZSDiscoverModel *item = group.items[indexPath.row];
    
    if (item.operation) {
        
        item.operation();
        
    } else if(item.class) {
        
        id vc = [[item.vcClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


@end
