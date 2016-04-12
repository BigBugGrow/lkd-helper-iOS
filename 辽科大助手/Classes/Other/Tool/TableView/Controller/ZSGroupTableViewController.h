//
//  ZSGroupTableViewController.h
//  辽科大助手
//
//  Created by DongAn on 15/12/1.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSGroupTableViewController : UITableViewController

@property (nonatomic,strong)NSMutableArray *cellData;

- (void)setUpTableHeaderView:(NSString *)headViewName;
- (void)initModelData;
@end
