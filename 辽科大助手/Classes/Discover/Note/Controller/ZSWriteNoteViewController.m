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

@interface ZSWriteNoteViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** scroView*/
@property (nonatomic, weak) UIScrollView *scroView;

/** 标题*/
@property (nonatomic, weak) UITextField *titleView;

/** textView*/
@property (nonatomic, weak) UITextView *textView;

/** 图片路径数组*/
@property (nonatomic, strong) NSMutableArray *imagePathArray;

/**退出键盘按钮*/
@property (nonatomic, weak) UIButton *exitKeyBoardBtn;

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

/** 添加内容*/
- (void)settingContent
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroView = [[UIScrollView alloc] init];
    scroView.frame = CGRectMake(0, 0, ZSScreenW, 100);
    scroView.delegate = self;
    scroView.bounces = NO;
    scroView.backgroundColor = [UIColor whiteColor];
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.showsVerticalScrollIndicator = NO;
    
    self.scroView = scroView;
    
    [self.imagePathArray addObjectsFromArray:self.note.icons];
    [self.view addSubview:scroView];
    
    //标题
    UITextField *titleView = [[UITextField alloc] init];
    titleView.frame =  CGRectMake(0, CGRectGetMaxY(scroView.frame), ZSScreenW, 35);
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
    

    UITextView *textView = [[UITextView alloc] init];

    textView.frame = CGRectMake(0, CGRectGetMaxY(titleView.frame), ZSScreenW, ZSScreenH - CGRectGetMaxY(titleView.frame));
    self.textView = textView;
    [self.view addSubview:textView];
    
    //添加退出键盘按钮
    UIButton *exitKeyBoardBtn = [[UIButton alloc] init];
    exitKeyBoardBtn.frame = CGRectMake(300, 700, 48, 48);
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
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImage:@"compose_camerabutton_background" highLightImage:@"" target:self action:@selector(openCamera)];
    
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImage:@"compose_toolbar_picture" highLightImage:@"" target:self action:@selector(openAlbum)];
    
    self.navigationItem.rightBarButtonItems = @[item2 ,item1];
    
    
    self.title = @"写笔记";
    

}

- (void)clickLeftBtn
{
    
    ZSNoteModel *noteModel = [[ZSNoteModel alloc] init];
    
    noteModel.headerTitle = [self getMoonDayStr];
    noteModel.title = self.titleView.text ? self.titleView.text : @"默认";
    noteModel.content =  self.textView.text ? [NSString stringWithFormat:@" %@", self.textView.text] : nil;
    
    noteModel.icons = self.imagePathArray;
    
    if (self.note == nil) {

        noteModel.time = [self getHourMinuteStr];
        //执行新增加笔记的方法
        if ([self.delegate respondsToSelector:@selector(writeNoteViewControllerDelegate:noteModael:)]) {
            
            [self.delegate writeNoteViewControllerDelegate:self noteModael:noteModel];
        }
    } else {
        noteModel.time = self.note.time;
        
        if ([self.delegate respondsToSelector:@selector(writeNoteViewControllerDelegate:addnoteModael:th:)]) {
            //执行修改笔记的方法
            [self.delegate writeNoteViewControllerDelegate:self addnoteModael:noteModel th:self.th];
        }
    }
    

    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.width = 94;
    imageView.height = 94;
    imageView.x = self.imagePathArray.count * (imageView.width + 5) + 3;
    imageView.y = 3;
    
    imageView.image = picture;
    
    [self.scroView addSubview:imageView];
    
    NSString *imagePathName = [NSString stringWithFormat:@"icon%@", [self getTimeImageStr]];
    
    //保存图片
    [self SaveImageToLocal:picture Keys:imagePathName];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
