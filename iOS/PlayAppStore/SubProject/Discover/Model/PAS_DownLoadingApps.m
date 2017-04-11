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
    _followApps = [[NSMutableArray alloc] init];
}
- (void)addFollowAppsWithBuildId:(NSString *)buildId; {

   NSMutableArray *dataArr= [[NSMutableArray alloc] initWithArray:[PAS_DownLoadingApps sharedInstance].followApps ];
    [dataArr addObject:buildId];
    [[NSUserDefaults standardUserDefaults] setObject:dataArr forKey:@"Pas_followApps"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)followApps {

    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Pas_followApps"];

}
- (void)removeFollowAppsWithBuildId:(NSString *)buildId {


    NSMutableArray *dataArr= [[NSMutableArray alloc] initWithArray:[PAS_DownLoadingApps sharedInstance].followApps ];
    if ([dataArr containsObject:buildId]) {
        [dataArr removeObject:buildId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dataArr forKey:@"Pas_followApps"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
