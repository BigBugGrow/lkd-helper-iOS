//
//  ZSNovcltyViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSNovcltyViewController.h"
#import "ZSSwitchView.h"
#import "ZSNewsTableViewCell.h"
#import "ZSHttpTool.h"

#import "MBProgressHUD+MJ.h"

#import "ZSAllDynamic.h"
#import "ZSAllDynamicCell.h"
#import "ZSAllDynamicFrame.h"

@interface ZSNovcltyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *scrollView;
    int currentIndex;
    UITableView *tableView1;
    UITableView *tableView2;
    UITableView *tableView3;
    UITableView *tableView4;
    float titleHeight;
    float bgViewHeight;
    ZSSwitchView *switchView;
}


/**
 *  动态模型数组
 */
@property (nonatomic, strong) NSArray *allDynamicFrames;

/**
 *  cell的frame模型
 */
@property (nonatomic, strong) ZSAllDynamicFrame *allDynamicFrame;

@end

@implementation ZSNovcltyViewController


- (NSArray *)allDynamicFrames
{
    if (_allDynamicFrames == nil) {
        
        _allDynamicFrames = [NSArray array];
    }
    return _allDynamicFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //设置navigation阴影
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"blueShdow"];
    
    [self initTitle];
    
    //获取模型信息
    [self getAllDynamics];
    
    
    titleHeight=35;
    bgViewHeight=ScreenHeight-64-titleHeight;
//    if (iOS7) {
//        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
//        
//    }
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
   
    switchView=[[ZSSwitchView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, titleHeight)];
    [self.view addSubview:switchView];
    
    [self initScroll];
    [self initTable];
    
    
}

//获取模型信息
- (void)getAllDynamics
{
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item"] = @"00";
    params[@"class"] = @"all";
    
    //获取数据
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/noveltyRead" parameters:params success:^(id responseObject) {
       

        
//        NSInteger state = [responseObject[@"state"] integerValue];
        
//        
//        if (state == 100) {
//            
//            [MBProgressHUD showMessage:@"刷新成功"];
//        }
        
        NSArray *dynamics = responseObject[@"data"];
        
        ZSLog(@"%@", dynamics);
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (NSDictionary *dict in dynamics) {
            
            ZSAllDynamic *dynamic = [ZSAllDynamic objectWithKeyValues:dict];
            dynamic.ID = dict[@"id"];
            dynamic.Class = dict[@"class"];
            ZSAllDynamicFrame *allDynamicFrame = [[ZSAllDynamicFrame alloc] init];
            allDynamicFrame.allDynamic = dynamic;
            
            [arrayM addObject:allDynamicFrame];
        }
        self.allDynamicFrames = arrayM;
        
        //刷新表格
        [tableView1 reloadData];
        
        
    } failure:^(NSError *error) {
        
        ZSLog(@"获取信息失败");
    }];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [MBProgressHUD hideHUD];
//    });
    
}

-(void)initTitle{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"糯米粒";
    self.navigationItem.titleView = titleLabel;
}
-(void)initScroll{
 
   
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleHeight, ScreenWidth, bgViewHeight)];
    scrollView.alwaysBounceHorizontal=YES;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth * (4), bgViewHeight)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,bgViewHeight) animated:NO];
    
}

-(void)initTable{
    

    
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, bgViewHeight) style:UITableViewStylePlain];
    [scrollView addSubview:tableView1];
    tableView1.showsVerticalScrollIndicator = NO;
    
    tableView1.dataSource=self;
    tableView1.delegate=self;
    tableView1.tag=11;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    
//    UIImageView *title1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 185)];
//    title1.image=[UIImage imageNamed:@"t1"];
//    [tableView1 setTableHeaderView:title1];
//    
    
    
    __unsafe_unretained UIScrollView *scrollViewA = scrollView;
    __unsafe_unretained UITableView *tableViewB = tableView2;
    __unsafe_unretained UITableView *tableViewC = tableView3;
    __unsafe_unretained UITableView *tableViewD = tableView4;


    CGFloat bgViewHeightA = bgViewHeight;

    __unsafe_unretained ZSNovcltyViewController *ZSNovcltyC = self;
    
    
    switchView.ButtonActionBlock=^(int buttonTag){
        
        currentIndex=buttonTag-100;
        
        [scrollViewA scrollRectToVisible:CGRectMake(ScreenWidth * (currentIndex-1),0,ScreenWidth,bgViewHeightA) animated:NO];
        [scrollViewA setContentOffset:CGPointMake(ScreenWidth* (currentIndex-1),0)];
        
        if (currentIndex==1) {
            
        }else if (currentIndex==2){
            if (tableView2==nil) {
                tableView2=[[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, bgViewHeight) style:UITableViewStylePlain];
                [scrollViewA addSubview:tableViewB];
                tableViewB.showsVerticalScrollIndicator = NO;

                tableViewB.tag=12;
                tableViewB.dataSource=ZSNovcltyC;
                tableViewB.delegate=ZSNovcltyC;
                tableViewB.separatorStyle=UITableViewCellSeparatorStyleNone;
                
            }

        }else if (currentIndex==3){
            if (tableView3==nil) {
                tableView3=[[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, bgViewHeight) style:UITableViewStylePlain];

                [scrollViewA addSubview:tableViewC];
                tableViewC.showsVerticalScrollIndicator = NO;

                tableViewC.tag=13;
                
                tableViewC.dataSource=ZSNovcltyC;
                tableViewC.delegate=ZSNovcltyC;
                tableViewC.separatorStyle=UITableViewCellSeparatorStyleNone;
                
                
            }

        }else if (currentIndex==4){
            if (tableView4==nil) {
                tableView4=[[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, bgViewHeight) style:UITableViewStylePlain];
                [scrollViewA addSubview:tableViewD];
                tableViewD.showsVerticalScrollIndicator = NO;
                tableViewD.tag=14;
                
                tableViewD.dataSource=ZSNovcltyC;
                tableViewD.delegate=ZSNovcltyC;
                tableViewD.separatorStyle=UITableViewCellSeparatorStyleNone;
                
            }

        }
        
        
    };
    
    currentIndex=1;
    
    
}


#pragma mark scrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (4)) / pagewidth) + 1;
    
    if (currentPage==0)
    {
 
        [scrollView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,bgViewHeight) animated:NO];
        [scrollView setContentOffset:CGPointMake(0,0)];
    }
    else if (currentPage==(3))
    {
    
        [scrollView scrollRectToVisible:CGRectMake(ScreenWidth * 3,0,ScreenWidth,bgViewHeight) animated:NO];
        [scrollView setContentOffset:CGPointMake(ScreenWidth* 3,0)];
    }
   
    currentIndex=currentPage+1;
  
    [switchView swipeAction:(100+currentPage+1)];
    
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==11) {
        
        return self.allDynamicFrames.count;
    }else if (tableView.tag==12){
    return 31;
    
    }else if (tableView.tag==13){
        return 41;
        
    }else if (tableView.tag==14){
        
        return 21;
    }
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==11) {
        
    ZSAllDynamicCell *cell = [ZSAllDynamicCell cellWithTableView:tableView];
    
    //*模型赋值数据*/
    cell.allDynamicFrame = self.allDynamicFrames[indexPath.row];
        
    return cell;
     
     }else if (tableView.tag==12){
        
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
             if (cell == nil) {
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
                 cell.contentView.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
                 cell.selectionStyle=UITableViewCellSelectionStyleNone;
                 UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
                 [cell.contentView addSubview:lineView];
                 lineView.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
             }

            cell.textLabel.numberOfLines=0;
             return cell;
             
         
     
     }else if (tableView.tag==13){
         
         ZSNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id1"];
         
         
         if (cell == nil) {
             cell = [[ZSNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id1"];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
             
             
         }
         // Configure the cell...
         return cell;
         
         
         
     }else if (tableView.tag==14){
         
         
         ZSNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id1"];
         
         
         if (cell == nil) {
             cell = [[ZSNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id1"];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
             
             
         }
         // Configure the cell...
         return cell;
         
     }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==11) {

        return [self.allDynamicFrames[indexPath.row] cellHeight];
        
    }else if (tableView.tag==12){
        return 170;
        
    }else if (tableView.tag==13){
        return 100;
        
    }else if (tableView.tag==14){
        
        return 100;
    }
    return 11;
}

- (void)dealloc
{
    ZSLog(@"delloc");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
