//
//  PASFindController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiscoverController.h"
#import "PASDiscoverCollectionViewCell.h"
#import "PASDescoverListViewController.h"
#import "MJRefresh.h"
#import "PASDiscoverModel.h"
#import "PASConfiguration.h"
#import "PASDataProvider.h"
#import "PAS_DownLoadingApps.h"
#define sideGap 20
#define findIconWide ([UIScreen mainScreen].bounds.size.width - sideGap*4)/3.0
#define findIconGap ([UIScreen mainScreen].bounds.size.width - findIconWide*3)/4.0
#define findIconHeight findIconWide + 25
@interface PASDiscoverController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collectionView;
    NSMutableArray *_dataArr;
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

    _dataArr = [[NSMutableArray alloc] init];
    [self requestGetAllApp];
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
    [_collectionView registerClass:[PASDiscoverCollectionViewCell class] forCellWithReuseIdentifier:@"PASDiscoverCollectionViewCell"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(discoverRefresh)];
}
- (void)requestGetAllApp {

    PASConfiguration *config = [PASConfiguration shareInstance];
    config.baseURL = [NSURL URLWithString:@"http://45.77.13.248:3000/apps/ios"];

    [[[PASDataProvider alloc] initWithConfiguration:config] getAllAppsWithParameters:nil completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
     
        [self handleRequestWithResponseObject:responseObject];
        
    }];
}
#pragma mark - 刷新
- (void)discoverRefresh {
    
    [self requestGetAllApp];
    [_collectionView.mj_header endRefreshing];
    [_collectionView reloadData];
}

- (void)handleRequestWithResponseObject:(id)responseObject {

    if ([responseObject isKindOfClass:[NSArray class]]) {
        [_dataArr removeAllObjects];
        NSArray *dataArr = (NSArray *)responseObject;
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary *dataDic = dataArr[i];
            PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:dataDic];
            model.pas_id = [dataDic objectForKey:@"id"];
            [_dataArr addObject:model];
        }
        [_collectionView reloadData];
    }
}
#pragma mark collectionView代理方法
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PASDiscoverCollectionViewCell *cell = (PASDiscoverCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PASDiscoverCollectionViewCell" forIndexPath:indexPath];
    PASDiscoverModel *model = [_dataArr objectAtIndex:indexPath.row];
    [cell.PAS_AppLogoImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    cell.PAS_AppNameLabel.text = model.name;
    if ([[PAS_DownLoadingApps sharedInstance].followApps containsObject:model.bundleID]) {
        //已经收藏
        cell.checkBox.on = YES;
    }else {
        //未收藏
        cell.checkBox.on = NO;
    }
    cell.favoriteClicked = ^(BOOL selected) {
        //点击收藏按钮
        NSLog(@"%d",selected);
        if (selected) {
            
            [[PAS_DownLoadingApps sharedInstance] addFollowAppsWithBuildId:model.bundleID];
        }else {
           
            [[PAS_DownLoadingApps sharedInstance] removeFollowAppsWithBuildId:model.bundleID];
        }
        
    };
    return cell;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(findIconGap,sideGap, 10, sideGap);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PASDiscoverModel *model = [_dataArr objectAtIndex:indexPath.row];
    PASDescoverListViewController *listViewC = [[PASDescoverListViewController alloc] init];
    listViewC.bundleID = model.bundleID;
    listViewC.name = model.name;
    [self.navigationController pushViewController:listViewC animated:YES];
    
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
