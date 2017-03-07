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
        NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
        config.baseURL = [NSURL URLWithString:strURL];
        _dataProvider = [[PASDataProvider alloc] initWithConfiguration:config];
    }
    return self;
}

- (void)refreshAllApps {
    NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:10];
    [_dataProvider getAllAppsWithParameters:nil completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllAppsFailureWithError:)]) {
                [self.delegate requestAllAppsFailureWithError:error];
            }
            return ;
        }
        NSArray *listArr =[NSArray safeArrayFromObject:responseObject];
        for (NSDictionary *dic in listArr) {
            PASDiscoverModel *cardApplyModel = [[PASDiscoverModel alloc] init];
            [cardApplyModel setModelWithDic:dic];
            [modelList safeAddObject:cardApplyModel];
        }
        self.appListArr = modelList;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllAppsSuccessed)]) {
            [self.delegate requestAllAppsSuccessed];
        }
    }];
}


//One App all builds
- (void)refreshWithBundleID:(NSString *)bundleID {
    NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:10];
    [_dataProvider getAllBuildsWithParameters:nil bundleID:bundleID completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllBuildsFailureWithError:)]) {
                [self.delegate requestAllBuildsFailureWithError:error];
            }
            return ;
        }
        
        NSArray *listArr =[NSArray safeArrayFromObject:responseObject];
        for (NSDictionary *dic in listArr) {
            PASDiscoverModel *cardApplyModel = [[PASDiscoverModel alloc] init];
            [cardApplyModel setModelWithDic:dic];
            [modelList safeAddObject:cardApplyModel];
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
        
        NSArray *listArr =[NSArray safeArrayFromObject:responseObject];
        for (NSDictionary *dic in listArr) {
            PASDiscoverModel *cardApplyModel = [[PASDiscoverModel alloc] init];
            [cardApplyModel setModelWithDic:dic];
            [modelList safeAddObject:cardApplyModel];
        }
        self.appListArr = modelList;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestBuildDetailSuccessed)]) {
            [self.delegate requestBuildDetailSuccessed];
        }
    }];
    

}



@end
