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
#import "UIBarButtonItem+Extension.h"

#import "ZSMyNovcltyViewController.h"
#import "ZSLoginViewController.h"
#import "ZSNavigationController.h"
#import "ZSAccountTool.h"
#import "ZSAboutViewController.h"
#import "ZSMyLostAndThingViewController.h"
#import "ZSStudentNumBindViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface ZSProfileViewController ()<UIAlertViewDelegate>

@end

@implementation ZSProfileViewController


+ (void)initialize
{
    //1.创建本地通知对对象
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    
    //指定通知发送的时间
    noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    //指定时区
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.alertBody = @"马上要上课喽";
    
    noti.repeatInterval = NSCalendarUnitMinute;
    noti.alertAction = @"查看消息";
    noti.alertLaunchImage = @"splash_tops";
    noti.soundName = @"sendmsg.caf";
    
    
    //2注册通知
    UIApplication *app = [UIApplication sharedApplication];
    
    [app scheduleLocalNotification:noti];
    
    ZSLog(@"333");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    ZSLog(@"%@", NSHomeDirectory());
    
    
    NSString *path = [self getCachesPath];
    
    long long sizeM = [self fileSizeAtPath:path];
    
    ZSLog(@"%lld", sizeM);
    
    
    //设置导航按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setUpTableHeaderView:@"ZSProfileImageCell"];
    
    
    [self initModelData];
}



- (void)clickRightBtn
{
    
    [self clearTmpPics];
    
    NSString *path = [self getCachesPath];
    
    long long sizeM = [self fileSizeAtPath:path];
    
    ZSLog(@"%lld", sizeM);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出当前账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        ZSLoginViewController *loginViewVC = [[ZSLoginViewController alloc] init];
        
        ZSNavigationController *nav = [[ZSNavigationController alloc] initWithRootViewController:loginViewVC];
        
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
            //清空账号
            [ZSAccountTool saveAccount:nil];
            //清空头像
            [self SaveImageToLocal:nil Keys:ZSIconImageStr];
            
        }];
        
        
    }];
    
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:okAction];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)clearTmpPics
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
}

//将图片保存到本地
- (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//获取缓存文件路径
-(NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    ZSLog(@"%@", paths);
    
    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    
    return filePath;
}
///计算缓存文件的大小的M
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
//初始化模型数据
- (void)initModelData
{
    
    ZSModel *item1 = [ZSModel itemWithIcon:@"mynovelty" title:@"我的糯米粒" detailTitle:@"" vcClass:[ZSMyNovcltyViewController class]];
    ZSModel *item2 = [ZSModel itemWithIcon:@"mylost_found" title:@"我的寻物公告" detailTitle:@"" vcClass:[ZSMyLostAndThingViewController class]];
    
    ZSGroupModel *group1 = [[ZSGroupModel alloc] init];
    group1.items = @[item1,item2];
    [self.cellData addObject:group1];
    
    
    
    ZSModel *item3 = [ZSModel itemWithIcon:@"setting" title:@"学号绑定" detailTitle:@"" vcClass:[ZSStudentNumBindViewController class]];
//    ZSModel *item4 = [ZSModel itemWithIcon:@"lock1" title:@"设置" detailTitle:@""];
    ZSModel *item5 = [ZSModel itemWithIcon:@"ring" title:@"不提醒上课" detailTitle:@""];
    
    
    // 解决循环引用， 内存泄露问题
    __unsafe_unretained ZSModel *item55 = item5;
    
    item5.operation = ^(){
        if ([item55.title isEqualToString:@"提醒上课"]) {
            item55.title = @"不提醒上课";
            item55.icon = @"ring";
            [self.tableView reloadData];
            
            //1.创建本地通知对对象
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            
            //指定通知发送的时间
            noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            //指定时区
            noti.timeZone = [NSTimeZone defaultTimeZone];
            noti.alertBody = @"马上要上课喽";
            
            noti.repeatInterval = NSCalendarUnitMinute;
            noti.alertAction = @"查看消息";
            noti.alertLaunchImage = @"splash_tops";
            noti.soundName = @"sendmsg.caf";
            
            
            //2注册通知
            UIApplication *app = [UIApplication sharedApplication];
            
            [app scheduleLocalNotification:noti];
            
        } else {
            item55.title = @"提醒上课";
            item55.icon = @"quiet";
            [self.tableView reloadData];

            UIApplication *app = [UIApplication sharedApplication];
            
            [app cancelAllLocalNotifications];
        }
    };
    
    
    ZSModel *item6 = [ZSModel itemWithIcon:@"about" title:@"关于辽科大助手" detailTitle:@"" vcClass:[ZSAboutViewController class]];
    
    ZSModel *item7 = [ZSModel itemWithIcon:@"clearCache" title:@"清除缓存" detailTitle:@""];
    ZSGroupModel *group2 = [[ZSGroupModel alloc] init];
    group2.items = @[item3,item5,item7,item6];
    [self.cellData addObject:group2];
    
    item7.operation = ^(){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除缓存？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"立即清除" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
            
            
            NSString *path = [self getCachesPath];
            
            long long sizeM = [self fileSizeAtPath:path];
            
            ZSLog(@"%lld", sizeM);
            
            NSString *msg = [NSString stringWithFormat:@"已清除缓存%.1lfM", sizeM / 1000.0];
            
            [SVProgressHUD showSuccessWithStatus:msg];
            
            [self clearTmpPics];
            
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:fromPhotoAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    };
    
    
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
