//
//  PASSettingController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASSettingController.h"
#import "PASServerAddressController.h"
#import "PASLoacalDataManager.h"
#import "MBProgressHUD.h"
#import "PASChangeLanguageController.h"
#import "PASPushNotificationController.h"
#import "PASDesignerController.h"




@interface PASSettingController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, copy) NSArray *settingArray;
@property (nonatomic, copy) NSArray *manualArray;
@property (nonatomic, copy) NSArray *otherArray;
@property (nonatomic, copy) NSArray *aboutArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat cacheSize;

@end

@implementation PASSettingController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self configData];
    [self addSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navLine.hidden = YES;
}




- (void)didSelectRowWithActionTag:(NSInteger)tag
{
    switch (tag) {
        case 100:
        {
            //server address
            PASServerAddressController *listViewC = [[PASServerAddressController alloc] init];
            [self presentViewController:listViewC animated:YES completion:nil];
        }
            break;
            
        case 101:
        {
            //language
            PASChangeLanguageController *listViewC = [[PASChangeLanguageController alloc] init];
            [self.navigationController pushViewController:listViewC animated:YES];
        }
            break;
        case 102:
        {
            //notifications
            PASPushNotificationController *listViewC = [[PASPushNotificationController alloc] init];
            [self.navigationController pushViewController:listViewC animated:YES];

        }
            break;
        case 103:
        {
            //shortcut
        }
            break;
        case 104:
        {
            //display settings
        }
            break;

        case 105:
        {
            //manual
        }
            break;

        case 106:
        {
            //faq
        }
            break;

        case 107:
        {
           //clear cache
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PASLocalizedString(@"Are you sure to clear the cache?", nil) message:nil delegate:self cancelButtonTitle:PASLocalizedString(@"Cancel", nil) otherButtonTitles:PASLocalizedString(@"Confirm", nil), nil];
            [alert show];
        }
            break;

        case 108:
        {
           //share app to your frieds
            [self shareAppToFriends];
        }
            break;

        case 109:
        {
            //designer
            PASDesignerController *listViewC = [[PASDesignerController alloc] init];
            [self.navigationController pushViewController:listViewC animated:YES];
        }
            break;
        case 110:
        {
            //follow us
        }
            break;

        default:
            break;
    }
}

#pragma mark - Share
- (void)shareAppToFriends {
    NSString *text = @"分享内容";
    UIImage *image = [UIImage imageNamed:@"pas_QRCode"];
    NSURL *url = [NSURL URLWithString:@"https://github.com/playappstore/PlayAppStore"];
    NSArray *activityItems = @[text, image, url];
    
    // 实现服务类型控制器
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){

        NSLog(@"当前选择分享平台 %@",activityType);
        if (completed) {
            
            NSLog(@"分享成功");
            
        }else {
            
            NSLog(@"分享失败");
            
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark -AboutUS
//- (void)openScheme:(NSString *)scheme {
//    UIApplication *application = [UIApplication sharedApplication];
//    NSURL *URL = [NSURL URLWithString:scheme];
//    
//    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
//        [application openURL:URL options:@{}
//           completionHandler:^(BOOL success) {
//               NSLog(@"Open %@: %d",scheme,success);
//           }];
//    } else {
//        BOOL success = [application openURL:URL];
//        NSLog(@"Open %@: %d",scheme,success);
//    }
//}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self clearCacheButtonClicked];
    }
}

- (void)clearCacheButtonClicked
{
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (_cacheSize > 0) {
        
        [PASLoacalDataManager clearDiskCache];
        hub.mode = MBProgressHUDModeText;
        
        hub.label.text = PASLocalizedString(@"Clear success", nil);
        hub.completionBlock = ^ {
            [self.tableView reloadData];
        };
        [hub hideAnimated:YES afterDelay:2];
    } else {
        
        hub.mode = MBProgressHUDModeText;
        
        hub.label.text = PASLocalizedString(@"There is no cache yet", nil);
        hub.completionBlock = ^ {
        };
        [hub hideAnimated:YES afterDelay:2];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _settingArray.count;
    } else if (section == 1) {
        return _otherArray.count;
    } else {
        return _aboutArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * ID = @"PASSettingActionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSArray *targetArray = [NSArray array];
    if (indexPath.section == 0) {
        targetArray = self.settingArray;
    } else if (indexPath.section == 1) {
        targetArray = self.otherArray;
    } else {
        targetArray = self.aboutArray;
    }
    
    cell.textLabel.text = [targetArray[indexPath.row] objectForKey:@"title"];
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 清除缓存
        _cacheSize = [PASLoacalDataManager diskCacheSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB", _cacheSize];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *targetArray = [NSArray array];
    if (indexPath.section == 0) {
        targetArray = self.settingArray;
    } else if (indexPath.section == 1) {
        targetArray = self.otherArray;
    } else {
        targetArray = self.aboutArray;
    }

    NSInteger tag = [[targetArray[indexPath.row] objectForKey:@"action"] integerValue];
    [self didSelectRowWithActionTag:tag];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = RGBColor(247, 249, 250);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGBColor(229, 229, 229);
    [view addSubview:lineView];
    NSString *sectionTitle = nil;
    if (section == 0) {
        sectionTitle = @"Setting";
    } else if (section == 1) {
        sectionTitle = @"Other";
    } else {
        sectionTitle = @"About";
    }

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
    label.text = PASLocalizedString(sectionTitle, nil);
    label.textColor = RGBColor(153, 153, 153);
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Setter && Getter
- (void)loadNav {
    self.view.backgroundColor = RGBCodeColor(0xf2f2f2);
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
}

- (void)configData {
    self.settingArray = @[
                    @{@"title":PASLocalizedString(@"Server address", nil), @"action":@(100)},
                    @{@"title":PASLocalizedString(@"Language", nil), @"action":@(101)},
                    @{@"title":PASLocalizedString(@"Notifications", nil), @"action":@(102)},
                    @{@"title":PASLocalizedString(@"Shortcut", nil), @"action":@(103)},
                    @{@"title":PASLocalizedString(@"Display setting", nil), @"action":@(104)}
                    ];
    self.manualArray = @[
                         @{@"title":PASLocalizedString(@"Manual", nil), @"action":@(105)},
                         @{@"title":PASLocalizedString(@"Faq", nil), @"action":@(106)}
                         ];
    self.otherArray = @[
                         @{@"title":PASLocalizedString(@"Clear cache", nil), @"action":@(107)},
                         @{@"title":PASLocalizedString(@"Share app to your friends", nil), @"action":@(108)}
                         ];
    self.aboutArray = @[
                        @{@"title":PASLocalizedString(@"Designer PlayAppStore", nil), @"action":@(109)},
                        @{@"title":PASLocalizedString(@"Follow us on twitter", nil), @"action":@(110)}
                        ];
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
