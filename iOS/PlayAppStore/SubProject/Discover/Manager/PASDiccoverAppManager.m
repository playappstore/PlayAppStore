//
//  PASDiccoverAllAppManager.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/6.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiccoverAppManager.h"
#import "PASConfiguration.h"
#import "PASDataProvider.h"

@interface PASDiccoverAppManager ()

@property (nonatomic, strong) PASDataProvider *dataProvider;

@end

@implementation PASDiccoverAppManager

- (instancetype)init
{
    if (self = [super init])
    {
        PASConfiguration *config = [PASConfiguration shareInstance];
//        NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
        NSString *strURL = @"http://45.77.13.248:3000/apps/ios";

        config.baseURL = [NSURL URLWithString:strURL];
        _dataProvider = [[PASDataProvider alloc] initWithConfiguration:config];
    }
    return self;
}

- (void)refreshAllApps {
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    [_dataProvider getAllAppsWithParameters:nil completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllAppsFailureWithError:)]) {
                [self.delegate requestAllAppsFailureWithError:error];
            }
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *listArr =[NSArray safeArrayFromObject:responseObject];
            for (NSDictionary *dic in listArr) {
                PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:dic];
                model.pas_id = [dic objectForKey:@"id"];
                [modelList safeAddObject:model];
            }
            self.appListArr = modelList;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllAppsSuccessed)]) {
            [self.delegate requestAllAppsSuccessed];
        }
    }];
}


//One App all builds
- (void)refreshWithBundleID:(NSString *)bundleID {
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    [_dataProvider getAllBuildsWithParameters:nil bundleID:bundleID completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllBuildsFailureWithError:)]) {
                [self.delegate requestAllBuildsFailureWithError:error];
            }
            return ;
        }
        
        NSArray *listArr =[NSArray safeArrayFromObject:responseObject];
        for (NSDictionary *dic in listArr) {
            PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:dic];
            model.pas_id = [dic objectForKey:@"id"];
            [modelList safeAddObject:model];
        }
        self.appListArr = modelList;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllBuildsSuccessed)]) {
            [self.delegate requestAllBuildsSuccessed];
        }
    }];
}

- (void)refreshWithBundleID:(NSString *)bundleID buildID:(NSString *)buildID {
    NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:10];
    [_dataProvider getBuildDetailWithBundleID:bundleID buildID:buildID completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestBuildDetailFailureWithError:)]) {
                [self.delegate requestBuildDetailFailureWithError:error];
            }
            return ;
        }
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:responseObject];
            model.pas_id = [responseObject objectForKey:@"id"];
            [modelList safeAddObject:model];
        }
        self.appListArr = modelList;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestBuildDetailSuccessed)]) {
            [self.delegate requestBuildDetailSuccessed];
        }
    }];
}



@end
