//
//  CineAppDelegate.m
//  Example
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineAppDelegate.h"

@implementation CineAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register the preference defaults early.
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"JRSTV_ROOM_ID": @"", @"JRSTV_ROOM_PASS": @""}];

    // Turn on device orientation notification.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    // Switch to main segue if logged in.
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"JRSTV_ROOM_ID"].length != 0) {
        UINavigationController *root = (UINavigationController *)self.window.rootViewController;
        UIViewController *login = root.topViewController;
        [login performSegueWithIdentifier:@"mainNoAnimation" sender:self];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
