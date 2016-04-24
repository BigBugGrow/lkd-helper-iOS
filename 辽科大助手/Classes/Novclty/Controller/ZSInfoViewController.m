//
//  ZSProfileViewController.m
//  辽科大助手
//
//  Created by DongAn on 15/11/28.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSInfoViewController.h"
#import "ZSTableViewCell.h"
#import "ZSModel.h"
#import "ZSGroupModel.h"
#import "UIImageView+WebCache.h"
#import "ZSAccountTool.h"
#import "ZSAccount.h"
#import "ZSHttpTool.h"
#import "ZSPersonalUser.h"
#import "ZSSendInfoViewController.h"
#import "SVProgressHUD.h"
#import "UpYun.h"
#import "ZSInfoViewCell.h"
#import "MBProgressHUD+MJ.h"

#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSInfoViewController ()<UINavigationControllerDelegate ,UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UIButton *backBtn;

//@property (nonatomic, weak) UIButton *writeInffoBtn;

/**头像的view*/
@property (nonatomic, weak) UIImageView *iconView;

/** 头*/
@property (nonatomic, weak) UIView *headerView;

/** 大图片*/
@property (nonatomic, weak) UIImageView *bigImageView;

/**user对象*/
@property (nonatomic, strong) ZSPersonalUser *user;

@property (nonatomic, weak) UIButton *moreBtn;

@end

@implementation ZSInfoViewController


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

static NSString *ID = @"infoCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的信息", self.whoNickName];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZSInfoViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //加载个人信息
    [self loadUserInfo];
    
    //初始化tableView
    [self initHeaderView];

    self.navigationController.navigationBar.subviews[0].backgroundColor = [UIColor whiteColor];
    
    //
    [UIView animateWithDuration:1.0 animations:^{
        
        self.navigationController.navigationBar.hidden = YES;
    }];
    
}


//加载跟人信息
- (void)loadUserInfo
{
    ZSAccount *account = [ZSAccountTool account];
    
    ZSPersonalUser *user = [[ZSPersonalUser alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"nickname"] = self.whoNickName ? self.whoNickName : nickName;
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/userInfoRead" parameters:params success:^(NSDictionary *responseObject) {
        
        
        user.sex = [responseObject[@"sex"] isEqualToString:@"boy"] ? @"男" : @"女";
        user.name = self.whoNickName == nickName ? account.name : @"保密";
        user.college = self.whoNickName == nickName ? account.college : responseObject[@"college"];
        user.major = self.whoNickName == nickName ? account.major : responseObject[@"major"];
        user.class = self.whoNickName == nickName ? account.Class : responseObject[@"class"];
        user.home = self.whoNickName == nickName ? account.home : responseObject[@"home"];
        user.birthday = self.whoNickName == nickName ? account.birthday : responseObject[@"birthday"];
        user.phone = responseObject[@"phone"];
        user.qq = responseObject[@"qq"];
        user.wechat = responseObject[@"wechat"];
        user.zjh = self.whoNickName == nickName ? account.zjh : @"保密";;
        self.user = user;
        
//        [self initModelData];
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"加载跟人信息失败，请检查网络"];
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    
    [self.moreBtn removeFromSuperview];
    [self.backBtn removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //加载个人信息
    [self loadUserInfo];
    
    //设置按钮
    [self settingNavBtn];
    
}


- (void)settingNavBtn
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    //返回按钮
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [backBtn setImage:[UIImage imageNamed:@"rightBack"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(130, 40);
    //设置按钮的内容靠左边
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //设置按钮的切割
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    backBtn.x = 20;
    backBtn.y = 25;
    
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [backBtn addTarget:self action:@selector(exitViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = backBtn;
    
    //如果导航栏没有隐藏， 就隐藏返回按钮
    if (!self.navigationController.navigationBarHidden) {
        
        self.backBtn.hidden = YES;
    }
    
    //更多信息按钮
    UIButton *moreBtn = [[UIButton alloc] init];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    moreBtn.size = CGSizeMake(40, 30);
    //设置按钮的内容靠左边
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //设置按钮的切割
    moreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    moreBtn.x = ZSScreenW - moreBtn.width;
    moreBtn.y = 25;
    
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [moreBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.moreBtn = moreBtn;
    
    [window addSubview:self.moreBtn];
    
    [window addSubview:backBtn];

}


#pragma mark - tableViewDelelgate 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 7;
    }
    
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"在校信息";
    } else {
        
        return @"联系方式";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSInfoViewCell *cell = [ZSInfoViewCell tableViewCell];
    
    ZSLog(@"%@", cell);
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
    
            cell.nameLabel.text = @"学号";
            cell.detail.text = self.user.zjh;
            
        } else if(indexPath.row == 1) {
            
            cell.nameLabel.text = @"姓名";
            cell.detail.text = self.user.name;
            
        } else if(indexPath.row == 2) {
            
            cell.nameLabel.text = @"性别";
            cell.detail.text = self.user.sex;
            
        }else if(indexPath.row == 3) {
            
            cell.nameLabel.text = @"班级";
            cell.detail.text = self.user.class;
            
        }else if(indexPath.row == 4) {
            
            cell.nameLabel.text = @"专业";
            cell.detail.text = self.user.major;
            
        }else if(indexPath.row == 5) {
            
            cell.nameLabel.text = @"学院";
            cell.detail.text = self.user.college;
            
        }else if(indexPath.row == 6){
            
            cell.nameLabel.text = @"故乡";
            cell.detail.text = self.user.home;
            
        }
        
    } else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            cell.nameLabel.text = @"电话";
            cell.detail.text = self.user.phone;
            
        } else if(indexPath.row == 1) {
            
            cell.nameLabel.text = @"微信";
            cell.detail.text = self.user.wechat;
            
        } else if(indexPath.row == 2) {
            
            cell.nameLabel.text = @"QQ";
            
            cell.detail.text = self.user.qq;
            
        }
    }
    
    return cell;
}


#pragma mark - 自定义headerView
/** 初始化headerView*/
- (void)initHeaderView
{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //headerView的大背景
    UIView *headerView = [[UIView alloc] init];
    headerView.width = ZSScreenW;
    headerView.height = 300;
    headerView.x = 0;
    headerView.y = 0;
    
    headerView.userInteractionEnabled = YES;
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swapImage:)]];
    
    self.headerView = headerView;
    //大图片
    UIImageView *myImage = [[UIImageView alloc] init];
    myImage.width = ZSScreenW;
    myImage.height = 270;
    myImage.x = 0;
    myImage.y = -20;
    
    
    myImage.backgroundColor = RGBColor(234, 234, 234, 0.5);
    
    //网址
    NSString *urlStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", self.whoNickName];
    
    NSString *urlBigStr = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small", self.whoNickName];
    
    [myImage sd_setImageWithURL:[NSURL URLWithString:urlBigStr]];
    myImage.backgroundColor = [UIColor blackColor];
    [headerView addSubview:myImage];
    
    self.bigImageView = myImage;
    self.tableView.tableHeaderView = headerView;
    
    //边界宽度
    CGFloat marginWidth = 20;
    
    //小头像
    UIImageView *smallImageView = [[UIImageView alloc] init];
    
    //添加image点击事件
//    smallImageView.userInteractionEnabled = YES;
//    [smallImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swapImage)]];
//    
    
    smallImageView.width = 60;
    smallImageView.height = 60;
    smallImageView.x = ZSScreenW - marginWidth - smallImageView.width;
    smallImageView.y = myImage.height * 0.85;
    
    [smallImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *picture = smallImageView.image;
        
        //制作头像的圆形形状
        [smallImageView.layer setCornerRadius:CGRectGetHeight([smallImageView bounds]) / 2];
        smallImageView.layer.masksToBounds = YES;
        //        然后再给图层添加一个有色的边框，类似qq空间头像那样
        smallImageView.layer.borderWidth = 2;
        smallImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        smallImageView.image = picture;
        
    }];
    self.iconView = smallImageView;

    [myImage addSubview:smallImageView];
    
    //昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.width = 200;
    nameLabel.height = 30;
    nameLabel.x = smallImageView.x - marginWidth + 3 - nameLabel.width;
    nameLabel.y = CGRectGetMaxY(smallImageView.frame) - marginWidth - nameLabel.height;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.text = self.whoNickName;
    nameLabel.font = [UIFont systemFontOfSize:20 weight:5];
    nameLabel.textColor = [UIColor whiteColor];
    [myImage addSubview:nameLabel];
 
    //如果是自己的头像 本地还存有头像
    if ([self.whoNickName isEqualToString:nickName] && [UIImage GetImageFromLocal:ZSIconImageStr]) {
        
        myImage.image = [UIImage GetImageFromLocal:ZSIconImageStr];
        smallImageView.image = myImage.image;
    }
    
    
}

- (void)swapImage:(UITapGestureRecognizer *)tap
{
    
    if (![self.whoNickName isEqualToString:nickName]) return;
    
    
//    ZSLog(@"1111111111");
//    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开相机" otherButtonTitles:@"打开相册", nil];
//    
//    [sheet showInView:self.view];
//    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {                                                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //        imagePicker.allowsEditing = YES;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            //            imagePicker.allowsEditing = YES;
            imagePicker.allowsEditing = NO;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];


  
}

- (void)clickRightBtn
{
    
    ZSSendInfoViewController *info = [[ZSSendInfoViewController alloc] init];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:info animated:YES completion:nil];
    
}


- (void)exitViewController
{
    
    //除掉返回按钮
    [self.backBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

// scroView的代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y >= 190) {
    
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBarHidden = NO;
            self.backBtn.hidden = YES;
//            self.moreBtn.hidden = YES;
        }];
        
    } else {
        
        //隐藏导航栏
        [UIView animateWithDuration:0.05 animations:^{
            
            self.navigationController.navigationBarHidden = YES;
            self.backBtn.hidden = NO;
//            self.moreBtn.hidden = NO;
        }];
        
    }
    
}



/** 发送头像到又赔云*/

- (void)sendImageWithImage:(UIImage *)image imageName:(NSString *)imageName
{
    
    if (image == nil) return;
    
    //设置空间和秘钥
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = DEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = DEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].DEFAULT_EXPIRES_IN = 100;
    
    [MBProgressHUD showMessage:@"正在修改中..." toView:self.view];
    
    
    __block UpYun *uy = [[UpYun alloc] init];

    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        
        [SVProgressHUD showSuccessWithStatus:@"修改头像成功"];
        
        //清除缓存图片
        [self clearTmpPics];
        
        self.iconView.image = image;
        
        self.bigImageView.image = image;
        
        //保存图片
        [UIImage SaveImageToLocal:image Keys:ZSIconImageStr];
        
        //创建通知
        //创建一个消息对象
        [ZSNotificationCenter postNotificationName:@"swapImage" object:nil];
        
        
        [MBProgressHUD hideHUDForView:self.view];
        

            ZSLog(@"response body %@", responseData);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        
        
        [MBProgressHUD hideHUDForView:self.view];
        [SVProgressHUD showErrorWithStatus:@"修改头像失败，请检查网络"];

        
        ZSLog(@"error %@", message);
    };
    
    
    NSString *pictruePath = [NSString stringWithFormat:@"/picUser/%@.jpg", imageName];
    
    [uy uploadImage:image savekey:pictruePath];
    
}

- (void)openCamera
{
    ZSLog(@"打开相机");
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    //    UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //获得所有图片
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)ImagePickerControllerSourceType
{
    //若相机在没摔坏 没故障的情况下，就打开相机
    if (![UIImagePickerController isSourceTypeAvailable:ImagePickerControllerSourceType]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = ImagePickerControllerSourceType;
    //监听她的图片
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

- (void)dealloc
{
    [ZSNotificationCenter removeObserver:self];
}


#pragma mark - 保存图片

- (void)clearTmpPics
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无

}

@end
