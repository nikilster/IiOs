//
//  Assistant.m
//  Time
//
//  Created by Nikil Viswanathan on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Assistant.h"
#import "Activity.h"

@implementation Assistant

#define SECONDS_IN_AN_HOUR 3600

//Schedule notifications for the started activity
+ (void)startActivity:(NSDictionary *)activity
{
    /*
    NSLog(@"Name: %@", [Activity name:activity]);
    NSLog(@"less than half? %d", [Activity lessThanHalf:activity]);
    NSLog(@"Time till half: %f", [Activity hoursTillHalf:activity]*60);
    NSLog(@"Time till goal: %f", [Activity hoursTillGoal:activity]*60);
    */
    
    //Cancel existing notifications
    [Assistant clearCongratulations];
    
    //Schedule a notification for 50%
    if([Activity lessThanHalf:activity])
    {
        NSString *halfwayMessage = [NSString stringWithFormat:@"Yay! You're halfway there to achieving your goal of %@!", [Activity name:activity]];
        [Assistant scheduleCongratulations:[Activity hoursTillHalf:activity] message:halfwayMessage];
    }
    
    //Scheule a notification for the finish
    NSString *successMessage = [NSString stringWithFormat:@"Yay! You did it!  You finished %@!", [Activity name:activity]];
    [Assistant scheduleCongratulations:[Activity hoursTillGoal:activity] message:successMessage];
}

//Schedule a notification for a specific time in the future
+ (void)scheduleCongratulations:(double)hoursTillNotification message:(NSString*)message
{
    
    //Calculate the date
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:hoursTillNotification * SECONDS_IN_AN_HOUR];
    
    //Schedule the notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //Make sure it worked
    if(notification == nil) return;
    
    //Set parameters
    notification.fireDate = date;
    notification.alertBody = message;
    notification.alertAction = @"Go to activity";
    
    //Default Parameters
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //notification.applicationIconBadgeNumber = 1;
    
    //Any additional parameters
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

}

//Delete all of the notofication (get from the defaults)
+ (void)clearCongratulations
{
    //Get notifications
    NSArray *existingNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    //Cancel
    for(UILocalNotification *notification in existingNotifications)
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
}
@end
