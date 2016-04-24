//
//  ZSRegisterViewController.m
//  辽科大助手
//
//  Created by DongAn on 16/1/7.
//  Copyright © 2016年 DongAn. All rights reserved.h
//

#import "ZSRegisterViewController.h"

#import "ZSHttpTool.h"
#import "ZSAccount.h"
#import "ZSAccountTool.h"
#import "UpYun.h"
#import "ZSLoginViewController.h"
#import "ZSNavigationController.h"

#import "ZSStudentNumBindViewController.h"

#import "MBProgressHUD+MJ.h"

@interface ZSRegisterViewController ()<UINavigationControllerDelegate ,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property  (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlButton;

/**判断用户是否选择头像*/
@property (nonatomic, assign) BOOL selectedIcon;

@end

@implementation ZSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.activityIndicator.hidden = YES;
    
    
    //添加头像点击事件
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAlbum)]];
    
    
    // 1.addTarget
    [self.userNameText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordText addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    //添加监听
    [self textChange];

}


- (void)textChange
{
    // 判断两个文本框的内容
    self.registBtn.enabled = self.userNameText.text.length && self.passwordText.text.length;
}


- (IBAction)registerButtonClicked:(id)sender {
    
    NSString *userName = self.userNameText.text;
    NSString *pwd = self.passwordText.text;
    NSString *sex = self.segmentedControlButton.selectedSegmentIndex ? @"girl" : @"boy";
 
    NSDictionary *parameters = @{@"nickname":userName,@"password":pwd,@"sex":sex};
    
    self.activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [ZSHttpTool POST:@"http://infinitytron.sinaapp.com/tron/index.php?r=base/Register" parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"state"] isEqualToString:@"500"] || [responseObject[@"state"] isEqualToString:@"101"] || [responseObject[@"state"] isEqualToString:@"000"]) {
            
//            DALog(@"%@",responseObject[@"state"]);
//            ;
//            DALog(@"%@",[responseObject[@"state"] substringToIndex:1])
//            ;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                [MBProgressHUD showError:@"注册错误"];
                
            });
            
        } else if([[responseObject[@"state"] substringToIndex:1] isEqualToString:@"2"]) {
            
            
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [MBProgressHUD showError:@"用户名由字母,数字,下划线组成"];
            
        }else if([responseObject[@"state"] isEqualToString:@"501"]) {
            
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [MBProgressHUD showError:@"此用户名已被注册"];
            
        } else { 
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                
                //如果用户没打开相册， 就是用默认头像
                UIImage *defaultImage = [UIImage imageNamed:@"other_on"];
                
                UIImage  *newDefaultImage = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(200, 200) image:defaultImage];
                
                UIImage *iconImage = self.selectedIcon ? self.iconImageView.image : newDefaultImage;
                
                [self sendImageWithImage:iconImage imageName:self.userNameText.text];
            
                [MBProgressHUD showSuccess:@"注册成功"];
            });
            
            //保存账号和密码,key sex
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:ZSUser];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:ZSPassword];
            [[NSUserDefaults standardUserDefaults] setObject:sex forKey:ZSSex];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"key"] forKey:ZSKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ZSStudentNumBindViewController *studentNumBindVC = [[ZSStudentNumBindViewController alloc] init];
            [self presentViewController:studentNumBindVC animated:YES completion:nil];
            
        }
        
    } failure:^(NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [MBProgressHUD showError:@"网络错误"];
    }];
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
    
    NSString *pictruePath = [NSString stringWithFormat:@"/picUser/%@.jpg", imageName];
    
    
    
    [uy uploadImage:image savekey:pictruePath];
    
}

- (void)openCamera
{
    
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
    
    
    //若打开相册 设置为YES
    self.selectedIcon = YES;
    
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
    
    //制作头像的圆形形状
    [self.iconImageView.layer setCornerRadius:CGRectGetHeight([self.iconImageView bounds]) / 2];
    self.iconImageView.layer.masksToBounds = YES;
    //        然后再给图层添加一个有色的边框，类似qq空间头像那样
    self.iconImageView.layer.borderWidth = 0;
    self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
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
    
    //图片压缩
    UIImage *newImage = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(newImageWidth, newImageHeight) image:picture];
    
    
    self.iconImageView.image = newImage;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}


- (IBAction)exitRegister {
    
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;

    [root dismissViewControllerAnimated:YES completion:nil];
    
}

@end
