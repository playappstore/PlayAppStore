//
//  PASNetwrokManager.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/20.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckNetwork.h"

@interface PASNetwrokManager : NSObject

// 下载成功的block
@property (nonatomic, copy) void (^success) (id responseData);
// 下载失败的block
@property (nonatomic, copy) void (^failure) (NSError *error);

/**
 *  管理网络请求类的单例
 *
 *  @return 网络请求类的单例
 */
+ (PASNetwrokManager *)defaultManager;


- (void)postWithUrlString:(NSString *)urlString
               parameters:(id)parameters
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *error))failure;


- (void)getWithUrlString:(NSString *)urlString
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure;

- (void)cancelRequest;

@end
