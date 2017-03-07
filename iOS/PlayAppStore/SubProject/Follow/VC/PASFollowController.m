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
NSString * const cellRes1 = @"PASDisListTableViewCell1";
NSString * const cellRes2 = @"PASFollowTableViewCell";
@interface PASFollowController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_followTableView;
    NSMutableDictionary *_dataDic;

}

@end

@implementation PASFollowController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    _dataDic = [[NSMutableDictionary alloc] init];
    if ([PAS_DownLoadingApps sharedInstance].followApps.count) {
        [self requestFollowApps];
    }else {
        //没有收藏的应用
    }
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
    [_followTableView registerClass:[PASDisListTableViewCell class] forCellReuseIdentifier:cellRes1];
     [_followTableView registerClass:[PASFollowTableViewCell class] forCellReuseIdentifier:cellRes2];
    [self.view addSubview:_followTableView];
}
- (void)requestFollowApps {

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < [PAS_DownLoadingApps sharedInstance].followApps.count; i++) {
        
        NSString *bundleID = [PAS_DownLoadingApps sharedInstance].followApps[i];
        dispatch_group_async(group, queue, ^{
          
            PASConfiguration *config = [PASConfiguration shareInstance];
            config.baseURL = [NSURL URLWithString:@"http://45.77.13.248:3000/apps/ios"];
            [[[PASDataProvider alloc] initWithConfiguration:config] getAllBuildsWithParameters:nil bundleID:bundleID completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                [self handleRequestWithResponseObject:responseObject];
                 dispatch_group_leave(group);
            }];
           
        });
        dispatch_group_enter(group);
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"%@",_dataDic);
        [_followTableView reloadData];
    });
}
- (void)handleRequestWithResponseObject:(id)responseObject {
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray *)responseObject;
        NSMutableArray *dataArra = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary *dataDic = dataArr[i];
            PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:dataDic];
            model.pas_id = [dataDic objectForKey:@"id"];
            [dataArra addObject:model];
            if (i == dataArr.count -1) {
                [_dataDic setObject:dataArra forKey:model.name];
            }
        }
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
    [cell setValueWithUploadTime:model.uploadTime version:model.name changelog:model.changelog iconUrl:model.icon];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //更多
        PASDescoverListViewController *listViewController = [[PASDescoverListViewController alloc] init];
         [self.navigationController pushViewController:listViewController animated:YES];
        
    }else {
    
        PASApplicationDetailController *detailController = [[PASApplicationDetailController alloc] init];
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
