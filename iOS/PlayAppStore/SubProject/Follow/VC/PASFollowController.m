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
#import "MJRefresh.h"
#import "PASApplication.h"
NSString * const cellRes1 = @"PASDisListTableViewCell1";
NSString * const cellRes2 = @"PASFollowTableViewCell";
@interface PASFollowController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic ,strong) PASMBView *hubView;
@property (nonatomic ,strong) UITableView *followTableView;
@property (nonatomic ,strong) PASDiscoverModel *downloadingModel;
@property (nonatomic ,weak) NSProgress *weakProgress;
@end

@implementation PASFollowController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if ([PAS_DownLoadingApps sharedInstance].followApps.count) {

        [_hubView hidden];
       _hubView = [PASMBView showPVAddedTo:self.followTableView message:PASLocalizedString(@"Processing", nil)];
        [self requestFollowApps];
    }else {
        //没有收藏的应用
        [_followTableView reloadData];
    }
}
- (void)dealloc {
    
    if (self.weakProgress) {
        [_weakProgress removeObserver:self forKeyPath:@"fractionCompleted"];
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
    
    [self.view addSubview:self.followTableView];
}
- (UITableView *)followTableView {

    if (!_followTableView) {
        _followTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _followTableView.delegate = self;
        _followTableView.dataSource = self;
        [_followTableView registerClass:[PASDisListTableViewCell class] forCellReuseIdentifier:cellRes1];
        [_followTableView registerClass:[PASFollowTableViewCell class] forCellReuseIdentifier:cellRes2];
        __weak PASFollowController *weakself = self;
        _followTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            //下拉刷新
            if ([PAS_DownLoadingApps sharedInstance].followApps.count) {
                [weakself requestFollowApps];
            }else {
            
                [weakself.followTableView.mj_header endRefreshing];
            
            }
        }];
        _followTableView.tableFooterView = [UIView new];
    }
    return _followTableView;
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
        [_followTableView.mj_header endRefreshing];
        [_hubView hidden];
    } fail:^(NSString *code, NSString *message) {
        
        [_followTableView reloadData];
        [_followTableView.mj_header endRefreshing];
        [_hubView hidden];
        _hubView = [PASMBView showErrorPVAddedTo:self.followTableView message:@"请求失败请稍候再试"];

    }];
}
- (void)downLoadAppWithBundleIdentifier:(NSString *)bundleIdentifier
                            manifestURL:(NSURL *)manifestURL
                          bundleVersion:(NSString *)bundleVersion
                       PKDownloadButton:(PKDownloadButton *)downloadButton{
    
    PASApplication *app = [[PASApplication alloc] initWithBundleIdentifier:bundleIdentifier manifestURL:manifestURL bundleVersion:bundleVersion];
    NSProgress *progress;
    [app installWithProgress:&progress completion:^(BOOL finished, NSError *error) {
        
        downloadButton.stopDownloadButton.progress =1;
        downloadButton.state = kPKDownloadButtonState_Downloaded;
        
    }];
    if (progress) {
        
        _weakProgress = progress;
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionInitial context:(__bridge void * _Nullable)(downloadButton)];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PKDownloadButton *downloadButton = (__bridge PKDownloadButton*)context;
            if (progress.fractionCompleted >0) {
                //大于0的时候开始走进度
                downloadButton.state = kPKDownloadButtonState_Downloading;
                //假如开始安装
                
                NSDictionary *dataDic = @{@"version":_downloadingModel.version,@"bundleID":_downloadingModel.bundleID,@"progress":progress,@"uploadTime":_downloadingModel.updatedAt};
                [[PAS_DownLoadingApps sharedInstance].appDic setObject:dataDic forKey:_downloadingModel.name];
                
            }
            downloadButton.stopDownloadButton.progress = progress.fractionCompleted ;
        });
    }else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}
- (void)setDownLoadButtonStateWithCell:(PASDisListTableViewCell *)cell model:(PASDiscoverModel*)model{
    
    NSDictionary *app =  [PAS_DownLoadingApps sharedInstance].appDic;
    NSArray *appNameArr = app.allKeys;
    
    if ([appNameArr containsObject:model.name]) {
        
        NSDictionary *dataDic =[app objectForKey:model.name];
        if ([[dataDic objectForKey:@"version"] isEqualToString:model.version]&&[[dataDic objectForKey:@"bundleID"] isEqualToString:model.bundleID]&&[[dataDic objectForKey:@"uploadTime"] isEqualToString:model.updatedAt]) {
            
            _downloadingModel = model;
            NSProgress *progress = [dataDic objectForKey:@"progress"];
            cell.downloadButton.state = kPKDownloadButtonState_Downloading;
            cell.downloadButton.stopDownloadButton.progress = progress.fractionCompleted ;
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionInitial context:(__bridge void * _Nullable)(cell.downloadButton)];
        }
    }else {
        
        cell.downloadButton.state = kPKDownloadButtonState_StartDownload;
        
    }
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
    [cell setValueWithUploadTime:model.updatedAt version:model.version changelog:model.changelog iconUrl:model.icon];
    //设置下载按钮的状态
    [self setDownLoadButtonStateWithCell:cell model:model];
    __weak PASFollowController *weakself = self;
    cell.downloadClicked = ^(PKDownloadButtonState state) {
        if (state == kPKDownloadButtonState_Pending) {
            weakself.downloadingModel = model;
            //点击下载按钮
            [weakself downLoadAppWithBundleIdentifier:model.bundleID manifestURL:[NSURL URLWithString:model.url] bundleVersion:model.version PKDownloadButton:cell.downloadButton];
        }else if (state == kPKDownloadButtonState_Downloaded){
            
            //打开应用
            
            PASApplication *app = [[PASApplication alloc] initWithBundleIdentifier:model.bundleID manifestURL:[NSURL URLWithString:model.url] bundleVersion:model.version];
            [app launch];
            
        }
    };


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
