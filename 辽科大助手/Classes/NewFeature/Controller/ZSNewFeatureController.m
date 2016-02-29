//
//  ZSNewFeatureController.m
//  辽科大助手
//
//  Created by DongAn on 15/12/2.
//  Copyright © 2015年 DongAn. All rights reserved.
//

#import "ZSNewFeatureController.h"
#import "ZSNewFeatureCell.h"
@interface ZSNewFeatureController ()
@property (nonatomic,weak)UIPageControl *control;
@end

@implementation ZSNewFeatureController

static NSString * const reuseIdentifier = @"Cell";
// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置cell的尺寸
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    //清空行距
    layout.minimumLineSpacing = 0;
    
    //设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ZSNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self setUpPageControl];
}
- (void)setUpPageControl
{
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = 5;
    control.pageIndicatorTintColor = [UIColor lightGrayColor];
    control.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    control.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 10);
    _control = control;
    [self.view addSubview:control];
}
#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    _control.currentPage = page;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    // dequeueReusableCellWithReuseIdentifier
    // 1.首先从缓存池里取cell
    // 2.看下当前是否有注册Cell,如果注册了cell，就会帮你创建cell
    // 3.没有注册，报错
    
    ZSNewFeatureCell *cell = [collectionView
    dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NSString *imgName = [NSString stringWithFormat:@"firstguide_0%ld.jpg",indexPath.row + 1];

    cell.image = [UIImage imageNamed:imgName];
    
    [cell setIndexPath:indexPath count:6];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
