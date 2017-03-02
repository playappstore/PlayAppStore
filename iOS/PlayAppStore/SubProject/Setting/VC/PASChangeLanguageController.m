//
//  PASChangeLanguageController.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASChangeLanguageController.h"

@interface PASChangeLanguageController ()

@end

@implementation PASChangeLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self addSubviews];

}

#pragma mark - Setter && Getter
- (void)loadNav {
    self.title = NSLocalizedString(@"Language setting", nil);
}

- (void)addSubviews {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
