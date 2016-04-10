//
//  ZSCommenViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/22.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSCommenViewController.h"
#import "ZSAllDynamicFrame.h"
#import "ZSHttpTool.h"
#import "ZSAllDynamicCell.h"
#import "ZSAllDynamic.h"
#import "ZSComment.h"
#import "UIImageView+WebCache.h"
#import "ZSCommentViewCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]
#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSCommenViewController () <UITableViewDelegate, UITableViewDataSource>

- (IBAction)send;
/** 工具条距离底部的间距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomSpace;

/** 内容显示*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextFild;

/**cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;

/** 模型数组*/
@property (nonatomic, strong) NSArray *comments;

/**判断是否为第一次进来*/
@property (nonatomic, assign) BOOL isFirstCome;

@end


static NSString * const commentID = @"commentCell";

@implementation ZSCommenViewController

///** 懒加载*/
//- (NSMutableArray *)contectComments
//{
//    if (_contectComments == nil) {
//        _contectComments = [NSMutableArray array];
//    }
//    return _contectComments;
//}


/** 懒加载*/
- (NSArray *)comments
{
    if (_comments == nil) {
        _comments = [NSArray array];
    }
    return _comments;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameWillDidChanded:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //初始化headerView
    [self initHeaderView];
    
    //注册cell
    [self initCell];
    
    //添加刷新框架
    [self addRefresh];
    
    
    
}

- (void)addRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewComments)];
    
    [self.tableView headerBeginRefreshing];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    self.tableView.footerHidden = YES;
}

-(void)loadNewComments
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.allDynamicFrame.allDynamic.ID;
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/commentRead" parameters:params success:^(id responseObject) {
        
        NSArray *comments = responseObject[@"data"];
        
        ZSLog(@"%@", responseObject[@"data"]);
        self.comments = [ZSComment objectArrayWithKeyValuesArray:comments];
        
        //刷新表格
        [self.tableView reloadData];
        
        //重新计算评论数量
        int countNum = [self.allDynamicFrame.allDynamic.commentNum intValue];
        
        ZSLog(@"%d", self.isFirstCome);
        
        //先刷新， 在跳到
        [self.tableView headerEndRefreshing];
        
        if (countNum != 0 && self.isFirstCome) {
        
            self.isFirstCome = YES;
            //设置tableview默认选中行
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(countNum - 1) inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
            
    } failure:^(NSError *error) {
        
        
        [self.tableView headerEndRefreshing];
        
    }];
    
}

- (void)loadMoreData
{
    self.tableView.footerHidden = NO;
    
    
    ZSLog(@"1111");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView footerEndRefreshing];
    });
}



/** initCell*/
- (void)initCell
{
    
    //设置tableView的高度
    //cell的高度的估测值
    self.tableView.estimatedRowHeight = 44;
    //iOS8才开始有
    //自动算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZSCommentViewCell class]) bundle:nil] forCellReuseIdentifier:commentID];
    
}

/** 初始化headerView*/
- (void)initHeaderView
{
    ZSAllDynamicCell *headerView = [[ZSAllDynamicCell alloc] init];
    
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.allDynamicFrame = self.allDynamicFrame;
    headerView.x = 0;
    headerView.y = 0;
    headerView.width = self.view.width;
    headerView.height = self.allDynamicFrame.cellHeight;
    self.tableView.tableHeaderView = headerView;
    
}


- (void)keyBoardFrameWillDidChanded:(NSNotification *)notification
{
    //拿到键盘最后的frame
    CGRect rect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //设置限制约束
    self.buttomSpace.constant = ZSScreenH - rect.origin.y;
    
//    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:0.2 animations:^{
       
        [self.view layoutIfNeeded];
    }];
    
}

/** 发送评论*/

- (IBAction)send {
    
    self.isFirstCome = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    ZSAllDynamic *dynamic = self.allDynamicFrame.allDynamic;
    
    //对谁评论
    params[@"id"] = dynamic.ID;
    
    //当前要评论的人
    params[@"nickname"] = nickName;
    params[@"key"] = key;
    params[@"to"] = @(55);
    params[@"comment"] = self.inputTextFild.text;
    params[@"date"] = [self getTimeStr];
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/CommentWrite" parameters:params success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        
        //加载数据 刷新表格
        [self loadNewComments];
        
        //退出键盘
        [self.view endEditing:YES];
        
        //清空textFild内容为空
        self.inputTextFild.text = nil;
        
        //告诉其他控制器显示新的评论数量
        if ([self.delegate respondsToSelector:@selector(loadNewData)]) {
            
            [self.delegate loadNewData];
        }

        //重新计算评论数量
        int countNum = [self.allDynamicFrame.allDynamic.commentNum intValue];
        countNum ++;
        self.allDynamicFrame.allDynamic.commentNum = [NSString stringWithFormat:@"%d", countNum];
        
        [self initHeaderView];
        
    } failure:^(NSError *error) {
       
        [SVProgressHUD showSuccessWithStatus:@"评论失败"];
        
    }];
    
}


/** 获得时间的字符串*/

- (NSString *)getTimeStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    //设置日期格式
    //如果是真机调试 转换这种欧美时间 需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"cn"];
    fmt.dateFormat = @" M月dd日 HH:mm";
    //创建时间的日期
    NSString *createDate = [fmt stringFromDate:date];
    return createDate;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSCommentViewCell *cell = [ZSCommentViewCell tableViewCell];
    
    cell.comment = self.comments[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"最新评论";
}



@end
