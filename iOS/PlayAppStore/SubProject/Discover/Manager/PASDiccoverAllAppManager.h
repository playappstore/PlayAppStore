//
//  PASDiccoverAllAppManager.h
//  PlayAppStore
//
//  Created by Winn on 2017/3/6.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PASDiscoverModel.h"

@protocol PASDiccoverAllAppManagerDelegate <NSObject>

- (void)requestAllAppsSuccessed;
- (void)requestAllAppsFailureWithError:(NSError *)error;

@end


@interface PASDiccoverAllAppManager : NSObject

@property (nonatomic, strong) NSArray<PASDiscoverModel *> *appListArr;
@property (nonatomic, weak) id <PASDiccoverAllAppManagerDelegate> delegate;

- (void)refresh;

@end
