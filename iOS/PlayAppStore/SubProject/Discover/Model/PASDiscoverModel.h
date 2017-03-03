//
//  PASDiscoverModel.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASDiscoverModel : NSObject
//应用ID
@property (nonatomic ,copy) NSString *build;
@property (nonatomic ,copy) NSString *bundleID;
@property (nonatomic ,copy) NSString *changelog;
@property (nonatomic ,copy) NSString *guid;
//应用LOGO
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *pas_id;
//应用名称
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *platform;
@property (nonatomic ,copy) NSString *uploadTime;
@property (nonatomic ,copy) NSString *version;

@end
