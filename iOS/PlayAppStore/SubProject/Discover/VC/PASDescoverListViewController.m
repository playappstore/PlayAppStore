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
#import "PASConfiguration.h"
#import "PASDataProvider.h"
#import "PASDiscoverModel.h"
#import "PASApplication.h"
#import "PAS_DownLoadingApps.h"
#import "PASDiccoverAppManager.h"
#import "PASDiscoverModel.h"

NSString * const cellRes = @"PASDisListTableViewCell";
@interface PASDescoverListViewController ()<UITableViewDelegate,UITableViewDataSource, PASDiccoverAppManagerDelegate> {

    UITableView *_listTableView;
    NSMutableArray *_dataArr;
}
@property (nonatomic ,weak) NSProgress *weakProgress;
@property (nonatomic ,strong) PASDiscoverModel *downloadingModel;
@property (nonatomic, strong) PASDiccoverAppManager *appManager;

@end

@implementation PASDescoverListViewController

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    
    self.navigationItem.title = self.name;
   [self.appManager refreshWithBundleID:self.bundleID];

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
- (void)downLoadAppWithBundleIdentifier:(NSString *)bundleIdentifier
                            manifestURL:(NSURL *)manifestURL
                          bundleVersion:(NSString *)bundleVersion
                       PKDownloadButton:(PKDownloadButton *)downloadButton{
    PASApplication *app = [[PASApplication alloc] initWithBundleIdentifier:bundleIdentifier manifestURL:manifestURL bundleVersion:bundleVersion];
    NSProgress *progress;
    [app installWithProgress:&progress completion:^(BOOL finished, NSError *error) {
       
//        NSLog(@"完成");
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
//            NSLog(@"progress: %@", @(progress.fractionCompleted));
            
            PKDownloadButton *downloadButton = (__bridge PKDownloadButton*)context;
            if (progress.fractionCompleted >0) {
                //大于0的时候开始走进度
                 downloadButton.state = kPKDownloadButtonState_Downloading;
                //假如开始安装
                
                NSDictionary *dataDic = @{@"version":_downloadingModel.version,@"bundleID":_downloadingModel.bundleID,@"progress":progress,@"uploadTime":_downloadingModel.uploadTime};
                [[PAS_DownLoadingApps sharedInstance].appDic setObject:dataDic forKey:_downloadingModel.name];
                
            }
            downloadButton.stopDownloadButton.progress = progress.fractionCompleted ;
        });
    }else {
    
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    }
}
#pragma mark - PASDiscoverAllAppsDelegate
- (void)requestAllBuildsSuccessed {
    //
    [_listTableView reloadData];
    
}
- (void)requestAllBuildsFailureWithError:(NSError *)error {
    
    //失败
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return _appManager.appListArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PASDiscoverModel *model = [_appManager.appListArr objectAtIndex:indexPath.row];
    PASDisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes];
    //给cell赋值显示
    [cell setValueWithUploadTime:model.uploadTime version:model.name changelog:model.changelog iconUrl:model.icon];
    //设置下载按钮的状态
    [self setDownLoadButtonStateWithCell:cell model:model];
    
   
    __weak PASDescoverListViewController *weakself = self;

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

    PASApplicationDetailController *detailController = [[PASApplicationDetailController alloc] init];
    detailController.model = [_appManager.appListArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];

}
- (void)setDownLoadButtonStateWithCell:(PASDisListTableViewCell *)cell model:(PASDiscoverModel*)model{
    
    NSDictionary *app =  [PAS_DownLoadingApps sharedInstance].appDic;
    NSArray *appNameArr = app.allKeys;
    
    if ([appNameArr containsObject:model.name]) {
        
        NSDictionary *dataDic =[app objectForKey:model.name];
        if ([[dataDic objectForKey:@"version"] isEqualToString:model.version]&&[[dataDic objectForKey:@"bundleID"] isEqualToString:model.bundleID]&&[[dataDic objectForKey:@"uploadTime"] isEqualToString:model.uploadTime]) {
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
