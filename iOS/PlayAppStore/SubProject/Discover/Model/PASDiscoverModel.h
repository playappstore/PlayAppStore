//
//  PASDiscoverModel.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASDiscoverModel : NSObject
//应用名称
@property (nonatomic ,copy) NSString *PAS_AppName;
//应用LOGO--icon
@property (nonatomic ,copy) NSString *PAS_AppLogo;
//应用ID
@property (nonatomic ,copy) NSString *PAS_AppID;
//bulid
@property(nonatomic, copy) NSString *PAS_bulid;
//uploadTime
@property(nonatomic, copy) NSString *PAS_uploadTime;
//
@property(nonatomic, copy) NSString *PAS_platform;
//
@property(nonatomic, copy) NSString *url;
//
@property(nonatomic, copy) NSString *chengelog;
//
@property(nonatomic, copy) NSString *version;
//
@property(nonatomic, copy) NSString *guid;
//
@property(nonatomic, copy) NSString *bundleID;
//set model
-(void)setModelWithDic:(NSDictionary*)dataDic;

@end
