//
//  KHCAppDelegate.m
//  slider
//
//  Created by Chuck Lin on 5/30/14.
//
//

#import "KHCAppDelegate.h"

@implementation KHCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES"
                                                            forKey:@"rightHandMode"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDisableIdelTimer:) name:@"DisableIdle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnableIdelTimer:) name:@"EnableIdle" object:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeaveApp" object:nil];
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

- (void)applicationDisableIdelTimer: (NSNotification*) notification
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)applicationEnableIdelTimer: (NSNotification*) notification
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

@end
