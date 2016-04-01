//
//  AppDelegate.m
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "AppDelegate.h"
#import "WKWebViewController.h"
#import "UIWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[[WKWebViewController new], [UIWebViewController new]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
