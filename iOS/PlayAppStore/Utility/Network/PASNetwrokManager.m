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

+ (void)postWithUrlString:(NSString *)urlString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:urlString
       parameters:parameters
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              failure(error);
          }];
}

+ (void)getWithUrlString:(NSString *)urlString
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure
{
    [[self class] getWithUrlString:urlString success:success failure:failure cache:NO];
    
}


+ (void)getWithUrlString:(NSString *)urlString
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure
                   cache:(BOOL)yesOrNo
{
    
    NSString *string = [NSString stringWithFormat:@"%@", urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:string parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        //
        failure(error);
    }];
}

+ (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInteger:indexKey++]];
    
    return (NSDictionary *)mutableDictionary;
}


@end
