//
//  PASDiccoverAllAppManager.h
//  PlayAppStore
//
//  Created by Winn on 2017/3/6.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PASDiscoverModel.h"

@protocol PASDiccoverAppManagerDelegate <NSObject>

@optional
- (void)requestAllAppsSuccessed;
- (void)requestAllAppsFailureWithError:(NSError *)error;

- (void)requestAllBuildsSuccessed;
- (void)requestAllBuildsFailureWithError:(NSError *)error;

@end


@interface PASDiccoverAppManager : NSObject

@property (nonatomic, strong) NSArray<PASDiscoverModel *> *appListArr;
@property (nonatomic, weak) id <PASDiccoverAppManagerDelegate> delegate;
// All apps
- (void)refreshAllApps;
//One apps
- (void)refreshWithBundleID:(NSString *)bundleID;

@end
