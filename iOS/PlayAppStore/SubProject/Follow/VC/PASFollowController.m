//
//  PASFollowController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASFollowController.h"
#import "PASDisListTableViewCell.h"
#import "PASApplicationDetailController.h"
#import "PASFollowTableViewCell.h"
#import "PASDescoverListViewController.h"
#import "PAS_DownLoadingApps.h"
#import "PASConfiguration.h"
#import "PASDataProvider.h"
#import "PASDiscoverModel.h"
#import "PASFollowManager.h"
NSString * const cellRes1 = @"PASDisListTableViewCell1";
NSString * const cellRes2 = @"PASFollowTableViewCell";
@interface PASFollowController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_followTableView;

}
@property (nonatomic ,strong) NSDictionary *dataDic;
@end

@implementation PASFollowController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if ([PAS_DownLoadingApps sharedInstance].followApps.count) {
        [self requestFollowApps];
    }else {
        //没有收藏的应用
        [_followTableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}
- (void)initData {
  
    
}
- (void)initView {
    
    [self initTableView];
}
- (void)initTableView {
    
    _followTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _followTableView.delegate = self;
    _followTableView.dataSource = self;
    [_followTableView registerClass:[PASDisListTableViewCell class] forCellReuseIdentifier:cellRes1];
    [_followTableView registerClass:[PASFollowTableViewCell class] forCellReuseIdentifier:cellRes2];
    [self.view addSubview:_followTableView];
}
- (NSDictionary *)dataDic {

    if (!_dataDic) {
        _dataDic = [[NSDictionary alloc] init];
    }

    return _dataDic;
}
- (void)requestFollowApps {
    
    [[[PASFollowManager alloc] init] requestAllFollowAppsWithBundleIDs:[PAS_DownLoadingApps sharedInstance].followApps success:^(NSDictionary *dataDic) {
        
        _dataDic = dataDic;
        [_followTableView reloadData];
    } fail:^(NSString *code, NSString *message) {
        
        [_followTableView reloadData];
        
    }];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [[_dataDic allKeys] objectAtIndex:section];
    NSArray *dataArr = [_dataDic objectForKey:key];
    return dataArr.count + 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataDic.allKeys.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    return PASDisListTableViewCellHeight;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [[_dataDic allKeys] objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
         PASFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes2];
        cell.nameLabel.text = key ;
        return cell;
    }
    
    NSArray *dataArr = [_dataDic objectForKey:key];
    PASDisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes1];
    PASDiscoverModel *model = [dataArr objectAtIndex:indexPath.row - 1];
    //给cell赋值显示
    [cell setValueWithUploadTime:model.uploadTime version:model.name changelog:model.changelog iconUrl:model.icon];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = [[_dataDic allKeys] objectAtIndex:indexPath.section];
    NSArray *dataArr = [_dataDic objectForKey:key];
    if (indexPath.row == 0) {
        //更多
        PASDiscoverModel *model = [dataArr objectAtIndex:0];
        PASDescoverListViewController *listViewController = [[PASDescoverListViewController alloc] init];
        listViewController.bundleID = model.bundleID;
         [self.navigationController pushViewController:listViewController animated:YES];
        
    }else {
   
        PASDiscoverModel *model = [dataArr objectAtIndex:indexPath.row - 1];
        PASApplicationDetailController *detailController = [[PASApplicationDetailController alloc] init];
        detailController.model = model;
        [self.navigationController pushViewController:detailController animated:YES];
        
    }
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
