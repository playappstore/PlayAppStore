//
//  PASLoacalDataManager.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASLoacalDataManager.h"

@implementation PASLoacalDataManager

// 计算缓存大小 size
+ (float)diskCacheSize
{
    long long folderSize = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"paths=======%@", paths);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"path ----------%@", path);
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath: path];
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath  = [path stringByAppendingPathComponent: fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: filePath error: nil];
        unsigned long long length = [attrs fileSize];
        // 此处清理urlcache中文件
        if([[[fileName componentsSeparatedByString: @"/"] objectAtIndex: 0] isEqualToString: @"URLCACHE"])
            continue;
        
        folderSize += length;
    }
    
    return folderSize/(1024.0*1024.0);
    
}

// 清除缓存数据
+ (void)clearDiskCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                   });
}


+ (void)clearTemCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString * cachPath = NSTemporaryDirectory();
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                   });
}


+ (float)folderSize:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    long long folderSize = 0;
    NSArray *subpathsArray = [manager subpathsAtPath:folderPath];
    for (NSString *subpath in subpathsArray) {
        NSString *filepath = [folderPath stringByAppendingPathComponent:subpath];
        folderSize += [PASLoacalDataManager fileSizeAtPath:filepath];
    }
    
    return folderSize/(1024.0*1024.0);
}

+ (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

@end
