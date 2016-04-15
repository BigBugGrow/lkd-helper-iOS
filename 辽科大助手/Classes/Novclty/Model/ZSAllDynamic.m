//
//  ZSAllDynamic.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/4.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSAllDynamic.h"
#import "MJExtension.h"
#import "ZSEmotionPart.h"
#import "ZSSpecial.h"
#import "ZSEmotion.h"
#import "RegexKitLite.h"
#import "ZSEmotionTool.h"

@interface ZSAllDynamic () <NSCoding>

@end

@implementation ZSAllDynamic

MJCodingImplementation

/**
 *  根据普通文字设置图片属性
 *
 *  @param text NSString
 */

- (NSAttributedString *)attributeStringWithText:(NSString *)text
{
    //
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    //        NSArray *cmps = [str componentsMatchedByRegex:pattern];
    
    //存储所有遍历出来的文字
    NSMutableArray *parts = [NSMutableArray array];
    
    // 遍历所有的特殊文字
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        //设置特殊文字颜色属性
        //        [attributeText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:*capturedRanges];
        
        ZSEmotionPart *part = [[ZSEmotionPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.expeicalText = YES;
        
        //如果是表情文字
        if ([(*capturedStrings) hasPrefix:@"["] && [(*capturedStrings) hasSuffix:@"]"]) {
            part.emotion = YES;
        }
        
        [parts addObject:part];
        
    }];
    
    //遍历所有的非特殊文字
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if ((*capturedStrings).length == 0) return;
        
        ZSEmotionPart *part = [[ZSEmotionPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    //将文字数组按范围排序
    [parts sortUsingComparator:^NSComparisonResult(ZSEmotionPart *part1, ZSEmotionPart *part2) {
        
        //        NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        
        if (part1.range.location > part2.range.location) { //按照降序排序
            
            return NSOrderedDescending;
        }
        return part1.range.location > part2.range.location;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    NSMutableArray *specials = [NSMutableArray array];
    
    //拼接截下来的字符串
    for (ZSEmotionPart *part in parts) {
        
        
        NSAttributedString *subString = nil;
        
        
        if (part.isEmotion) { //若是表情
            
            //拼接图片表情
            
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            
            ZSEmotion *emotion = [ZSEmotionTool emotionWithCht:part.text];
            
            if (emotion) {
                
                attch.image = [UIImage imageNamed:emotion.png];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                subString = [NSAttributedString attributedStringWithAttachment:attch];
            } else {
                
                //拼接文字
                subString = [[NSAttributedString alloc] initWithString:part.text];
            }
            
        } else if (part.isExpeical) { //如果是特殊文字
            
            subString = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                          NSForegroundColorAttributeName : [UIColor blueColor]
                                                                                          }];
            ZSSpecial *special = [[ZSSpecial alloc] init];
            special.text = part.text;
            
            
            NSUInteger loc = attributeText.length;
            NSUInteger len = part.text.length;
            
            special.range = NSMakeRange(loc, len);
            
            //添加特殊文字到数组
            [specials addObject:special];
            
        } else { //如果是普通文字， 直接拼接
            
            subString = [[NSAttributedString alloc] initWithString:part.text];
        }
        
        
        //拼接文字
        [attributeText appendAttributedString:subString];
    }
    
    
    //设置统一字体 一定要设置字体, 会根据字体设置frame
    [attributeText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeText.length)];
    
    //将特殊文字带走
    [attributeText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    return attributeText;
}

- (void)setEssay:(NSString *)essay
{
    _essay = [essay copy];
    self.attributeText = [self attributeStringWithText:essay];
}



+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             @"Class" : @"class"
             };
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"ID: %@,  %@, %@, %@, %@, %@, %@  ", self.ID, self.nickname, self.essay, self.pic, self.commentNum, self.date, self.Class];
}

@end
