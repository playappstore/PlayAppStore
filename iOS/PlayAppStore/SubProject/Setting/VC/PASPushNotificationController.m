//
//  PASPushNotificationController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASPushNotificationController.h"
#import "PASApplicationDetailSwitchCell.h"
#import "PASTextLabelCell.h"



@interface PASPushNotificationController () <UITableViewDelegate, UITableViewDataSource, PASApplicationDetailSwitchCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PASPushNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
    
}

#pragma mark - PASApplicationDetailSwitchDelegate
- (void)switchButtonStateChanged:(BOOL)state {
    //TODO
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PASApplicationDetailSwitchCell *cell = [PASApplicationDetailSwitchCell cellCreatedWithTableView:tableView];
        cell.delegate = self;
        return cell;
    } else {
        PASTextLabelCell *cell = [PASTextLabelCell cellCreatedWithTableView:tableView];
        cell.des1.text = NSLocalizedString(@"PlayAppStore is the platform to help the team quickly and reliably test its own application software. If you close the push, you will not receive the updated push notification for the first time.", nil);
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Setter && Getter
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = NSLocalizedString(@"Push notification", nil);
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
