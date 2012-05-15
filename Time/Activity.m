//
//  Activity.m
//  Time
//
//  Created by Nikil Viswanathan on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Activity.h"
#import "APIConstants.h"

@implementation Activity

+ (NSString *) name:(NSDictionary *)activity
{
    return [activity objectForKey:ACTIVITY_NAME];
}

+ (BOOL)lessThanHalf:(NSDictionary *)activity
{
    //Percentage Progess so far
    //TODO: make the activity actually have the percentage
    double percentage = [[activity objectForKey:PERCENTAGE_ACTIVITY_PERCENTAGE] doubleValue];
    
    return percentage < 50;
}


+ (double) hoursTillHalf:(NSDictionary *)activity
{
    //TODO: make activity have this!
    double percentage = [[activity objectForKey:PERCENTAGE_ACTIVITY_PERCENTAGE] doubleValue];
    
    //Total Goal
    double goal = [[activity objectForKey:ACTIVITY_GOAL] doubleValue];
    
    return (50 - percentage)/100.0 * goal;
}

+ (double)hoursTillGoal:(NSDictionary *)activity
{
    //Progess so far
    //TODO Add the percentage to the activity.
    double percentage = [[activity objectForKey:PERCENTAGE_ACTIVITY_PERCENTAGE] doubleValue];
    
    //Total Goal
    double goal = [[activity objectForKey:ACTIVITY_GOAL] doubleValue];
    
    return  (100 - percentage)/100.0 * goal;
}



@end
