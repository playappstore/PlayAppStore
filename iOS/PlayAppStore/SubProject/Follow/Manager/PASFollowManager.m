//
//  PASFollowManager.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/8.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASFollowManager.h"
#import "PASConfiguration.h"
#import "PASDataProvider.h"
#import "PASDiscoverModel.h"
@interface PASFollowManager ()

@property (nonatomic, strong) PASDataProvider *dataProvider;
@property (nonatomic ,strong) NSMutableDictionary *dataDic;
@property (nonatomic ,assign) int failCount;
@end
@implementation PASFollowManager
- (instancetype)init
{
    if (self = [super init])
    {
        PASConfiguration *config = [PASConfiguration shareInstance];
//                NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultMainHost];
        NSString *strURL = @"http://45.77.13.248:3000/apps/ios";
        
        config.baseURL = [NSURL URLWithString:strURL];
        _dataProvider = [[PASDataProvider alloc] initWithConfiguration:config];
    }
    return self;
}
- (void)requestAllFollowAppsWithBundleIDs:(NSArray *)bundleIDs
                                  success:(PAS_FollowSuccessBlock)sucess
                                     fail:(PAS_FollowSuccessFailBlock)fail  {

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < bundleIDs.count; i++) {
        
        NSString *bundleID = bundleIDs[i];
        dispatch_group_async(group, queue, ^{
            
            __weak PASFollowManager *weakSelf = self;
            [_dataProvider getAllBuildsWithParameters:nil bundleID:bundleID completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    weakSelf.failCount ++;
                    
                }else {
                [weakSelf handleRequestWithResponseObject:responseObject];
                
                }
                dispatch_group_leave(group);
            }];
            
        });
        dispatch_group_enter(group);
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        //请求完成
        if (sucess&&_failCount<bundleIDs.count) {
            sucess (self.dataDic);
            return ;
        }
        if (fail&&_failCount==bundleIDs.count) {
            fail(@"0000",@"失败");
        }
    });
}
- (void)handleRequestWithResponseObject:(id)responseObject {
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray *dataArr = (NSArray *)responseObject;
        NSMutableArray *dataArra = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary *dataDic = dataArr[i];
            PASDiscoverModel *model = [PASDiscoverModel yy_modelWithDictionary:dataDic];
            [dataArra addObject:model];
            if (i == dataArr.count -1) {
                [self.dataDic setObject:dataArra forKey:model.name];
            }
        }
    }
}
- (NSMutableDictionary *)dataDic {
    
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}
@end
