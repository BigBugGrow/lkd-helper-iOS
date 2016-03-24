//
//  BSPublishView.m
//  百思不得姐
//
//  Created by MacBook Pro on 16/3/17.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSPublishView.h"
#import "ZSVerticalButton.h"
#import "POP.h"
#import "ZSComposeViewController.h"
#import "ZSNavigationController.h"


#define BSRootView [UIApplication sharedApplication].keyWindow.rootViewController.view

@interface ZSPublishView ()

/** 取消按钮*/
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation ZSPublishView

+ (instancetype)publishView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZSPublishView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //0.
    self.width = ZSScreenW;
    self.height = ZSScreenH;
    
    //1.设置自己不能够点击
    self.userInteractionEnabled = NO;
    BSRootView.userInteractionEnabled = NO;
    
    //2.添加按钮
    
    // 数据
    NSArray *images = @[@"tab03_novelty", @"publish-text", @"publish-audio", @"publish-review"];
    NSArray *titles = @[@"新建随笔", @"吐个槽", @"表个白吧", @"热门话题"];
    
    //一行的 最大列值
    NSInteger maxCol = 2;
    
    CGFloat buttonWidth = 72;
    CGFloat buttonHeight = buttonWidth + 30;
    CGFloat buttonMargin = (ZSScreenW - maxCol * buttonWidth) / 3;
    
    CGFloat buttonHeightMargin = ZSScreenH * 0.3 + 30;
    
    for (int i = 0; i < images.count; i ++) {
        
        ZSVerticalButton *button = [[ZSVerticalButton alloc] init];
        
        //为按钮设置内容
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        NSInteger row = i / maxCol;
        NSInteger col = i % maxCol;
        
        button.tag = i;
    
        CGFloat buttonX = buttonMargin + (buttonMargin + buttonWidth) * col;
        CGFloat buttonY = buttonHeightMargin + buttonHeight * row;
        
        //添加监听方法
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX + ZSScreenW, buttonY, buttonWidth, buttonHeight)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
        
        anim.springBounciness = 10;
        anim.springSpeed = 10;
        
        anim.beginTime = CACurrentMediaTime() + 0.1 * i;
        
        [button pop_addAnimation:anim forKey:nil];
        
    }
    
    
    //添加标题栏
    UIImageView *slogan = [[UIImageView alloc] init];
    slogan.image = [UIImage imageNamed:@"app_slogan"];
    slogan.width = 202;
    slogan.height = 20;
    
    
//    slogan.centerX = BSScreeenWidth * 0.5;
//    slogan.y = BSScreeenHeight * 0.2;
    
//    CGFloat sloganWidth = 202;
//    CGFloat sloganHeight = 20;
    
    
    CGFloat sloganCenterX = ZSScreenW * 0.5;
    CGFloat sloganCenterY = ZSScreenH * 0.2;
    
    [self addSubview:slogan];
    
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(sloganCenterX, sloganCenterY - ZSScreenH)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(sloganCenterX, sloganCenterY)];
    
    anim.beginTime = CACurrentMediaTime() + 0.1 * 5;
    
    //设置动画之后， 干什么事情
    [anim setCompletionBlock:^(POPAnimation *anims, BOOL bo) {
        
        BSRootView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }];
    
    [slogan pop_addAnimation:anim forKey:nil];
    
}

/** 点击按钮*/
- (void)clickBtn:(ZSVerticalButton *)btn
{
    
    
    [self cancelWithCompletionBlock:^{
        
        //添加控制器
        ZSComposeViewController *composeVc = [[ZSComposeViewController alloc] init];
       
        if (btn.tag == 0) {
            
          composeVc.type = @"all";
        } else if(btn.tag == 1) {
            
            composeVc.type = @"discloseBoard";
        } else if (btn.tag == 2) {
            
            composeVc.type = @"confessionWall";
        } else if (btn.tag == 3) {

            composeVc.type = @"topics";
        }
        
        if ([self.delegate respondsToSelector:@selector(pushToPublishViewController:ComposeViewController:)]) {
            
            [self.delegate pushToPublishViewController:self ComposeViewController:composeVc];
        }
       
    }];
}

/** 取消*/
- (IBAction)cancel {
    
    [self cancelWithCompletionBlock:nil];

}

/** 退出时也有弹簧效果*/
- (void)cancelWithCompletionBlock:(void (^)())completionBlock1
{
    self.cancelButton.hidden = YES;
    
    for (int i = 1; i < self.subviews.count; i ++) {
        
        UIView *button = self.subviews[i];
        CGFloat buttonWidth = button.width;
        CGFloat buttonHeight = button.height;
        CGFloat buttonX = button.x;
        CGFloat buttonY = button.y;
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX + ZSScreenW, buttonY, buttonWidth, buttonHeight)];
        
        anim.beginTime = CACurrentMediaTime() + 0.1 * (i - 1);
        
        if (i == self.subviews.count - 1) {
            

            [anim setCompletionBlock:^(POPAnimation *anim, BOOL bo) {
                
                //移除当前的view
                [self removeFromSuperview];
                
                //执行block
                !completionBlock1 ?: completionBlock1();
            }];
        }
        
        [button pop_addAnimation:anim forKey:nil];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}



@end
