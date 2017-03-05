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
NSString * const cellRes = @"PASDisListTableViewCell";
@interface PASDescoverListViewController ()<UITableViewDelegate,UITableViewDataSource> {

    UITableView *_listTableView;
    NSMutableArray *_dataArr;
}
@property (nonatomic ,weak) NSProgress *weakProgress;
@end

@implementation PASDescoverListViewController
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
  
    // Do any additional setup after loading the view.
}
- (void)initData {
    
    self.navigationItem.title = self.name;
    _dataArr = [[NSMutableArray alloc] init];
    [self requestApp];
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
- (void)requestApp {

    PASConfiguration *config = [PASConfiguration shareInstance];
    config.baseURL = [NSURL URLWithString:@"http://45.77.13.248:3000/apps/ios"];
    [[[PASDataProvider alloc] initWithConfiguration:config] getAllBuildsWithParameters:nil bundleID:self.bundleID completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestWithResponseObject:responseObject];
    }];

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
        [_listTableView reloadData];
    }
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
            }
            downloadButton.stopDownloadButton.progress = progress.fractionCompleted ;
        });
    }else {
    
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    }
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return _dataArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PASDiscoverModel *model = [_dataArr objectAtIndex:indexPath.row];
    PASDisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes];
//    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    cell.upDataTimeLabel.text = [NSString stringWithFormat:@"更新时间：%@", model.uploadTime];
    cell.versionsLabel.text = [NSString stringWithFormat:@"版本：%@", model.version];
    cell.describeLabel.text = model.changelog;
    cell.downloadButton.state = kPKDownloadButtonState_StartDownload;
    __weak PASDescoverListViewController *weakself = self;
//    [cell setDownloadButtonEnable:YES];
    cell.downloadClicked = ^() {
        //点击下载按钮
        [weakself downLoadAppWithBundleIdentifier:model.bundleID manifestURL:[NSURL URLWithString:model.url] bundleVersion:model.version PKDownloadButton:cell.downloadButton];
        
    };

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PASApplicationDetailController *detailController = [[PASApplicationDetailController alloc] init];
    [self.navigationController pushViewController:detailController animated:YES];

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
