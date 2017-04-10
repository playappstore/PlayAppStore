//
//  PASApplicationDetailController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASApplicationDetailController.h"
#import "PASApplicationDetailCell.h"
#import "PASApplicationDetailSwitchCell.h"
#import "PASShareActivity.h"
#import "PASQRCodeActionSheet.h"
#import "PASDiccoverAppManager.h"
#import "PASDiscoverModel.h"
#import "PASDetailHeaderView.h"
#import "QMUINavigationController.h"
#import "UIImage+QMUI.h"
#import "PASApplication.h"
#import "PAS_DownLoadingApps.h"
static NSInteger NAVBAR_CHANGE_POINT = 120;

@interface PASApplicationDetailController () <UITableViewDelegate, UITableViewDataSource, PASApplicationDetailSwitchCellDelegate, PASShareActivityDelegate, PASDiccoverAppManagerDelegate>
@property (nonatomic ,weak) NSProgress *weakProgress;
@property (nonatomic, strong) PASDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) PASQRCodeActionSheet *qrCodeView;
@property (nonatomic, strong) PASDiccoverAppManager *appManager;

@end

@implementation PASApplicationDetailController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadNav];
//    [self addSubviews];
    [self initData];
    [self initView];
}
- (void)initView {

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];
}
- (void)initData {

     [self.appManager refreshWithBundleID:self.model.bundleID buildID:self.model.objectId];
}
- (void)initTableView {

    self.detailTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    PASDetailHeaderView *headerView = [[PASDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 280)];
    headerView.logoImage = self.logoImage;
    self.headerView = headerView;
    [headerView addScrollview:self.detailTableView];
    self.detailTableView.tableHeaderView = headerView;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.view addSubview:self.detailTableView];

    
    __weak PASApplicationDetailController *weakself = self;
    
    headerView.downloadClicked = ^(PKDownloadButtonState state) {
        if (state == kPKDownloadButtonState_Pending) {
            //点击下载按钮
            [weakself downLoadAppWithBundleIdentifier:weakself.model.bundleID manifestURL:[NSURL URLWithString:weakself.model.url] bundleVersion:weakself.model.version PKDownloadButton:headerView.downloadButton];
        }else if (state == kPKDownloadButtonState_Downloaded){
            
            //打开应用
            
            PASApplication *app = [[PASApplication alloc] initWithBundleIdentifier:weakself.model.bundleID manifestURL:[NSURL URLWithString:weakself.model.url] bundleVersion:weakself.model.version];
            [app launch];
            
        }
    };

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
                
//                NSDictionary *dataDic = @{@"version":_downloadingModel.version,@"bundleID":_downloadingModel.bundleID,@"progress":progress,@"uploadTime":_downloadingModel.updatedAt};
//                [[PAS_DownLoadingApps sharedInstance].appDic setObject:dataDic forKey:_downloadingModel.name];
                
            }
            downloadButton.stopDownloadButton.progress = progress.fractionCompleted ;
        });
    }else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}
- (void)dealloc {

    [self.headerView headerRemoveOber];
    if (self.weakProgress) {
        [_weakProgress removeObserver:self forKeyPath:@"fractionCompleted"];
    }
}

#pragma mark - PASAppManagerDelegate
- (void)requestBuildDetailSuccessed {
    [DejalBezelActivityView removeViewAnimated:NO];
    PASDiscoverModel *model = [_appManager.appListArr safeObjectAtIndex:0];
    self.headerView.label.text = model.name;
    [self.detailTableView reloadData];
//    self.headerView.titleImageView.image = [UIImage imageNamed:model.url];
//    self.headerView.wholeImageView.image = self.headerView.titleImageView.image;
//    self.headerView.titleLabel.text = model.name;
//    [self.detailTableView reloadData];
}
- (void)requestBuildDetailFailureWithError:(NSError *)error {
    //
    [DejalBezelActivityView removeViewAnimated:NO];
}


#pragma mark - PASApplicationDetailHeaderViewDelegate
- (void)shareButtonDidTap:(UIButton *)shareButton {
    NSLog(@"========ShareButtonAleadyClicked, please do next!=====");
    NSString *text = @"分享内容";
    
    UIImage *image = [UIImage imageNamed:@"pas_QRCode"];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    
    //数组中放入分享的内容
    
    NSArray *activityItems = @[text, image, url];
    
    //自定义 customActivity继承于UIActivity,创建自定义的Activity加在数组Activities中。
    PASShareActivity * custom = [[PASShareActivity alloc] initWithTitie:@"二维码" withActivityImage:[UIImage imageNamed:@"pas_QRCode"] withUrl:url withType:@"customActivity" withShareContext:activityItems];
    custom.delegate = self;
    NSArray *activities = @[custom];
    
    // 实现服务类型控制器
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToVimeo, UIActivityTypePrint, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToTencentWeibo, UIActivityTypeCopyToPasteboard];
    // 分享类型
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        // 显示选中的分享类型
        NSLog(@"当前选择分享平台 %@",activityType);
        
        if (completed) {
            
            NSLog(@"分享成功");
            
        }else {
            
            NSLog(@"分享失败");
            
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - PASApplicationDetailSwitchDelegate
- (void)switchButtonStateChanged:(BOOL)state {
    //TODO

}

#pragma mark - PASShareActivityDelegate
- (void)qrCodeTaped {
    NSLog(@"二维码被点击了");
    _qrCodeView = [[PASQRCodeActionSheet alloc] initWithDownloadURLString:@"https://github.com/playappstore/PlayAppStore"];
    [_qrCodeView show];
}

#pragma mark - UITableView Delegate & DataResource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PASApplicationDetailSwitchCell *cell = [PASApplicationDetailSwitchCell cellCreatedWithTableView:tableView];
        cell.delegate = self;
        return cell;
    } else {
        PASApplicationDetailCell *cell = [PASApplicationDetailCell cellCreatedWithTableView:tableView];
        [cell configWithModel:[_appManager.appListArr safeObjectAtIndex:0] index:indexPath.section];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44 : 70;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    NSLog(@"scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >self.headerView.height) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat ory = 0;
    if ((self.headerView.snap.size.height - 64)> offsetY) {
        ory = offsetY;
    }else {
        ory = self.headerView.snap.size.height - 64;
    }
//    if (offsetY > (NAVBAR_CHANGE_POINT-44)) {
//        UIImage *snap = [self.headerView.snap qmui_imageWithClippedRect:CGRectMake(0, ory, [UIScreen mainScreen].bounds.size.width, 64)];
//        [self setNavigationBarBackgroundImage:snap];
//    } else {
        if (offsetY > 0) {
            UIImage *snap = [self.headerView.snap qmui_imageWithClippedRect:CGRectMake(0, ory, [UIScreen mainScreen].bounds.size.width, 64)];
            [self setNavigationBarBackgroundImage:snap];
        }else {
            UIImage *image = [UIImage qmui_imageWithColor:[UIColor clearColor]];
            [self setNavigationBarBackgroundImage:image];

        }
        
//    }
}

- (void)setNavigationBarBackgroundImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - QMUINavigationControllerDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:[UIColor clearColor]];
}
- (nullable UIImage *)navigationBarShadowImage {
    return [UIImage new];
}
#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = PASLocalizedString(@"Application Detail", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"pas_share"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)addSubviews {
    [self.view addSubview:self.detailTableView];
    self.detailTableView.tableHeaderView = self.headerView;
    self.detailTableView.rowHeight = UITableViewAutomaticDimension;
    self.detailTableView.estimatedRowHeight = 60;
}

//- (UITableView *)detailTableView {
//    if (!_detailTableView) {
//        _detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _detailTableView.delegate = self;
//        _detailTableView.dataSource = self;
//        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    return _detailTableView;
//}
//- (PASApplicationDetailHeadView *)headerView {
//    if (!_headerView) {
//        _headerView = [[PASApplicationDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
//    }
//    return _headerView;
//}

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
