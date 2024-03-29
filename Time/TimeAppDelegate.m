//
//  TimeAppDelegate.m
//  Time
//
//  Created by Nikil Viswanathan on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeAppDelegate.h"
//QUESTION: what is the best way to do p device passing
#import "MainViewController.h"

@implementation TimeAppDelegate

@synthesize window = _window;
@synthesize deviceToken = _deviceToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    // Override point for customization after application launch.
    return YES;
}
	

/*
    ======= =-Start Push Notifications ========
 */

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //combined as string!
    NSLog(@"Device token: %@", deviceToken);
    NSString* combinedPushToken = [deviceToken description];
    //NSLog(@"Push Token = %@", pushToken);
	combinedPushToken = [combinedPushToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	combinedPushToken = [combinedPushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"Push token cleaned = %@", pushToken);
    
    self.deviceToken = combinedPushToken;

    //QUESTION!!! is this the right way to do this?
    if([self.window.rootViewController isKindOfClass:[MainViewController class]])
    {
        [(MainViewController *)self.window.rootViewController updateDeviceToken];
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error with push notification registration: %@", error);
}


/*
    ========-  End Push Notification -========
 */



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
