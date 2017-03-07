//
//  PAS_DownLoadingApps.h
//  PlayAppStore
//
//  Created by kongdeqin on 2017/3/5.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAS_DownLoadingApps : NSObject
+ (instancetype )sharedInstance;
@property (nonatomic ,strong) NSMutableDictionary *appDic;
@property (nonatomic ,strong) NSMutableArray *followApps;
- (void)addFollowAppsWithBuildId:(NSString *)buildId;
- (void)removeFollowAppsWithBuildId:(NSString *)buildId;

@end
