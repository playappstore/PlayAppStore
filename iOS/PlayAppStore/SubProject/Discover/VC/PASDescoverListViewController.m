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
NSString * const cellRes = @"PASDisListTableViewCell";
@interface PASDescoverListViewController ()<UITableViewDelegate,UITableViewDataSource> {

    UITableView *_listTableView;
    NSMutableArray *_dataArr;
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
