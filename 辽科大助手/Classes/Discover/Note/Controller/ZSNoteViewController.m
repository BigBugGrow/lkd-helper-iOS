//
//  ZSNoteViewController.m
//  辽科大助手
//
//  Created by MacBook Pro on 16/3/31.
//  Copyright © 2016年 USTL. All rights reserved.
//

#import "ZSNoteViewController.h"
#import "ZSWriteNoteViewController.h"
#import "ZSNoteViewCell.h"
#import "ZSNoteModel.h"
#import "ZSSaveNotes.h"

@interface ZSNoteViewController () <ZSWriteNoteViewControllerDelegate>

/** plusBtn*/
@property (nonatomic, weak) UIButton *plusBtn;

/** 模型数组*/
@property (nonatomic, strong) NSMutableArray *notes;

@end

static NSString *ID = @"noteCell";

@implementation ZSNoteViewController

/** 懒加载*/
- (NSMutableArray *)notes
{
    if (_notes == nil) {
        _notes = [NSMutableArray array];
    }
    return _notes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载保存过的笔记数据
    self.notes = (NSMutableArray *)[ZSSaveNotes resentNotes];
    
    self.title = @"笔记本";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZSNoteViewController" bundle:nil] forCellReuseIdentifier:ID];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

/** 按钮监听方法*/
- (void)clickPlusBtn
{
    ZSWriteNoteViewController *writeNote = [[ZSWriteNoteViewController alloc] init];
    writeNote.delegate = self;
    [self.navigationController pushViewController:writeNote animated:YES];
}


/** 按钮监听方法*/
- (void)clickPlusBtn:(ZSNoteModel *)noteModel th:(NSInteger)th
{
    ZSWriteNoteViewController *writeNote = [[ZSWriteNoteViewController alloc] init];
    writeNote.delegate = self;
    writeNote.note = noteModel;
    writeNote.th = th;
    [self.navigationController pushViewController:writeNote animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIButton *plusBtn = [[UIButton alloc] init];
    plusBtn.width = 60;
    plusBtn.height = 60;
    plusBtn.x = ZSScreenW - plusBtn.width - 15;
    plusBtn.y = ZSScreenH - plusBtn.height - 20;
    [plusBtn setImage:[UIImage imageNamed:@"lv_upload_edit_btn_bkg"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"lv_upload_edit_btn_bkg_pressed"] forState:UIControlStateHighlighted];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:plusBtn];
    self.plusBtn = plusBtn;
    
    //添加监听方法
    [plusBtn addTarget:self action:@selector(clickPlusBtn) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.plusBtn removeFromSuperview];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.notes.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSNoteViewCell *cell = [ZSNoteViewCell noteViewCellWithTableView:tableView];
    
    cell.note = self.notes[indexPath.section];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.notes[section] headerTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

/** cell点击*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickPlusBtn:self.notes[indexPath.section] th:indexPath.section];
}

/** 删除条目*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        
        //删除模型中的当前行数据
        [self.notes removeObjectAtIndex:indexPath.section];
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        
        [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
        [ZSSaveNotes saveresentNotes:self.notes];
    }
}

#pragma mark- ZSWriteViewControllerDelegate

- (void)writeNoteViewControllerDelegate:(ZSWriteNoteViewController *)writeNoteViewController noteModael:(ZSNoteModel *)noteModel
{

    [self.notes addObject:noteModel];
    //保存笔记本
    [ZSSaveNotes saveresentNotes:self.notes];

    [self.tableView reloadData];
}


/** 修改后添加的属性*/
- (void)writeNoteViewControllerDelegate:(ZSWriteNoteViewController *)writeNoteViewController addnoteModael:(ZSNoteModel *)noteModel th:(NSInteger)th
{
    self.notes[th] = noteModel;
    //保存笔记本
    [ZSSaveNotes saveresentNotes:self.notes];
    //刷新表格
    [self.tableView reloadData];
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
