//
//  ZSLostAndFoundViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/3.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSLostAndFoundViewController.h"
#import "ZSLostThing.h"
#import "MJExtension.h"
#import "ZSLostThingViewCell.h"
#import "ZSHttpTool.h"
#import "ZSDynamicPicturesView.h"
#import "MJRefresh.h"
#import "ZSWLostViewController.h"
#import "ZSLostCommenViewController.h"

#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]

@interface ZSLostAndFoundViewController ()<ZSLostThingViewCellDelegate>

/** plusBtn*/
@property (nonatomic, weak) UIButton *plusBtn;

/** 模型数组*/
@property (nonatomic, strong) NSMutableArray *lostThings;

@end

static NSString *ID = @"lostAndFoundCell";


@implementation ZSLostAndFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tableView
    [self initTableView];
    
    //添加刷新
    [self initRefresh];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIButton *plusBtn = [[UIButton alloc] init];
    plusBtn.width = 60;
    plusBtn.height = 60;
    plusBtn.x = ZSScreenW - plusBtn.width - 15;
    plusBtn.y = ZSScreenH - plusBtn.height - 20;
    [plusBtn setImage:[UIImage imageNamed:@"pic_treehole_sent_img"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"pic_treehole_sent_img_pressed"] forState:UIControlStateHighlighted];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:plusBtn];
    self.plusBtn = plusBtn;
    
    //添加监听方法
    [plusBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.plusBtn removeFromSuperview];
}

- (void)clickSendBtn
{
    /** 写寻物启事公告*/
    ZSWLostViewController *writeLostViewController = [[ZSWLostViewController alloc] init];
    
    [self.navigationController pushViewController:writeLostViewController animated:YES];
}


- (void)initRefresh
{
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    [self.tableView headerBeginRefreshing];
    
}

/** 加载新的数据*/
- (void)loadNewData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"item"] = @"00";
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=LostAndFound/LostAndFoundRead" parameters:params success:^(id responseObject) {
        
        
        NSArray *datas = responseObject[@"data"];
        
        NSMutableArray *lostThings = [NSMutableArray array];
        
        for (NSDictionary *dict in datas) {
            
            ZSLostThing *lostThing = [ZSLostThing objectWithKeyValues:dict];
            
            NSString *picPreSubStr = [dict[@"pic"] substringFromIndex:1];
            NSString *picSufSubStr = [picPreSubStr substringToIndex:picPreSubStr.length - 1];
            
            if (![picSufSubStr isEqualToString:@""]) {
                
                NSArray *pics = [picSufSubStr componentsSeparatedByString:@","];
                lostThing.pics = pics;
            } else {
                lostThing.pics = nil;
            }
            
            [lostThings addObject:lostThing];
        }
        
        self.lostThings = lostThings;
        
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
    }];
    

}

/** 初始化tableView*/
- (void)initTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZSLostThingCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.title = @"失物启事";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.lostThings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZSLostThingViewCell *cell = [ZSLostThingViewCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    ZSLostThing *lostThing = self.lostThings[indexPath.row];
    
    cell.lostThing = lostThing;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pics = [self.lostThings[indexPath.row] pics];
    
    CGSize size = [ZSDynamicPicturesView sizeWithPicturesCount:pics.count];
    
    return 230 + size.height + 20;
}


- (void)clickCall:(ZSLostThingViewCell *)lostThingViewCell PhoneNum:(NSString *)phoneNum
{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定拨打电话？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@", phoneNum];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        
    }];
    
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    

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
