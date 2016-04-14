//
//  ZSWriteNoteViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSWriteNoteViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "ZSNoteModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ZSTextView.h"


@interface ZSWriteNoteViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UIActionSheetDelegate>

/** scroView*/
@property (nonatomic, weak) UIScrollView *scroView;

/** 标题*/
@property (nonatomic, weak) UITextField *titleView;

/** textView*/
@property (nonatomic, weak) ZSTextView *textView;

/** 图片路径数组*/
@property (nonatomic, strong) NSMutableArray *imagePathArray;

/**退出键盘按钮*/
@property (nonatomic, weak) UIButton *exitKeyBoardBtn;

@property (nonatomic, weak) UITapGestureRecognizer *tab;

/**imageCount*/
@property (nonatomic, assign) NSInteger imageCount;

@end

@implementation ZSWriteNoteViewController

/** 懒加载*/
- (NSMutableArray *)imagePathArray
{
    if (_imagePathArray == nil) {
        _imagePathArray = [NSMutableArray array];
    }
    return _imagePathArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageCount = 0;

    //设置导航栏内容
    [self settingNav];
    
    // 添加子空间
    [self settingContent];
    
    //设置数据
    [self settingData];


    //根据键盘的y值来设定工具条的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

/** 监听键盘*/
- (void)keyBoardDidChangeFrame:(NSNotification *)notification
{
    
    NSDictionary *userinfo = notification.userInfo;
    double timeInterval = [userinfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyBoardF = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:timeInterval animations:^{
        
        self.exitKeyBoardBtn.y =  keyBoardF.origin.y - self.exitKeyBoardBtn.height - 50;
    }];

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 设置数据*/
- (void)settingData
{
    if (self.note.title) {
        
        self.titleView.text = self.note.title;
        
        self.textView.text = self.note.content;
        
        for (int i = 0; i < self.note.icons.count; i ++) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            imageView.width = 94;
            imageView.height = 94;
            imageView.x = i * (imageView.width + 5) + 3;
            imageView.y = 3;
            
            //去除本地图片
            imageView.image = [self GetImageFromLocal:self.note.icons[i]];
            
            [self.scroView addSubview:imageView];
            
        }
        //设置scroView的长度
        self.scroView.contentSize = CGSizeMake(self.note.icons.count * 100, 100);
    }

}

- (void)clickImageView
{
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:@"查看照片", nil];
//    
//    
    
//    [sheet showInView:self.view];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"删除照片" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        
        if (self.imageCount == 0) {
            
            UIImageView *imageView = [self.scroView.subviews lastObject];
            [imageView removeFromSuperview];
            self.imageCount ++;
        }
        
        //现只能够删除最后一张
        UIImageView *imageView = [self.scroView.subviews lastObject];
        [imageView removeFromSuperview];
        [self.imagePathArray removeLastObject];
        
        //如果没有照片  隐藏scroview
        if (self.scroView.subviews.count == 0) {
            
            self.scroView.hidden = YES;
            self.titleView.y = 0;
        
            self.textView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), ZSScreenW, ZSScreenH - CGRectGetMaxY(self.titleView.frame));

        }
        
        
        
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"查看照片" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
       
        
        //查看照片
        [self seePhoto];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];

}


- (void)tab:(UIImageView *)tabView
{
    // ZSPhoto --> MJPhone
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (int i = 0; i < self.imagePathArray.count; i ++) {
        
        MJPhoto *p = [[MJPhoto alloc] init];
        p.image = [self GetImageFromLocal:self.imagePathArray[i]];
        p.srcImageView = tabView;
        p.index = i;
        [arrM addObject:p];
        
    }
    
    //弹出图片浏览器
    //创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //MJPhone
    brower.photos = arrM;
    brower.currentPhotoIndex = tabView.tag;
    [brower show];

}

/** 添加内容*/
- (void)settingContent
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroView = [[UIScrollView alloc] init];
    scroView.frame = CGRectMake(0, 0, ZSScreenW, 100);
    scroView.delegate = self;
    scroView.bounces = NO;
    scroView.backgroundColor = [UIColor whiteColor];
    scroView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView)];
    self.tab = tab;
    scroView.userInteractionEnabled = YES;
    
    [scroView addGestureRecognizer:tab];
    
    self.scroView = scroView;
    
    [self.imagePathArray addObjectsFromArray:self.note.icons];
    [self.view addSubview:scroView];
    
    //标题
    UITextField *titleView = [[UITextField alloc] init];
    titleView.frame =  CGRectMake(5, CGRectGetMaxY(scroView.frame), ZSScreenW-5, 50);
    titleView.font = [UIFont systemFontOfSize:20];
    titleView.placeholder = @"标题";
    titleView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:titleView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.height = 1;
    line.width = ZSScreenW;
    line.x = 0;
    line.y = titleView.height - line.height;
    [titleView addSubview:line];
    
    self.titleView = titleView;
    
    if (self.imagePathArray.count == 0) {
        
        scroView.hidden = YES;
        titleView.y = 0;
    }
    

    ZSTextView *textView = [[ZSTextView alloc] init];

    textView.frame = CGRectMake(0, CGRectGetMaxY(titleView.frame), ZSScreenW, ZSScreenH - CGRectGetMaxY(titleView.frame));
    textView.font = [UIFont systemFontOfSize:17];
    self.textView = textView;
    [self.view addSubview:textView];
    
    textView.placeHolder = @"留下你最心爱的笔记吧。。。";
    
    //添加退出键盘按钮
    UIButton *exitKeyBoardBtn = [[UIButton alloc] init];
    exitKeyBoardBtn.width = 48;
    exitKeyBoardBtn.height = 48;
    exitKeyBoardBtn.x = ZSScreenW - exitKeyBoardBtn.width - 15;
    exitKeyBoardBtn.y = 700;
    
    [exitKeyBoardBtn addTarget:self action:@selector(exitKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [exitKeyBoardBtn setImage:[UIImage imageNamed:@"bar_down_keyboard_icon"] forState:UIControlStateNormal];
    self.exitKeyBoardBtn = exitKeyBoardBtn;
    [self.view addSubview:exitKeyBoardBtn];

}

- (void)exitKeyBoard
{
    [self.view endEditing:YES];
}

/** 设置导航栏内容*/
- (void)settingNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"aio_fileAssitant_success" highLightImage:@"" target:self action:@selector(clickLeftBtn)];
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImage:@"camera" highLightImage:@"" target:self action:@selector(openCameraAlbum)];
    
//    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImage:@"album" highLightImage:@"" target:self action:@selector(openAlbum)];
    
    self.navigationItem.rightBarButtonItems = @[item1];
    
    
    self.title = @"写笔记";
    

}

- (void)clickLeftBtn
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存笔记退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //创建按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ZSNoteModel *noteModel = [[ZSNoteModel alloc] init];
        
        noteModel.title = self.titleView.text ? self.titleView.text : @"默认";
        noteModel.content =  self.textView.text ? [NSString stringWithFormat:@" %@", self.textView.text] : nil;
        
        noteModel.icons = self.imagePathArray;
        
        if (self.note == nil) {
            
            noteModel.headerTitle = [self getMoonDayStr];
            noteModel.time = [self getHourMinuteStr];
            //执行新增加笔记的方法
            if ([self.delegate respondsToSelector:@selector(writeNoteViewControllerDelegate:noteModael:)]) {
                
                [self.delegate writeNoteViewControllerDelegate:self noteModael:noteModel];
            }
        } else {
            
            noteModel.time = self.note.time;
            noteModel.headerTitle = self.note.headerTitle;
            if ([self.delegate respondsToSelector:@selector(writeNoteViewControllerDelegate:addnoteModael:th:)]) {
                //执行修改笔记的方法
                [self.delegate writeNoteViewControllerDelegate:self addnoteModael:noteModel th:self.th];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //如果不保存修改，直接保存原来的值
        if ([self.delegate respondsToSelector:@selector(writeNoteViewControllerDelegate:noteModael:)] && self.note != nil) {
            
            //执行修改笔记的方法
            [self.delegate writeNoteViewControllerDelegate:self addnoteModael:self.note th:self.th];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openCameraAlbum
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.width = 94;
    imageView.height = 94;
    imageView.x = self.imagePathArray.count * (imageView.width + 5) + 3;
    imageView.y = 3;
    
    imageView.image = newImage;
    
    [self.scroView addSubview:imageView];
    
    NSString *imagePathName = [NSString stringWithFormat:@"icon%@", [self getTimeImageStr]];
    
    //保存图片
    [self SaveImageToLocal:newImage Keys:imagePathName];
    
    [self.imagePathArray addObject:imagePathName];
    
    
    //设置titleview的y
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.titleView.y = 100;
        self.textView.y = CGRectGetMaxY(self.titleView.frame);
        //显示相册
        self.scroView.hidden = NO;
    }];
    
    //设置scroView的滚动长度
    self.scroView.contentSize = CGSizeMake(self.imagePathArray.count * 100, 0);
    
    
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


- (NSString *)getHourMinuteStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    //设置日期格式
    //如果是真机调试 转换这种欧美时间 需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"cn"];
    fmt.dateFormat = @"HH:mm";
    //创建时间的日期
    NSString *createDate = [fmt stringFromDate:date];
    return createDate;
}


- (NSString *)getMoonDayStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    //设置日期格式
    //如果是真机调试 转换这种欧美时间 需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"cn"];
    fmt.dateFormat = @"M月dd日";
    //创建时间的日期
    NSString *createDate = [fmt stringFromDate:date];
    return createDate;
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


/** 查看照片*/
- (void)seePhoto
{
    
    UIImageView *imageView = self.scroView.subviews[0];
    [self tab:imageView];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
