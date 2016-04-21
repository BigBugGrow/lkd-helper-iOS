//
//  ZSCourseMenuViewController.h
//   辽科大助手
//
//  Created by MacBook Pro on 16/1/1.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSCourseMenuViewController.h"
#import "ZSAccountTool.h"
#import "ZSAccount.h"
@implementation ZSCourseMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 150, 50);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    titleLabel.textColor = [UIColor whiteColor];
    
    UIView *sparatorView = [[UIView alloc] init];
    sparatorView.width = self.view.width;
    sparatorView.height = 1;
    sparatorView.x = 10;
    sparatorView.y = titleLabel.height - 1;
    sparatorView.backgroundColor = [UIColor lightGrayColor];
    [titleLabel addSubview:sparatorView];
    
    self.tableView.tableHeaderView = titleLabel;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"添加课程";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"初始化课表";
    } else if (indexPath.row == 2){
        cell.textLabel.text = @"设置背景";
    } else {
        cell.textLabel.text = @"默认背景";
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        [ZSNotificationCenter postNotificationName:@"addCourse" object:nil];
        
    } else if (indexPath.row == 1) {

        NSArray *timeTable = [NSKeyedUnarchiver unarchiveObjectWithFile:ZSTimeTablePath];
        
        [ZSAccountTool saveAccountTimeTable:timeTable];
        
        [ZSNotificationCenter postNotificationName:@"initTimetable" object:nil];
    } else if (indexPath.row == 2) {
        
        [ZSNotificationCenter postNotificationName:@"changeBgImage" object:nil];
    } else if (indexPath.row == 3) {
        
        [ZSNotificationCenter postNotificationName:@"changeBgDefaultImage" object:nil];
    }
}

@end
