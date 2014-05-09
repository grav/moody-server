//
//  MOOAppDelegate.m
//  moody
//
//  Created by Mikkel Gravgaard on 09/05/14.
//  Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOAppDelegate.h"
#import "MOOMoodInputViewController.h"

#if TARGET_IPHONE_SIMULATOR
	#import "DCIntrospect.h"
#endif

static NSString *const kNameOfStylesheetFile = @"Stylesheets/stylesheet.cas";

@implementation MOOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [self.window setRootViewController:[MOOMoodInputViewController new]];

    [self setupClassy];
    [self startDCIntrospect];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

- (void)startDCIntrospect {
#if TARGET_IPHONE_SIMULATOR
	[[DCIntrospect sharedIntrospector] start];
#endif
}

- (void)setupClassy {
    NSError *error = nil;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:[kNameOfStylesheetFile lastPathComponent] ofType:nil];
    [[CASStyler defaultStyler] setFilePath:filePath error:&error];
    if (error) {
        NSLog(@"Classy error : %@ -- file %@", [error localizedDescription],filePath);
    }
#if TARGET_IPHONE_SIMULATOR
    NSString *absoluteFilePath = CASAbsoluteFilePath(kNameOfStylesheetFile);
    [CASStyler defaultStyler].watchFilePath = absoluteFilePath;
#endif
}

@end