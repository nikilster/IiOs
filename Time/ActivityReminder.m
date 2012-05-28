//
//  ActivityReminder.m
//  Time
//
//  Created by Nikil Viswanathan on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ActivityReminder.h"

//Private properties
@interface ActivityReminder()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * currentLocation;
@end

@implementation ActivityReminder

@synthesize locationManager = _locationManager;
@synthesize currentLocation =_currentLocation;
@synthesize delegate = _delegate;

//Sets (reminders by location)
- (void)initReminder
{
    //TODO: permissions check
    
    //Load / Init the CLLocationManager 
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    
        //Set the delegate to self
        self.locationManager.delegate = self;
    }
    
    //Start Monitoring significant location changes
    [self.locationManager startMonitoringSignificantLocationChanges];
}

/*
    Delegate Methods
 */

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   if(self.currentLocation)
   {
       //Notify the delegate
       [self.delegate movedLocation];
   }
    
    self.currentLocation = newLocation;
}
@end


