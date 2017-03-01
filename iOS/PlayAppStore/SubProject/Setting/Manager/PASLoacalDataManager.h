//
//  PASLoacalDataManager.h
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASLoacalDataManager : NSObject

/**
 *  读取文件夹大小 (DEPRECATED)
 *
 *  @param folderPath 文件夹路径
 *
 *  @return float类型 (以 M 为单位)
 */
+ (float)folderSize:(NSString *)folderPath;


/**
 *  读取缓存文件夹大小
 *
 *  @return float类型 (以 M 为单位)
 */
+ (float)diskCacheSize;

/**
 *  清除缓存
 */
+ (void)clearDiskCache;

+ (void)clearTemCache;

@end
