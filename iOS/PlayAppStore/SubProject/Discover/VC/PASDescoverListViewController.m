//
//  PASDescoverListViewController.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/2/27.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDescoverListViewController.h"
#import "PASDisListTableViewCell.h"
#import "PASApplicationDetailController.h"
#import "PASDiccoverAppManager.h"
#import "PASDiscoverModel.h"

NSString * const cellRes = @"PASDisListTableViewCell";
@interface PASDescoverListViewController ()<UITableViewDelegate,UITableViewDataSource, PASDiccoverAppManagerDelegate> {

    UITableView *_listTableView;
}
@property (nonatomic, strong) PASDiccoverAppManager *appManager;

@end

@implementation PASDescoverListViewController

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.appManager refreshWithBundleID:self.model.bundleID];
}


#pragma mark - PASDiscoverAllAppsDelegate
- (void)requestAllBuildsSuccessed {
    //
    [_listTableView reloadData];
    
}
- (void)requestAllBuildsFailureWithError:(NSError *)error {
    
    //
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appManager.appListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PASDisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes];
    PASDiscoverModel *model = [_appManager.appListArr safeObjectAtIndex:indexPath.row];
    [cell configViewWithData:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PASApplicationDetailController *detailController = [[PASApplicationDetailController alloc] init];
    [self.navigationController pushViewController:detailController animated:YES];

}

- (void)initData {
    
    self.navigationItem.title = self.model.PAS_AppName;
}
- (void)initView {
    
    [self initTableView];
}
- (void)initTableView {
    _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.rowHeight = PASDisListTableViewCellHeight;
    [_listTableView registerClass:[PASDisListTableViewCell class] forCellReuseIdentifier:cellRes];
    [self.view addSubview:_listTableView];
}

- (PASDiccoverAppManager *)appManager {
    if (!_appManager) {
        _appManager = [[PASDiccoverAppManager alloc] init];
        _appManager.delegate = self;
    }
    return _appManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
