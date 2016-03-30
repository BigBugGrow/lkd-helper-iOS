//
//  ZSProfileImageCell.m
//  辽科大助手
//
//  Created by DongAn on 15/11/30.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSProfileImageCell.h"
#import<QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

#define nickName [[NSUserDefaults standardUserDefaults] objectForKey:ZSUser]

@interface ZSProfileImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sayingLabel;
@property (nonatomic,weak)UIButton *iconButton;


@end


@implementation ZSProfileImageCell

- (void)awakeFromNib {
    
    self.imgView.layer.masksToBounds = YES;
    
    self.imgView.layer.cornerRadius = self.imgView.width * 0.5;
    
    self.imgView.layer.borderWidth = 0;
    
    self.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    /** 头像imageView*/
    NSString *str = [NSString stringWithFormat:@"http://lkdhelper.b0.upaiyun.com/picUser/%@.jpg!small",nickName];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        self.imgView.image = image;
        
    }];
    
    
    // 昵称
    self.nameLabel.text = nickName;
    
    //名言
    self.sayingLabel.text = @"聚没有品的代言词很牛逼";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
