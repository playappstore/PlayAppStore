//
//  ViewController.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMUICommonViewController.h"
@interface PASViewController : QMUICommonViewController

@property (nonatomic, weak) UIView *navLine;
@property (nonatomic, strong) NSURLSessionDataTask *task;
- (void)changeLanguage;

@end

