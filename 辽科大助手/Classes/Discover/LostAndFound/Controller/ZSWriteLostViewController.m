//
//  ZSWriteLostViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/6.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSWriteLostViewController.h"
#import "ZSComposePictrueView.h"
#import "UpYun.h"
#import "ZSHttpTool.h"
#import "UIBarButtonItem+Extension.h"
#import "SVProgressHUD.h"

#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]
#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSWriteLostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


/** 图片名字数组*/
@property (nonatomic, strong) NSArray *imageArray;

/** 物品*/
@property (weak, nonatomic) IBOutlet UITextField *thingLabel;

/** 地点*/
@property (weak, nonatomic) IBOutlet UITextField *adressLabel;

/** 物品描述*/
@property (weak, nonatomic) IBOutlet UITextView *sumaryTextView;

/** 联系电话*/
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;

/**
 *  pictureView 相册
 */
@property (nonatomic, weak) ZSComposePictrueView *pictureView;

/** 登陆按钮*/
@property (nonatomic, weak) UIButton *loginBtn;

@end

@implementation ZSWriteLostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self initNav];
    
    //添加相册
    [self setPictureView];

    //添加发表按钮
    [self setSendBtn];
    
    // 1.addTarget
    [self.thingLabel addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneLabel addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //添加监听
    [self textChange];
    
}

- (void)textChange
{
    // 判断两个文本框的内容
//    self.   .enabled = _accountField.text.length && _pwdField.text.length;
    self.loginBtn.enabled = _thingLabel.text.length && _phoneLabel.text.length;
}


- (void)setSendBtn
{
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.width = 100;
    sendBtn.height = 30;
    sendBtn.x = ZSScreenW - sendBtn.width - 15;
    sendBtn.y = CGRectGetMaxY(self.phoneLabel.frame) + 40;
    [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [self.view addSubview:sendBtn];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateHighlighted];
    [sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.loginBtn = sendBtn;
}

/**
 * 初始化导航栏
 */
- (void)initNav
{
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImage:@"compose_camerabutton_background" highLightImage:@"" target:self action:@selector(openCamera)];
    
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImage:@"compose_toolbar_picture" highLightImage:@"" target:self action:@selector(openAlbum)];
    
    self.navigationItem.rightBarButtonItems = @[item2 ,item1];
    
    self.title = @"寻物启事";
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/** 相册*/

- (void)setPictureView
{
    ZSComposePictrueView *pictureView = [[ZSComposePictrueView alloc] init];
    pictureView.width = self.view.width;
    pictureView.height = self.view.height;
    pictureView.y = CGRectGetMaxY(self.phoneLabel.frame) + 15;
    [self.view addSubview:pictureView];
    self.pictureView = pictureView;
}



//打开相机
- (void)openCamera
{
    ZSLog(@"打开相机");
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}


//代开相册
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
    
    [self.pictureView addPicture:newImage];
    
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


- (void)sendImageWithImage:(UIImage *)image imagePath:(NSString *)imagePath
{
    //设置空间和秘钥
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = DEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = DEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].DEFAULT_EXPIRES_IN = 1000;
    
    __block UpYun *uy = [[UpYun alloc] init];
//    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        ZSLog(@"response body %@", responseData);
//    };
//    
//    uy.failBlocker = ^(NSError * error) {
//        NSString *message = [error.userInfo objectForKey:@"message"];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        ZSLog(@"error %@", message);
//    };
    
    /**
     *	@brief	根据 UIImage 上传
     */
    
    NSString *pictruePath = [NSString stringWithFormat:@"/picLostAndFound/%@.jpg", imagePath];
    
    [uy uploadImage:image savekey:pictruePath];
    
}

- (NSString * )getSaveKeywithSerialNum:(int)serialNum{
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    
    NSString *fileName = [NSString stringWithFormat:@"icon%@%d", [self getTimeImageStr], serialNum];
    
    return [NSString stringWithFormat:@"%@", fileName];
    
}


/** 获得图片名字*/
- (NSString *)getImageName
{
    
    //生成图片存储路径
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSInteger count = [[self.pictureView addPictrues] count];
    
    NSMutableString *path = [NSMutableString string];
    
    for (int i = 0; i < count; i++) {
        
        NSString *picturePath = [self getSaveKeywithSerialNum:i];
        
        [pathArray addObject:picturePath];
        
        if (i != count - 1) {
            
            [path appendFormat:@"%@,", picturePath];
            
        } else {
            
            [path appendFormat:@"%@", picturePath];
        }
    }
    
    self.imageArray = pathArray;
    
    return path;
}

/** 获得时间的字符串*/

- (NSString *)getTimeImageStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    //设置日期格式
    //如果是真机调试 转换这种欧美时间 需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"cn"];
    fmt.dateFormat = @"YYYYMMddhhmmss";
    //创建时间的日期
    NSString *createDate = [fmt stringFromDate:date];
    return createDate;
}


- (NSString *)getTimeStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    //设置日期格式
    //如果是真机调试 转换这种欧美时间 需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"cn"];
    fmt.dateFormat = @"M月dd日 HH:mm";
    //创建时间的日期
    NSString *createDate = [fmt stringFromDate:date];
    return createDate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSendBtn{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nickname"] = nickName;
    params[@"key"] = key;
    params[@"thing"] = self.thingLabel.text;
    params[@"summary"] = self.sumaryTextView.text;
    params[@"adress"] = self.adressLabel.text;
    params[@"date"] = [self getTimeStr];
    params[@"phone"] = self.phoneLabel.text;

    //图片名字
    NSString *path = [self getImageName];
    
    //传递属性参数
    params[@"pic"] = [NSString stringWithFormat:@"[%@]", path];
    
    
    NSInteger count = [[self.pictureView addPictrues] count];
    
    //发送图片
    for (int i = 0; i < count; i ++) {
        
        UIImage *picture = [self.pictureView addPictrues][i];
        NSString *picturePath = self.imageArray[i];
        [self sendImageWithImage:picture imagePath:picturePath];
        
    }
    
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=LostAndFound/LostAndFoundWrite" parameters:params success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"发表成功！"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"发表失败！"];
    }];
    
}

@end
