//
//  AppDelegate.m
//  Hour of power
//
//  Created by Simone Ferrini on 10/04/14.
//  Copyright (c) 2014 wigwamm. All rights reserved.
//

#import "AppDelegate.h"

// DATABASE
#import "Contact.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //--------- NavigationBar ------------
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.000 green:0.600 blue:0.084 alpha:1.000]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Futura" size:18],
                                                            NSForegroundColorAttributeName: [UIColor whiteColor] }];
    
    
    //---------- TabBar ------------
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:1.000 green:0.600 blue:0.084 alpha:1.000]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setItemSpacing:20];
    
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    
    // Setup CoreData with MagicalRecord
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName: @"ResignActiveNotification" object: nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self notify];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"BackgroundNotification" object: nil];
}

- (void)notify
{
    //------- Notify -------
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:10]; //60*60*24
    notification.alertBody = @"Is time to call!";
    notification.alertAction = @"Call!";
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //-----------------------
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName: @"ForegroundNotification" object: nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName: @"BecomeActiveNotification" object: nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
