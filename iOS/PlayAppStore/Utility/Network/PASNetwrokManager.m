//
//  PASNetwrokManager.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/20.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASNetwrokManager.h"
#import "AFNetworking.h"

@implementation PASNetwrokManager
{
    AFHTTPSessionManager *manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        //
        manager = [AFHTTPSessionManager manager];
    }
    return self;
}

+ (PASNetwrokManager *)defaultManager
{
    static PASNetwrokManager *manager = nil;
    if (manager == nil) {
        manager = [[PASNetwrokManager alloc] init];
    }
    return manager;
}

- (void)postWithUrlString:(NSString *)urlString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlString
       parameters:parameters
        progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              failure(error);
          }];
}

- (void)getWithUrlString:(NSString *)urlString
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure
{
    NSString *string = [NSString stringWithFormat:@"%@", urlString];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        //
        failure(error);
    }];
}

- (void)cancelRequest {
    [[manager.dataTasks lastObject] cancel];
}

@end
