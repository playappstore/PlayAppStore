//
//  PASChangeLanguageController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASChangeLanguageController.h"
#import "PASChangeLanguageCell.h"
#import "PASLocalizableManager.h"

@interface PASChangeLanguageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation PASChangeLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];

}

#pragma mark - PASChangeLanguageDelegate 
- (void)defaultLanguageCharged {
    [[PASLocalizableManager shareInstance] setUserlanguage:PASCHINESE];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PASChangeLanguageCell * cell = [PASChangeLanguageCell cellCreatedWithTableView:tableView];
    if (indexPath.row == 0) {
        //cell.defaultCard.selected = YES;
    }
    //cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = NSLocalizedString(@"Language setting", nil);
    self.view.backgroundColor = RGBCodeColor(0xf2f2f2);

}

- (void)addSubviews {
    
    [self.view addSubview:self.tableView];
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
