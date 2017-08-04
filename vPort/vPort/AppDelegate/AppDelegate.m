//
//  AppDelegate.m
//  vPort
//
//  Created by MengFanJun on 2017/7/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RegsiterViewController.h"
#import "SignTool.h"
#import "InputPassWordView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [SignTool shareSignTool];//初始化签名工具类
    [self setRootVC];
    [self inputPassWord];
    
    return YES;
}

- (void)setRootVC
{
    BOOL isNotFirstTimeUse = [UserDefaults boolForKey:@"isNotFirstTimeUse"];
    if (!isNotFirstTimeUse) {
        //第一次启动应用，启动引导页
        [UserDefaults setBool:YES forKey:@"isNotFirstTimeUse"];
        [UserDefaults synchronize];
        [self setRootVC];
    }
    else
    {
        //并不是第一次启动，判断是否登录
        BOOL isLogin = [UserDefaults boolForKey:@"isLogin"];
        if (!isLogin) {
            //没有登录，指定登录页面为根视图
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[RegsiterViewController alloc] init]];
            self.window.rootViewController = navi;
        }
        else
        {
            //已经登录，指定首页为根视图
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
            self.window.rootViewController = navi;
            //            self.window.rootViewController = [[ViewController alloc] init];
        }
    }
}

- (void)inputPassWord
{
    //登录密码
    if ([UserDefaults boolForKey:@"isLogin"]) {
        InputPassWordView *inputPassWordView = [[InputPassWordView alloc] init];
        [inputPassWordView show];
    }
    
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
