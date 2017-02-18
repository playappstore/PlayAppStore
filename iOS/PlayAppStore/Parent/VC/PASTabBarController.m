//
//  PASTabBarController.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/18.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASTabBarController.h"

@interface PASTabBarController ()

@end

@implementation PASTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeTabBarViewControllers];
}

- (void)customizeTabBarViewControllers
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TabControllers" ofType:@"plist"];
    // DLog(@"path : %@", path);
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        NSString *title = [dict objectForKey:@"title"];
        NSString *imageName = [dict objectForKey:@"iconName"];
        NSString *selectedImageName = [dict objectForKey:@"selectedIconName"];
        // create viewControllers
        Class class = NSClassFromString([dict objectForKey:@"className"]);
        UIViewController *controller;
        controller = [[class alloc] init];
        controller.title = title;
        
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
        [viewControllers addObject:naviController];
        
        // create UITabBarItem
        UITabBarItem *tabBarItem = nil;
        tabBarItem = [[UITabBarItem alloc] init];
        tabBarItem.title = controller.title;
        [tabBarItem setFinishedSelectedImage:[UIImage imageNamed:imageName] withFinishedUnselectedImage:[UIImage imageNamed:selectedImageName]];
            controller.tabBarItem = tabBarItem;
            
        controller.tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    self.viewControllers = viewControllers;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
