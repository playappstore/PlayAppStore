//
//  PASChangeLanguageController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASChangeLanguageController.h"
#import "PASLocalizableManager.h"

@interface PASChangeLanguageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation PASChangeLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLanguageData];
    [self loadNav];
    [self addSubviews];

}

#pragma mark - PASChangeLanguageDelegate 
- (void)changeLanguageButtonTapedWithIndex:(NSIndexPath *)index {
    if (index.row == 0) {
        return;
    }
    
    NSString *str = [self.dataArray safeObjectAtIndex:0];
    if ([str isEqualToString:@"简体中文"]) {
        [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
        [self.tableView reloadData];
        [[PASLocalizableManager shareInstance] setUserlanguage:PASENGLISH];
    } else {
        [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
        [self.tableView reloadData];
//        if (IOS9_OR_LATER) {
//            [[PASLocalizableManager shareInstance] setUserlanguage:PASCHINESE_IOS9];
//        } else {
//            [[PASLocalizableManager shareInstance] setUserlanguage:PASCHINESE];
//        }
        [[PASLocalizableManager shareInstance] setUserlanguage:PASCHINESE];

    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * ID = @"PASChangeLanguageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"morenka-xuanzhong"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"morenka-weixuan"];
    }
    cell.textLabel.text = [self.dataArray  safeObjectAtIndex:indexPath.row];
    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self changeLanguageButtonTapedWithIndex:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}

#pragma mark - Setter && Getter
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)configLanguageData {
    
    self.dataArray = [NSMutableArray arrayWithCapacity:2];
    NSString *languageString = [[NSUserDefaults standardUserDefaults] valueForKey:PASLanguageKey];
    if ([[[PASLocalizableManager shareInstance] chinese] containsObject:languageString]) {
        [self.dataArray safeAddObject:@"简体中文"];
        [self.dataArray safeAddObject:@"English"];
    } else {
        [self.dataArray safeAddObject:@"English"];
        [self.dataArray safeAddObject:@"简体中文"];
    }
}

- (void)loadNav {
    self.title = PASLocalizedString(@"Language setting", nil);
    self.view.backgroundColor = RGBCodeColor(0xf2f2f2);
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
