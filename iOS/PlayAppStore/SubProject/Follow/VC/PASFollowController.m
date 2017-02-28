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
NSString * const cellRes1 = @"PASDisListTableViewCell1";
@interface PASFollowController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_followTableView;

}

@end

@implementation PASFollowController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    
    // Do any additional setup after loading the view.
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
    _followTableView.rowHeight = PASDisListTableViewCellHeight;
    _followTableView.sectionHeaderHeight = 40;
    [_followTableView registerClass:[PASDisListTableViewCell class] forCellReuseIdentifier:cellRes1];
    [self.view addSubview:_followTableView];
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [UIView new];

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return @"应用名称a";

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PASDisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes1];
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
