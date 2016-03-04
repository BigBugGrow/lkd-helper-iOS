//
//  SwitchView.m
//  NewsDemo
//
//  Created by apple on 15/2/10.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "ZSSwitchView.h"

@implementation ZSSwitchView
int currentTag;
UIColor *white;
UIColor *light;
UIFont *normalFont;
UIFont *lightFont;
UIView *sliderView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=RGBColor(3, 169, 244);
        float h=35;
        float space=0;
        float width=ScreenWidth / 4.0;
        float height=h;
        float w=space+width;
        white=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        light=[UIColor whiteColor];
     
        normalFont=[UIFont boldSystemFontOfSize:15];
        lightFont=[UIFont boldSystemFontOfSize:17];
       
        _button1=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_button1];
        _button1.frame=CGRectMake(space, (h-height)/2, width, height);
        [_button1 setTitle:@"全部动态" forState:UIControlStateNormal];
        _button1.titleLabel.font = normalFont;
        
        [_button1 setTitleColor:white forState:UIControlStateNormal];
        _button1.tag=101;
        [_button1 addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _button2=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_button2];
        _button2.frame=CGRectMake(w+space, (h-height)/2, width, height);
        [_button2 setTitle:@"表白墙" forState:UIControlStateNormal];
        _button2.titleLabel.font = normalFont;
        [_button2 setTitleColor:white forState:UIControlStateNormal];
        _button2.tag=102;
        [_button2 addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _button3=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_button3];
        _button3.frame=CGRectMake(w*2+space, (h-height)/2, width, height);
        [_button3 setTitle:@"吐槽榜" forState:UIControlStateNormal];
        _button3.titleLabel.font = normalFont;
        [_button3 setTitleColor:white forState:UIControlStateNormal];
        _button3.tag=103;
        [_button3 addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _button4=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_button4];
        _button4.frame=CGRectMake(w*3+space, (h-height)/2, width, height);
        [_button4 setTitle:@"今日话题" forState:UIControlStateNormal];
        _button4.titleLabel.font = normalFont;
        [_button4 setTitleColor:white forState:UIControlStateNormal];
        _button4.tag=104;
        [_button4 addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 默认情况
        currentTag=101;
      
        [_button1 setTitleColor:light forState:UIControlStateNormal];
        _button1.titleLabel.font = lightFont;
        
        sliderView = [[UIView alloc] init];
        sliderView.backgroundColor = [UIColor whiteColor];
        sliderView.frame = CGRectMake(0, height - 3, width, 3);
        [_button1 addSubview:sliderView];

        
    }
    return self;
}
-(void)swipeAction:(NSInteger)tag{
//    UIColor *white=[UIColor grayColor];

        
        switch (tag) {
            case 101:
                
                currentTag=101;
                [_button1 setTitleColor:light forState:UIControlStateNormal];
                [_button2 setTitleColor:white forState:UIControlStateNormal];
                [_button3 setTitleColor:white forState:UIControlStateNormal];
                [_button4 setTitleColor:white forState:UIControlStateNormal];
                
                [_button1 addSubview:sliderView];
                
                _button1.titleLabel.font = lightFont;
                _button2.titleLabel.font = normalFont;
                _button3.titleLabel.font = normalFont;
                _button4.titleLabel.font = normalFont;
                break;
            case 102:
                
                currentTag=102;
                [_button1 setTitleColor:white forState:UIControlStateNormal];
                [_button2 setTitleColor:light forState:UIControlStateNormal];
                [_button3 setTitleColor:white forState:UIControlStateNormal];
                [_button4 setTitleColor:white forState:UIControlStateNormal];
                [_button2 addSubview:sliderView];
                
                
                _button1.titleLabel.font = normalFont;
                _button2.titleLabel.font = lightFont;
                _button3.titleLabel.font = normalFont;
                _button4.titleLabel.font = normalFont;
                
                break;
                
            case 103:
                
                currentTag=103;
                [_button1 setTitleColor:white forState:UIControlStateNormal];
                [_button2 setTitleColor:white forState:UIControlStateNormal];
                [_button3 setTitleColor:light forState:UIControlStateNormal];
                [_button4 setTitleColor:white forState:UIControlStateNormal];
                [_button3 addSubview:sliderView];
                
                
                _button1.titleLabel.font = normalFont;
                _button2.titleLabel.font = normalFont;
                _button3.titleLabel.font = lightFont;
                _button4.titleLabel.font = normalFont;
                
                
                break;
            case 104:
                
                currentTag=104;
                [_button1 setTitleColor:white forState:UIControlStateNormal];
                [_button2 setTitleColor:white forState:UIControlStateNormal];
                [_button3 setTitleColor:white forState:UIControlStateNormal];
                [_button4 setTitleColor:light forState:UIControlStateNormal];
                
                [_button4 addSubview:sliderView];
                
                _button1.titleLabel.font = normalFont;
                _button2.titleLabel.font = normalFont;
                _button3.titleLabel.font = normalFont;
                _button4.titleLabel.font = lightFont;
                break;
            default:
                break;
        }
    
    
    if (_ButtonActionBlock) {
        _ButtonActionBlock(currentTag);
    }
    
}
-(void)btAction:(UIButton *)button{
    [self swipeAction:button.tag];
}

@end
