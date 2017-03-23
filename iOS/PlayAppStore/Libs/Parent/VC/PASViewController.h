//
//  ViewController.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASViewController : UIViewController

@property (nonatomic, weak) UIView *navLine;
@property (nonatomic, strong) NSURLSessionDataTask *task;
- (void)changeLanguage;

@end

