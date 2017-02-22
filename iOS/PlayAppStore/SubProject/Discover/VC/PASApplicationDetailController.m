//
//  PASApplicationDetailController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASApplicationDetailController.h"

@interface PASApplicationDetailController ()

@end

@implementation PASApplicationDetailController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
}








#pragma mark - Setter && Getter
- (void)addNav {
    self.title = @"Application Detail";
    self.view.backgroundColor = [UIColor whiteColor];    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
