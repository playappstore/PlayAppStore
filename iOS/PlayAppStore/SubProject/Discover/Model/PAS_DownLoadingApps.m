//
//  PAS_DownLoadingApps.m
//  PlayAppStore
//
//  Created by kongdeqin on 2017/3/5.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PAS_DownLoadingApps.h"

@implementation PAS_DownLoadingApps

static PAS_DownLoadingApps *_instance;
+ (instancetype )sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initData];
    });
    return _instance;
}
- (void)initData {

    _appDic = [[NSMutableDictionary alloc] init];
}
@end
