//
//  PASDiscoverModel.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASDiscoverModel : NSObject

@property (nonatomic ,copy) NSString *build;
//应用ID
@property (nonatomic ,copy) NSString *bundleID;
@property (nonatomic ,copy) NSString *changelog;
@property (nonatomic ,copy) NSString *lastCommitMsg;
@property (nonatomic ,copy) NSString *guid;
//应用LOGO
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *objectId;
//应用名称
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *platform;
@property (nonatomic ,copy) NSString *updatedAt;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic ,copy) NSString *version;
@property (nonatomic ,copy) NSString *size;
-(void)setModelWithDic:(NSDictionary*)dataDic;
@end
