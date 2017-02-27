//
//  PASFindController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiscoverController.h"
#import "FindCollectionViewCell.h"
#define sideGap 20
#define findIconHeight 130
#define findIconWide ([UIScreen mainScreen].bounds.size.width - sideGap*4)/3.0
#define findIconGap ([UIScreen mainScreen].bounds.size.width - findIconWide*3)/4.0
@interface PASDiscoverController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collectionView;
}
@end

@implementation PASDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    
    // Do any additional setup after loading the view.
}
- (void)initView {
    
    [self initCollectionView];
}
- (void)initData {
    
}
- (void)initCollectionView {
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(findIconWide, findIconHeight);
    //初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    //注册collectionViewCell
    [_collectionView registerClass:[FindCollectionViewCell class] forCellWithReuseIdentifier:@"FindCollectionViewCell"];
}
#pragma mark collectionView代理方法
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindCollectionViewCell *cell = (FindCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FindCollectionViewCell" forIndexPath:indexPath];
    cell.favoriteClicked = ^(BOOL selected) {
        //点击收藏按钮
        NSLog(@"%d",selected);
        
    };
    return cell;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(findIconGap,sideGap, 10, sideGap);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击第几个：%ld",(long)indexPath.row);
    
}
//设置垂直距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
