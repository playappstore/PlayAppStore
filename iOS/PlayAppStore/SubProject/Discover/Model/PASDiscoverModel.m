//
//  PASDiscoverModel.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASDiscoverModel.h"

@implementation PASDiscoverModel

-(void)setModelWithDic:(NSDictionary*)dataDic{
    
    self.PAS_bulid = [NSString safeStringFromObject:[dataDic objectForKey:@"build"]];
    self.PAS_AppName = [NSString safeStringFromObject:[dataDic objectForKey:@"name"]];
    self.PAS_AppID = [NSString safeStringFromObject:[dataDic objectForKey:@"id"]];
    self.PAS_AppLogo  = [NSString safeStringFromObject:[dataDic objectForKey:@"icon"]];
    self.PAS_uploadTime = [NSString safeStringFromObject:[dataDic objectForKey:@"uploadTime"]];
    self.url = [NSString safeStringFromObject:[dataDic objectForKey:@"url"]];
    self.chengelog = [NSString safeStringFromObject:[dataDic objectForKey:@"chengelog"]];
    self.version = [NSString safeStringFromObject:[dataDic objectForKey:@"version"]];
    self.guid = [NSString safeStringFromObject:[dataDic objectForKey:@"guid"]];
    self.bundleID = [NSString safeStringFromObject:[dataDic objectForKey:@"bundleID"]];
}

@end
