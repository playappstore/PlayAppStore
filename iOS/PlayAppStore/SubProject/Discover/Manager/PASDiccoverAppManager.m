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
#import "PASNetwrokManager.h"
@interface PASDiccoverAppManager ()

@property (nonatomic, strong) PASDataProvider *dataProvider;

@end

@implementation PASDiccoverAppManager

- (instancetype)init
{
    if (self = [super init])
    {
      
    }
    return self;
}
- (void)pasconfiguration {

    PASConfiguration *config = [PASConfiguration shareInstance];
    NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
    config.baseURL = [NSURL URLWithString:strURL];
    _dataProvider = [[PASDataProvider alloc] initWithConfiguration:config];
}

- (void)refreshAllApps {
    NSString *str = [NSString stringWithFormat:@"%@records/ios",[[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost]];
    NSMutableArray *modelList = [[NSMutableArray alloc] init];
    [[PASNetwrokManager defaultManager] getWithUrlString:str success:^(id response) {
       
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *listArr =[NSArray safeArrayFromObject:response];
            for (NSDictionary *dic in listArr) {
                PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:dic];
                [modelList safeAddObject:model];
            }
            self.appListArr = modelList;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllAppsSuccessed)]) {
            [self.delegate requestAllAppsSuccessed];
        }

        
    } failure:^(NSError *error) {
        
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllAppsFailureWithError:)]) {
                [self.delegate requestAllAppsFailureWithError:error];
            }
        }
    }];
   
}


//One App all builds
- (void)refreshWithBundleID:(NSString *)bundleID {
    [self pasconfiguration];
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
            [modelList safeAddObject:model];
        }
        self.appListArr = modelList;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestAllBuildsSuccessed)]) {
            [self.delegate requestAllBuildsSuccessed];
        }
    }];
}

- (void)refreshWithBundleID:(NSString *)bundleID buildID:(NSString *)buildID {
    [self pasconfiguration];
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
            [modelList safeAddObject:model];
        }
        self.appListArr = modelList;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestBuildDetailSuccessed)]) {
            [self.delegate requestBuildDetailSuccessed];
        }
    }];
}



@end
