//
//  ZSWLostViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/9.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSWLostViewController.h"
#import "ZSComposePictrueView.h"
#import "UpYun.h"
#import "ZSHttpTool.h"
#import "UIBarButtonItem+Extension.h"
#import "SVProgressHUD.h"
#import "ZSWTextView.h"

#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]
#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSWLostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>


/** 图片名字数组*/
@property (nonatomic, strong) NSArray *imageArray;

/** 物品*/
@property (weak, nonatomic) UITextField *thingLabel;

/** 地点*/
@property (weak, nonatomic) UITextField *adressLabel;


/** 联系电话*/
@property (weak, nonatomic) UITextField *phoneLabel;

/**
 *  pictureView 相册
 */
@property (nonatomic, weak) ZSComposePictrueView *pictureView;

@property (weak, nonatomic)  UIScrollView *scroView;

/** 登陆按钮*/
@property (nonatomic, weak) UIButton *loginBtn;

/** 物品描述*/
@property (nonatomic, weak) ZSWTextView *sumaryTextView;

@end

@implementation ZSWLostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self initNav];
    
    
    //添加物品描述
    [self settingDes];
    
    //添加相册
    [self setPictureView];

    // 1.addTarget
    [self.thingLabel addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneLabel addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    //添加监听
    [self textChange];
    
}

- (void)settingDes
{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    
    CGFloat margin = 20;
    
    UIScrollView *scroView = [[UIScrollView alloc] init];
    scroView.x = 0;
    scroView.y = 0;
    scroView.width = ZSScreenW;
    scroView.height = ZSScreenH;
    [self.view addSubview:scroView];
    self.scroView = scroView;
    self.scroView.backgroundColor = [UIColor lightGrayColor];
    self.scroView.bounces = NO;
    self.scroView.showsHorizontalScrollIndicator = NO;
    self.scroView.alwaysBounceHorizontal = NO;
    self.scroView.contentSize = CGSizeMake(0, ZSScreenH + 200);
    scroView.delegate = self;
    
    UITextField *thingLabel = [[UITextField alloc] init];
    thingLabel.width = ZSScreenW -2 * margin;
    thingLabel.height = 30;
    thingLabel.x = margin;
    thingLabel.y = 30;
    self.thingLabel = thingLabel;
    thingLabel.backgroundColor = [UIColor whiteColor];
    thingLabel.placeholder = @"*物品";
//    thingLabel.attributedPlaceholder = dict;
    [self.scroView addSubview:thingLabel];
    
    UITextField *addresLabel = [[UITextField alloc] init];
    addresLabel.width = thingLabel.width;
    addresLabel.height = 30;
    addresLabel.x = thingLabel.x;
    addresLabel.y = CGRectGetMaxY(thingLabel.frame) + margin;
    self.adressLabel = addresLabel;
    addresLabel.placeholder = @"地点";
    addresLabel.backgroundColor = [UIColor whiteColor];
    [self.scroView addSubview:addresLabel];
    

    //添加带有placeholder的textView
    ZSWTextView *textView = [[ZSWTextView alloc] init];
    textView.x = thingLabel.x;
    textView.y = CGRectGetMaxY(addresLabel.frame) + margin;
    textView.width = thingLabel.width;
    textView.height = 100;
    self.sumaryTextView = textView;
    textView.delegate = self;
    textView.placeHolder = @"写下你丢的或捡的东西的描述...";
    [self.scroView addSubview:textView];
    
    //电话
    UITextField *phoneLabel = [[UITextField alloc] init];
    phoneLabel.width = thingLabel.width;
    phoneLabel.height = 30;
    phoneLabel.x = thingLabel.x;
    phoneLabel.y = CGRectGetMaxY(textView.frame) + margin;
    self.phoneLabel = phoneLabel;
    phoneLabel.backgroundColor = [UIColor whiteColor];
    phoneLabel.placeholder = @"*电话";
    [self.scroView addSubview:phoneLabel];
    
    //相册
    ZSComposePictrueView *pictureView = [[ZSComposePictrueView alloc] init];
    pictureView.width = self.view.width - 120;
    pictureView.height = self.view.height;
    pictureView.y = CGRectGetMaxY(self.phoneLabel.frame) + 15;
    [self.scroView addSubview:pictureView];
    self.pictureView = pictureView;

    //发表按钮
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.width = 50;
    sendBtn.height = 30;
    sendBtn.x = ZSScreenW - sendBtn.width - 15;
    sendBtn.y = CGRectGetMaxY(self.phoneLabel.frame) + 40;
    [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [self.scroView addSubview:sendBtn];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.loginBtn = sendBtn;

    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
}


- (void)textChange
{
    // 判断两个文本框的内容
    //    self.   .enabled = _accountField.text.length && _pwdField.text.length;
    self.loginBtn.enabled = _thingLabel.text.length && _phoneLabel.text.length;
}


/**
 * 初始化导航栏
 */
- (void)initNav
{
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImage:@"camera" highLightImage:@"" target:self action:@selector(openCamera)];
    
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImage:@"album" highLightImage:@"" target:self action:@selector(openAlbum)];
    
    self.navigationItem.rightBarButtonItems = @[item2 ,item1];
    
    self.title = @"写下来";
    
}

/** 相册*/

- (void)setPictureView
{
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
    
    
    ZSLog(@"weqweqqqqqq");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nickname"] = nickName;
    params[@"key"] = key;
    
    params[@"thing"] = [NSString stringWithFormat:@"#%@#", self.thingLabel.text];

    params[@"summary"] = self.sumaryTextView.text;
    params[@"adress"] = self.adressLabel.text;
    params[@"date"] = [self getTimeStr];
    params[@"phone"] = self.phoneLabel.text;
    
    //图片名字
    NSString *path = [self getImageName];
    
    //传递属性参数
    params[@"pic"] = [NSString stringWithFormat:@"[%@]", path];
    
    
    NSInteger count = [[self.pictureView addPictrues] count];
    
    if (count == 0) {
        params[@"pic"] = @"[]";
    }
    
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=LostAndFound/LostAndFoundWrite" parameters:params success:^(id responseObject) {
        
        if ([responseObject[@"state"] integerValue] == 602) {
            
            [SVProgressHUD showInfoWithStatus:@"您的账号在其它机器登陆，请注销重新登陆"];
            
        }else if ([responseObject[@"state"] integerValue] == 100) {
            
            //发送图片
            for (int i = 0; i < count; i ++) {
                
                UIImage *picture = [self.pictureView addPictrues][i];
                NSString *picturePath = self.imageArray[i];
                [self sendImageWithImage:picture imagePath:picturePath];
                
            }
        
            [SVProgressHUD showSuccessWithStatus:@"发表成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        
        } else if ([responseObject[@"state"] integerValue] == 204) {
            
            [SVProgressHUD showInfoWithStatus:@"电话只能够填数字！"];
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"发表失败！请连接网络"];
    }];
    
}

#pragma mark - textView的代理方法

- (void)textViewDidChange:(UITextView *)textView
{
    self.sumaryTextView.placeHolder = textView.hasText ? @"写下你丢的或捡的东西的描述..." : @"";
}

#pragma mark - UItextFild的代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

#pragma mark - UISCroView的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
