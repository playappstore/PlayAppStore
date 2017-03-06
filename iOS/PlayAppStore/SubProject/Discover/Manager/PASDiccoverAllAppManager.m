//
//  PASDiccoverAllAppManager.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/6.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiccoverAllAppManager.h"
#import "PASConfiguration.h"
#import "PASDataProvider.h"

@interface PASDiccoverAllAppManager ()

@property (nonatomic, strong) PASDataProvider *dataProvider;

@end

@implementation PASDiccoverAllAppManager


- (void)refresh {
    PASConfiguration *config = [PASConfiguration shareInstance];
    NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
    config.baseURL = [NSURL URLWithString:strURL];
    _dataProvider = [[PASDataProvider alloc] initWithConfiguration:config];
    
    NSMutableArray *modelList = [NSMutableArray arrayWithCapacity:10];
    [_dataProvider getAllAppsWithParameters:nil completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
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

@end
