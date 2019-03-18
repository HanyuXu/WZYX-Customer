//
//  AppDelegate.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "AppDelegate.h"
#import "WZMainTabBarController.h"
#import "WZUserInfoManager.h"

#define SANDBOX_DOCUMENT_PATH   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define DEFAULT_FILE_MANAGER    [NSFileManager defaultManager]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[WZMainTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    NSLog(@"%@", SANDBOX_DOCUMENT_PATH);
    // 解决tabbat图标偏移问题
    [[UITabBar appearance] setTranslucent:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    //未登录时会崩溃
//    [WZUserInfoManager saveUserInfo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
