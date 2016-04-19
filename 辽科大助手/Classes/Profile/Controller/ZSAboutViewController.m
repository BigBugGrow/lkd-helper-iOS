//
//  ZSAboutViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/4/5.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAboutViewController.h"

@interface ZSAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *abloutLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, weak) UIView *cover;

@property (nonatomic, weak) UIScrollView *scroView;

@property (nonatomic, weak) UIButton *kownBtn;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation ZSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于";

    NSString *about = @"辽科大助手 由辽宁科技大学学生处（思政中心）管理，（网络文化工作室）负责运营，秉承“励志、利生、力行” 学生工作理念，发布大学生思想政治教育、日常管理、校园文化活动等信息，为广大师生提供校园最新资讯、查询等服务平台。";
//    
//    UIImage *picture = [UIImage imageNamed:@"about_lkdhelper"];
//    
//    CGFloat imageWidth = picture.size.width;
//    CGFloat imageHeight = picture.size.height;
//    
//    CGFloat newImageWidth, newImageHeight;
//    
//    newImageWidth = (ZSScreenW - 30);
//    newImageHeight = newImageWidth / imageWidth * imageHeight;
//    
//    
//    ZSLog(@"%@", NSStringFromCGSize(picture.size));
//    //图片压缩
//    UIImage *newImage = [self imageByScalingAndCroppingForSize:CGSizeMake(newImageWidth, newImageHeight) image:picture];
//    
//    ZSLog(@"%@", NSStringFromCGSize(newImage.size));
//    
//    self.bgImageView.width = newImageWidth;
//    self.bgImageView.height = newImageHeight;
//    self.bgImageView.image = newImage;

    self.abloutLabel.text = about;
    self.abloutLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.chargeBtn addTarget:self action:@selector(clickChargeBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickChargeBtn
{
    
//    self.navigationController.navigationBar.hidden = YES;
    
    CGFloat margin = 15;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = RGBColor(123, 123, 123, 0.7);
    cover.frame = window.bounds;
    [window addSubview:cover];
    self.cover = cover;
    
    window.backgroundColor = RGBColor(123, 123, 123, 0.5);
    
    UIScrollView *scroView = [[UIScrollView alloc] init];
    scroView.width = ZSScreenW - margin * 2;
    scroView.height = ZSScreenH - margin * 2 - 30 - 40;
    scroView.x = margin;
    scroView.y = margin + 40;
    scroView.backgroundColor = [UIColor whiteColor];
    [window addSubview:scroView];
    self.scroView = scroView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"    免责声明";
    titleLabel.width = ZSScreenW - margin * 2;
    titleLabel.height = 50;
    titleLabel.x = margin;
    titleLabel.y = margin;
    [window addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *kownBtn = [[UIButton alloc] init];
    [kownBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [kownBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    kownBtn.width = ZSScreenW - 2 * margin;
    kownBtn.height = 40;
    kownBtn.x = margin;
    kownBtn.y = window.height - kownBtn.height - 20;
    
    [kownBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateHighlighted];
    [kownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [window addSubview:kownBtn];
    [kownBtn addTarget:self action:@selector(clickKownBtn) forControlEvents:UIControlEventTouchUpInside];
    kownBtn.backgroundColor = [UIColor whiteColor];
    self.kownBtn = kownBtn;
    
    NSString *content = @"1、一切辽科大助手用户在下载并浏览辽科大助手APP时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本声明和用户服务协议的约束。2、辽科大助手APP用户转载的内容并不代表辽科大助手APP之意见及观点，也不意味着辽科大助手APP赞同其观点或证实其内容的真实性。3、辽科大助手APP用户转载的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。辽科大助手APP不提供任何保证，并不承担任何法律责任。4、辽科大助手APP用户所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。5、辽科大助手APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由本APP实际控制的任何网页上的内容，辽科大助手APP不承担任何责任。6、用户明确并同意其使用辽科大助手APP网络服务所存在的风险将完全由其本人承担；因其使用辽科大助手APP网络服务而产生的一切后果也由其本人承担，辽科大助手APP对此不承担任何责任。7、除辽科大助手APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，辽科大助手APP概不负责，亦不承担任何法律责任。对于因不可抗力或因黑客攻击、通讯线路中断等辽科大助手APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用辽科大助手APP，辽科大助手APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。10、辽科大助手APP相关声明版权及其修改权、更新权和最终解释权均属辽科大助手所有。";
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(ZSScreenW - 4 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    contentLabel.x = margin;
    contentLabel.y = 0;
    contentLabel.width = size.width;
    contentLabel.height = size.height + 400;
    contentLabel.text = content;
    
    scroView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    [scroView addSubview:contentLabel];
    
    scroView.contentSize = CGSizeMake(0, contentLabel.size.height);
    
}

- (void)clickKownBtn
{
//    self.navigationController.navigationBar.hidden = NO;
    [self.cover removeFromSuperview];
    [self.scroView removeFromSuperview];
    [self.kownBtn removeFromSuperview];
    [self.titleLabel removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
