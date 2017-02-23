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

@interface PASApplicationDetailController () <UITableViewDelegate, UITableViewDataSource, PASApplicationDetailHeadViewDelegate, PASApplicationDetailSwitchCellDelegate>

@property (nonatomic, strong) PASApplicationDetailHeadView *headerView;
@property (nonatomic, strong) UITableView *detailTableView;


@end

@implementation PASApplicationDetailController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
    [self configData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navLine.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - PASApplicationDetailHeaderViewDelegate
- (void)backButtonDidTap:(UIButton *)cityButton {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareButtonDidTap:(UIButton *)shareButton {
    NSLog(@"========ShareButtonAleadyClicked, please do next!=====");
}


#pragma mark - PASApplicationDetailSwitchDelegate
- (void)switchButtonStateChanged:(BOOL)state {
    //TODO

}


#pragma mark - UITableView Delegate & DataResource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PASApplicationDetailSwitchCell *cell = [PASApplicationDetailSwitchCell cellCreatedWithTableView:tableView];
        cell.delegate = self;
        return cell;
    } else {
        PASApplicationDetailCell *cell = [PASApplicationDetailCell cellCreatedWithTableView:tableView];
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
    self.title = @"Application Detail";
    self.view.backgroundColor = [UIColor whiteColor];    
}

- (void)addSubviews {
    [self.view addSubview:self.detailTableView];
    self.detailTableView.backgroundColor = [UIColor greenColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.headerView];
    self.headerView.scrollView = self.detailTableView;
}

- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT-150)];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _detailTableView;
}
- (PASApplicationDetailHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[PASApplicationDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)configData {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
