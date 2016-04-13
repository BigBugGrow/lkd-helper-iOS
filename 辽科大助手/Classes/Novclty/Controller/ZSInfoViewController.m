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

@end

@implementation ZSInfoViewController


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载个人信息
    [self loadUserInfo];
    
    //初始化tableView
    [self initHeaderView];
    
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
        
        [self initModelData];
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"加载跟人信息失败，请检查网络"];
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.backBtn removeFromSuperview];
//    [self.writeInffoBtn removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置按钮
    [self settingNavBtn];
    
    self.navigationController.navigationBarHidden = YES;
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
    
    [window addSubview:backBtn];

}


//初始化模型数据
- (void)initModelData
{
    //去掉分界线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //标题
    
    ZSModel *item0 = [ZSModel itemWithIcon:@"zhj" title:@"学号" detailTitle:self.user.zjh];
    self.title = [NSString stringWithFormat:@"%@的信息", self.whoNickName];
    
    ZSModel *item1 = [ZSModel itemWithIcon:@"name" title:@"姓名" detailTitle:self.user.name];
    
    ZSModel *item2 = [ZSModel itemWithIcon:@"sex" title:@"性别" detailTitle:self.user.sex];
    ZSModel *item3 = [ZSModel itemWithIcon:@"class" title:@"班级" detailTitle:self.user.class];
    
    ZSModel *item4 = [ZSModel itemWithIcon:@"major" title:@"专业" detailTitle:self.user.major];
    ZSModel *item5 = [ZSModel itemWithIcon:@"college" title:@"学院" detailTitle:self.user.college];
    ZSModel *item6 = [ZSModel itemWithIcon:@"home" title:@"故乡" detailTitle:self.user.home];
    
    ZSGroupModel *group1 = [[ZSGroupModel alloc] init];
    group1.items = @[item0,item1,item2,item3, item4, item5, item6];
    [self.cellData addObject:group1];
    
    
    NSString *phone = self.user.phone;
    NSString *qq = self.user.qq;
    NSString *wechat = self.user.wechat;
    if ([phone isEqualToString:@"暂无"] && [self.whoNickName isEqualToString:nickName]) {
      
        phone = @"添加";
    }
    if ([qq isEqualToString:@"暂无"] && [self.whoNickName isEqualToString:nickName]) {
        
        qq = @"添加";
    }
    if ([wechat isEqualToString:@"暂无"] && [self.whoNickName isEqualToString:nickName]) {
        
        wechat = @"添加";
    }
    
    ZSModel *item7 = [[ZSModel alloc] init];
    
    ZSModel *item8 = [[ZSModel alloc] init];
    
    ZSModel *item9 = [[ZSModel alloc] init];
    
    if ([self.whoNickName isEqualToString:nickName]) {
        
        item7 = [ZSModel itemWithIcon:@"phone1" title:@"电话" detailTitle:phone vcClass:[ZSSendInfoViewController class]];
        item8 = [ZSModel itemWithIcon:@"qq" title:@"QQ" detailTitle:qq vcClass:[ZSSendInfoViewController class]];
        
        item9 = [ZSModel itemWithIcon:@"weichat" title:@"微信号" detailTitle:wechat vcClass:[ZSSendInfoViewController class]];
    } else {
        item7 = [ZSModel itemWithIcon:@"phone1" title:@"电话" detailTitle:phone];
        item8 = [ZSModel itemWithIcon:@"qq" title:@"QQ" detailTitle:qq];
        
        item9 = [ZSModel itemWithIcon:@"weichat" title:@"微信号" detailTitle:wechat ];

    }
    
    ZSGroupModel *group2 = [[ZSGroupModel alloc] init];
    
    group2.items = @[item7, item8, item9];
    [self.cellData addObject:group2];

}

#pragma mark - tableViewDelelgate 代理方法

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"在校信息";
    } else {
        
         if ([self.whoNickName isEqualToString:nickName]) {
             return @"联系方式   (点击可修改)";
         }
        return @"联系方式";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ZSScreenW, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = RGBColor(242, 242, 242, 1);
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(5, 0.0, ZSScreenW, 44.0);
    
    if (section == 0) {
        headerLabel.text =   @"在校信息";
    }else if ([self.whoNickName isEqualToString:nickName]) {
        headerLabel.text = @"联系方式   (点击可修改)";
    } else {
        headerLabel.text = @"联系方式";
    }
     customView.backgroundColor = RGBColor(242, 242, 242, 1);
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

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
    if ([self.whoNickName isEqualToString:nickName] && [self GetImageFromLocal:ZSIconImageStr]) {
        
        myImage.image = [self GetImageFromLocal:ZSIconImageStr];
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

- (void)clickWriteInfoBtn
{
//    ZSSendInfoViewController *sendInfoViewController = [[ZSSendInfoViewController alloc] init];
    
//    self.navigationController.navigationBarHidden = NO;
    
//    [self.navigationController pushViewController:sendInfoViewController animated:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
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
    
        [UIView animateWithDuration:0.01 animations:^{
            self.navigationController.navigationBarHidden = NO;
            self.backBtn.hidden = YES;
//            self.writeInffoBtn.hidden = YES;
        }];
        
    } else {
        
        //隐藏导航栏
            self.navigationController.navigationBarHidden = YES;
            self.backBtn.hidden = NO;
//            self.writeInffoBtn.hidden = NO;
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
    
    
    __block UpYun *uy = [[UpYun alloc] init];
//
//    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            ZSLog(@"response body %@", responseData);
//    };
//    uy.failBlocker = ^(NSError * error) {
//        NSString *message = [error.userInfo objectForKey:@"message"];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        ZSLog(@"error %@", message);
//    };
//    
    
    NSString *pictruePath = [NSString stringWithFormat:@"/picUser/%@.jpg", imageName];
    
    [uy uploadImage:image savekey:pictruePath];
    
    //删除缓存
    [self clearTmpPics];
    
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

#pragma mark - UIImagePickerControllerDelegate
/**
 *  从UIImagePickerControllerDelegate选择图片后就调用（拍完照完毕或者选择相册图片完毕）
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //拿出info中包含选择的图片
    UIImage *picture = info[UIImagePickerControllerOriginalImage];
    
    CGFloat imageWidth = picture.size.width;
    CGFloat imageHeight = picture.size.height;
    
    CGFloat newImageWidth, newImageHeight;
    
    if (imageWidth >= imageHeight) {
        
        newImageWidth = imageWidth >= 500 ? 500 : imageWidth;
        newImageHeight = newImageWidth / imageWidth * imageHeight;
    } else {
        newImageHeight = imageHeight >= 500 ? 500 : imageHeight;
        newImageWidth = newImageHeight / imageHeight  * imageWidth;
        
    }
    
    ZSLog(@"%@", NSStringFromCGSize(picture.size));
    //图片压缩
    UIImage *newImage = [self imageByScalingAndCroppingForSize:CGSizeMake(newImageWidth, newImageHeight) image:picture];
    
    ZSLog(@"%@", NSStringFromCGSize(newImage.size));
   
    //清除缓存图片
    [self clearTmpPics];
    
    self.iconView.image = newImage;
    
    self.bigImageView.image = newImage;
    
    //上传图片
    [self sendImageWithImage:newImage imageName:nickName];
    
    //保存图片
    [self SaveImageToLocal:newImage Keys:ZSIconImageStr];
    
    //创建通知
    //创建一个消息对象
//    NSNotification * notice = [NSNotification notificationWithName:@"swapImage" object:nil ];
//    //发送消息
//    [ZSNotificationCenter postNotification:notice];
    
    [ZSNotificationCenter postNotificationName:@"swapImage" object:nil];
    
}

/** 图片压缩*/
//图片压缩到指定大小
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 保存图片

//将图片保存到本地
- (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//本地是否有相关图片
- (BOOL)LocalHaveImage:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
- (UIImage*)GetImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        ZSLog(@"未从本地获得图片");
    }
    return image;
}

- (void)clearTmpPics
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无

}



@end
