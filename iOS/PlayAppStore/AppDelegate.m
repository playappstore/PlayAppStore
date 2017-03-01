//
//  AppDelegate.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "AppDelegate.h"
#import "PASTabBarController.h"
#import "PAS_3DTouch.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PASTabBarController *tabBarController = [[PASTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self add3DTouch];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   

    return YES;
}
//添加3dTouch功能
- (void)add3DTouch {
    
    if ([self.window.rootViewController respondsToSelector:@selector(traitCollection)]) {
        if ([self.window.rootViewController.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.window.rootViewController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                //添加3DTouch
                [PAS_3DTouch PAS_Add3DTouchItems];
            }else {
                // 不支持3D Touch
            }
        }
    }
}
//处理3dTouch事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    
    [PAS_3DTouch PAS_Handle3DTouchPerformActionForShortcutItem:shortcutItem];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
