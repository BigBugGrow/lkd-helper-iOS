//
//  ZSComposeViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/1/12.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSComposeViewController.h"
#import "ZSEmotionTextView.h"
#import "NSDate+Convert.h"
#import "NSDate+Utilities.h"

#import "AFNetworking.h"
#import "ZSComposePictrueView.h"
#import "MBProgressHUD+MJ.h"
#import "ZSComposeToolBar.h"
#import "ZSEmotionKeyboard.h"
#import "ZSEmotionButton.h"
#import "ZSEmotion.h"
#import "UpYun.h"
#import "ZSHttpTool.h"

#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]
#define key [[NSUserDefaults standardUserDefaults] objectForKey:ZSKey]


@interface ZSComposeViewController ()<UIScrollViewDelegate, UITextViewDelegate, ZSComposeToolBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**
 *  textView 文本输入框
 */
@property (nonatomic, weak) ZSEmotionTextView *textView;
/**
 *  工具条
 */
@property (nonatomic, weak) ZSComposeToolBar *composeToolBar;

/**
 *  pictureView 相册
 */
@property (nonatomic, weak) ZSComposePictrueView *pictureView;
/**
 *  键盘工具条判断frame变不变
 */
@property (nonatomic, assign) BOOL isSystemKeyboard;

/** 图片名字数组*/
@property (nonatomic, strong) NSArray *imageArray;

/** 是否密名开关*/
@property (nonatomic, weak) UISwitch *switchView;

@end


@implementation ZSComposeViewController


#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏按钮
    [self setNav];
    
    //设置textView
    [self setTextView];
    
    //设置键盘工具条
    [self setKeyboardTool];
    
    //添加相册
    [self setPictureView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //让textView成为第一响应者
    [self.textView becomeFirstResponder];
    
}

#pragma mark - 初始化方法


- (void)setPictureView
{
    ZSComposePictrueView *pictureView = [[ZSComposePictrueView alloc] init];
    pictureView.width = self.view.width;
    pictureView.height = self.view.height;
    pictureView.y = 110;
    [self.textView addSubview:pictureView];
    self.pictureView = pictureView;
    
    
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.text = @"密名发表";
    label.font = [UIFont systemFontOfSize:14];
    label.width = 80;
    label.height = 30;
    label.x = ZSScreenW - label.width;
    label.y = 120;
    [self.view addSubview:label];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.x = label.x;
    switchView.y = CGRectGetMaxY(label.frame);
    
//    [switchView addTarget:self action:@selector(openSecret) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:switchView];
    self.switchView = switchView;

}

//- (void)openSecret
//{
//    ZSLog(@"change");
//    
//    if (self.switchView.isOn) {
//        [self.switchView setOn:YES];
//    } else {
//        [self.switchView setOn:NO];
//    }
//
//}

// 设置键盘工具条
- (void)setKeyboardTool
{
    ZSComposeToolBar *composeToolBar = [[ZSComposeToolBar alloc] init];
    //设置代理
    composeToolBar.delegate = self;
    composeToolBar.width = self.view.width;
    composeToolBar.height = 44;
    composeToolBar.y = self.view.height - composeToolBar.height - 66;
    
    [self.view addSubview:composeToolBar];
    self.composeToolBar = composeToolBar;
    
    //要想把工具条设置不会消失，就得把工具条放在view上
//    self.textView.inputAccessoryView = keyToolBar;
}


//设置textView
- (void)setTextView
{
    ZSEmotionTextView *textView = [[ZSEmotionTextView alloc] init];
    
    //设置textVIew垂直方向总是滚动
    textView.alwaysBounceVertical = YES;
    
    textView.delegate = self;
    
    NSString *placeHolder = nil;
    
    if ([self.type isEqualToString:@"all"]) {
        
        placeHolder = @"发动态...";
    } else if ([self.type isEqualToString:@"discloseBoard"]) {
         
        placeHolder = @"吐个槽 ...";
    } else if ([self.type isEqualToString:@"confessionWall"]) {
        placeHolder = @"表白 to who ...";
    } else {
        placeHolder = @"找个话题 ...";
    }

    textView.placeHolder = placeHolder;
    textView.font = [UIFont systemFontOfSize:15];
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    self.textView = textView;
    
    //通知textView变化
    [LBNotificationCenter addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:textView];
    
    //根据键盘的y值来设定工具条的位置
    [LBNotificationCenter addObserver:self selector:@selector(keyBoardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //点击表情按钮得到通知
    //根据键盘的y值来设定工具条的位置
    [LBNotificationCenter addObserver:self selector:@selector(didClickEmotionBtn:) name:LBDidClickEmotionButton object:nil];
    
    [LBNotificationCenter addObserver:self selector:@selector(clickDeleteButton) name:LBDidClickDeleteButton object:nil];
    
}

//点击了删除按钮
- (void)clickDeleteButton
{
    //删除表情
    [self.textView deleteBackward];
}

//点击表情按钮
- (void)didClickEmotionBtn:(NSNotification *)notification
{
    
    ZSEmotionButton *emotionButton = notification.userInfo[@"emotion"];
    
    //赋值模型
    self.textView.emotion = emotionButton.emotion;
 
}

- (void)dealloc
{
    //消除通知对象
    [LBNotificationCenter removeObserver:self];
}

//导航栏按钮
- (void)setNav
{
    //添加导航栏左边按钮
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBtn)];
    
    //添加导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    NSString *title = @"心动态";
    NSString *name =[[NSUserDefaults standardUserDefaults] objectForKey:ZSUser];
    
    if (name) {
        
        //添加导航栏中间按钮
        UILabel *titleView = [[UILabel alloc] init];
        titleView.textColor = [UIColor whiteColor];
        titleView.width = 200;
        titleView.height = 40;
        //换行设置
        titleView.numberOfLines = 0;
        titleView.textAlignment = NSTextAlignmentCenter;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", title, name];
        
        //创建一个带有属性的字符串，比如颜色 字体属性
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        //添加字体属性位字符
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, title.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(title.length + 1, name.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(title.length + 1, name.length)];

        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
        
    } else {
        self.title = title;
    }
    
}

#pragma mark - 监听按钮方法

- (void)keyBoardDidChangeFrame:(NSNotification *)notification
{
    
    if (self.isSystemKeyboard) return;
    
        NSDictionary *userinfo = notification.userInfo;
        double timeInterval = [userinfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGRect keyBoardF = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [UIView animateWithDuration:timeInterval animations:^{
           
            self.composeToolBar.y =  keyBoardF.origin.y - self.composeToolBar.height - 66;
        }];

}


- (void)textDidChanged
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}


#pragma mark - 点击按钮方法

//取消发送
- (void)clickLeftBtn
{
    //先去除键盘
    [self.textView endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        ZSLog(@"11111");
        
        //消失控制器
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)send
{
    
    ZSLog(@"11111");
    //判断是否有图片要发送
    if (self.pictureView.subviews.count) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)sendImageWithImage:(UIImage *)image imagePath:(NSString *)imagePath
{
    //设置空间和秘钥
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = DEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = DEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].DEFAULT_EXPIRES_IN = 10;
    
    __block UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        ZSLog(@"response body %@", responseData);
    };
    
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        ZSLog(@"error %@", message);
    };
    
    /**
     *	@brief	根据 UIImage 上传
     */
    
    NSString *pictruePath = [NSString stringWithFormat:@"/picNovelty/%@.jpg", imagePath];
    
    [uy uploadImage:image savekey:pictruePath];
    
}

- (NSString * )getSaveKey{
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
     NSString *fileName = [NSString stringWithFormat:@"test%08X", arc4random()];
    
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
        
        NSString *picturePath = [self getSaveKey];
        
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

/**
 * 得到发送请求参数字典
 */
-(NSMutableDictionary *)getParamsDict
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //传递属性参数
    params[@"date"] = [self getTimeStr];
    params[@"class"] = self.type;
    params[@"nickname"] = self.switchView.isOn ? @"匿名" : nickName;
    params[@"key"] = self.switchView.isOn ? @"ABCDEFGHIJ" : key;
    params[@"essay"] = [self.textView fullText] ? [self.textView fullText] : @"haha";
    return params;

}

/**
 *  发送有图片的
 */
- (void)sendWithImage
{
    //图片名字
    NSString *path = [self getImageName];
    
    //传递属性参数
    NSMutableDictionary *params = [self getParamsDict];
    params[@"pic"] = [NSString stringWithFormat:@"[%@]", path];

    //发送带有图片的糯米
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/NoveltyWrite" parameters:params success:^(id responseObject) {
        
        
        NSInteger count = [[self.pictureView addPictrues] count];
        for (int i = 0; i < count; i ++) {
            
            UIImage *picture = [self.pictureView addPictrues][i];
            NSString *picturePath = self.imageArray[i];
            [self sendImageWithImage:picture imagePath:picturePath];
            
        }
        
//        [MBProgressHUD showSuccess:@"发送成功"];
        
        ZSLog(@"%@", responseObject);

        
    } failure:^(NSError *error) {
       
        [MBProgressHUD showError:@"发送失败"];
        
        ZSLog(@"%@", error);

    }];
    
    
}


/**
 *  发送没有图片的糯米
 */
- (void)sendWithoutImage
{

    //发送不带图片的参数
    NSMutableDictionary *params = [self getParamsDict];
    params[@"pic"] = @"[]";
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=novelty/NoveltyWrite" parameters:params success:^(id responseObject) {
        
        [MBProgressHUD showSuccess:@"发送成功"];
        
        ZSLog(@"%@", responseObject);
        
    } failure:^(NSError *error) {
       
        [MBProgressHUD showError:@"发送失败"];
 
    }];
}


#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //设置键盘消失
    [self.textView endEditing:YES];
}

#pragma mark - ZSComposeToolBarDelegate

- (void)composeToolBar:(ZSComposeToolBar *)composeToolBar didClickButton:(ZSComposeToolBarButtonType)btnType
{
    switch (btnType) {
        case ZSComposeToolBarButtonTypeCamera:
            //代开相机
            [self openCamera];
            break;
        case ZSComposeToolBarButtonTypePicture:
            //打开相册
            [self openAlbum];
            break;
        case ZSComposeToolBarButtonTypeMention:
            
            break;
        case ZSComposeToolBarButtonTypeTrend:
            
            break;
        case ZSComposeToolBarButtonTypeEmotion:
            //表情
            [self addEmotion];
            break;
            
        default:
            break;
    }
}

#pragma mark- other method

//添加表情
- (void)addEmotion
{
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highLightImage = @"compose_emoticonbutton_background_highlighted";
    if (self.textView.inputView) {

        [self.composeToolBar switchKeyboardWitgImage:image highLightImage:highLightImage];
        self.textView.inputView = nil;
        
    } else {
        
        image = @"compose_keyboardbutton_background";
        highLightImage = @"compose_keyboardbutton_background_highlighted";
        
        [self.composeToolBar switchKeyboardWitgImage:image highLightImage:highLightImage];
        
        ZSEmotionKeyboard *emotionKeyboard = [[ZSEmotionKeyboard alloc] init];
        emotionKeyboard.width = self.view.width;
        emotionKeyboard.height = 258;
        self.textView.inputView = emotionKeyboard;
    }
    
    //键盘退出之前 设置isSystemKeyboard = NO;
    self.isSystemKeyboard = YES;
    //销毁键盘 再转换成自定义键盘
    [self.textView endEditing:YES];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        
        [self.textView becomeFirstResponder];
    });
    
    self.isSystemKeyboard = NO;
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

    [self.pictureView addPicture:picture];
    
}

@end
