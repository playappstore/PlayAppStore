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
#import "PASApplicationDetailHeadView.h"
#import "PASShareActivity.h"
#import "PASQRCodeActionSheet.h"
#import "PASDiccoverAppManager.h"
#import "PASDiscoverModel.h"


@interface PASApplicationDetailController () <UITableViewDelegate, UITableViewDataSource, PASApplicationDetailSwitchCellDelegate, PASShareActivityDelegate, PASDiccoverAppManagerDelegate>

@property (nonatomic, strong) PASApplicationDetailHeadView *headerView;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) PASQRCodeActionSheet *qrCodeView;
@property (nonatomic, strong) PASDiccoverAppManager *appManager;

@end

@implementation PASApplicationDetailController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navLine.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [DejalActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [self.appManager refreshWithBundleID:self.model.bundleID buildID:self.model.build];
}

#pragma mark - PASAppManagerDelegate
- (void)requestBuildDetailSuccessed {
    [DejalActivityView removeView];
    PASDiscoverModel *model = [_appManager.appListArr safeObjectAtIndex:0];
    self.headerView.titleImageView.image = [UIImage imageNamed:model.url];
    self.headerView.wholeImageView.image = self.headerView.titleImageView.image;
    self.headerView.titleLabel.text = model.name;
    [self.detailTableView reloadData];
}
- (void)requestBuildDetailFailureWithError:(NSError *)error {
    //
    [DejalActivityView removeView];

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
        [cell configWithModel:[_appManager.appListArr safeObjectAtIndex:0]];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 60 : 120;
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

- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _detailTableView;
}
- (PASApplicationDetailHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[PASApplicationDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    return _headerView;
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
