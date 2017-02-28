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
NSString * const cellRes = @"PASDisListTableViewCell";
@interface PASDescoverListViewController ()<UITableViewDelegate,UITableViewDataSource> {

    UITableView *_listTableView;
}

@end

@implementation PASDescoverListViewController
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
    
    self.navigationItem.title = @"这是应用名字";
}
- (void)initView {

    [self initTableView];
}
- (void)initTableView {
    _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.rowHeight = 100;
    [_listTableView registerClass:[PASDisListTableViewCell class] forCellReuseIdentifier:cellRes];
    [self.view addSubview:_listTableView];
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PASDisListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellRes];
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
