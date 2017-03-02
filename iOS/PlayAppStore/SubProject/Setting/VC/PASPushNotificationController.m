//
//  PASPushNotificationController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASPushNotificationController.h"

@interface PASPushNotificationController ()

@end

@implementation PASPushNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];
    
}

#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = NSLocalizedString(@"Push Notification", nil);
}

- (void)addSubviews {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
