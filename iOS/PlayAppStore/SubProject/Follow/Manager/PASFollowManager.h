//
//  PASFollowManager.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/8.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PASDiscoverModel;
@interface PASFollowManager : NSObject

typedef void (^PAS_FollowSuccessBlock) (NSDictionary *dataDic);
typedef void (^PAS_FollowSuccessFailBlock) (NSString *code, NSString *message);;
//所有关注的应用
- (void)requestAllFollowAppsWithBundleIDs:(NSArray *)bundleIDs
                                  success:(PAS_FollowSuccessBlock)sucess
                                     fail:(PAS_FollowSuccessFailBlock)fail;
@end
