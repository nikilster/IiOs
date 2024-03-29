//
//  MainViewController.m
//  Time
//
//  Created by Nikil Viswanathan on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "API.h"
#import "APIConstants.h"
#import "CircularProgressButton.h"
#import "AuthenticationViewController.h"
#import "Util.h"
#import "Assistant.h"
#import "ActivityReminder.h"
#import "TimeAppDelegate.h"

@interface MainViewController() <AuthenticationDelegate, ActivityReminderDelegate>

@property (strong, nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (strong, nonatomic) NSTimer *timerCounter;
@property (nonatomic, strong) NSDate *timerStartTime;

//Current Event
@property (weak, nonatomic) IBOutlet UILabel *currentEventLabel;

//Views
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//AuthToken
@property (strong, nonatomic) NSString *authToken;

//After I
@property (strong, nonatomic) NSArray *activities;
@property (strong, nonatomic) NSDictionary *currentEvent;
@property (strong, nonatomic) NSArray *percentages;

@property (strong, nonatomic) ActivityReminder * activityReminder;
@end

@implementation MainViewController
@synthesize url = _url;
@synthesize timer = _timer;
@synthesize timerCounter = _timerCounter;
@synthesize timerStartTime = _timerStartTime;
@synthesize currentEventLabel = _currentEventLabel;
@synthesize scrollView = _scrollView;
@synthesize activities = _activities;
@synthesize currentEvent = _currentEvent;
@synthesize authToken = _authToken;
@synthesize percentages = _percentages;
@synthesize activityReminder = _activityReminder;

#define BUTTON_HEIGHT 100
#define BUTTON_WIDTH 250
#define BUTTON_SPACER 0
#define BUTTON_OFFSET_X (320-BUTTON_WIDTH)/2
#define BUTTON_OFFSET_Y 140

#define SHOW_LOGIN_SEGUE @"Show Login"


#pragma mark Activity Reminder Delegate

/*
    Called on location change
 */
- (void)movedLocation
{
    //If there is a current event running
    if(self.currentEvent)
    {
        NSString * activityName = @"Exercise";
        NSString * notification = [@"Hey, are you still " stringByAppendingFormat:@"%@?", activityName];
        [Assistant presentImmediateNotification:notification];
    }
}

#pragma mark Auth Delegate

/*
    Successful authentication from the modal view controller
*/
- (void)successfulAuthentication:(NSString *)authToken
{
    //Set the auth token
    self.authToken = authToken;
    
    //Save token
    [Util saveToken:authToken];
    
    //Dismiss the delegate
    [self dismissModalViewControllerAnimated:YES];
    
    //Setup the page
    [self updateInfo];
    
    //TODO: make sure this works
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupDisplay) name:UIApplicationDidBecomeActiveNotification object:nil];
}


#pragma mark - Timer Helper methods


//http://stackoverflow.com/questions/1739383/convert-seconds-integer-to-hhmm-iphone
- (NSString *)timeFormatted:(double)totalSeconds
{
    int totalSecondsWhole = (int)totalSeconds;
    
    int tenthsOfSecond = totalSeconds*10 - totalSecondsWhole*10;
    
    int seconds = totalSecondsWhole % 60; 
    int minutes = (totalSecondsWhole / 60) % 60; 
    int hours = totalSecondsWhole / 3600; 
    
    if(hours > 0)
        return [NSString stringWithFormat:@"%dh %dm %d.%ds",hours, minutes, seconds, tenthsOfSecond]; 
    else if(minutes > 0)
        return [NSString stringWithFormat:@"%dm %d.%ds", minutes, seconds, tenthsOfSecond];
    else
        return [NSString stringWithFormat:@"%d.%ds", seconds, tenthsOfSecond];
}

- (void)updateTimer
{
    //Now
    NSDate *now = [NSDate date];
    
    //Calculate the elapsed time as date
    NSTimeInterval elapsedTime = [now timeIntervalSinceDate:self.timerStartTime];
    /*NSDate *elapsedDate = [NSDate dateWithTimeIntervalSince1970:elapsedTime];
    
    //Setup the dateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    //[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //Update the timer
    NSString *currentTime = [dateFormatter stringFromDate:elapsedDate];*/
    self.timer.text = [self timeFormatted:elapsedTime];
}


- (void)beginTimer:(NSDate *)startTime
{
    [self stopTimer];
    
    self.timerStartTime = startTime;
    
    //10ms
    NSTimeInterval UPDATE_FREQUENCY = 1.0/10.0;
    self.timerCounter = [NSTimer scheduledTimerWithTimeInterval:UPDATE_FREQUENCY target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
}



- (void)stopTimer
{
    
    //Invalidate the timer
    [self.timerCounter invalidate];
    
    //Not sure if this is necessary
    self.timerCounter = nil;
    
    //Display the exact button press time
    self.timer.text = @"0:00";
}



#pragma mark - API Methods


//Temporarily (change)
- (NSDictionary *)percentageForActivityId:(NSString *)activityId
{

    for(NSDictionary *percentage in self.percentages)
        if([activityId isEqualToString:[percentage objectForKey:PERCENTAGE_ACTIVITY_ID]])
            return percentage;
    
    //Should never happen
    return nil;
}

/*
    Start Activity
 
    Ends the current activity and starts the nuew one
    Talks to the server and also updates UI
 */

- (void)startActivity:(int)activityIndex
{
    //Get the Activity Id
    NSDictionary *activity = [self.activities objectAtIndex:activityIndex];
    NSString *activityId = [activity objectForKey:ACTIVITY_ID];
    //For Now
    NSDictionary *activityWithInfo = [self percentageForActivityId:activityId];

    //Talk to the API
    NSDictionary *response = [API startActivity:activityId withAuthToken:self.authToken];
    
    //Response from API
    BOOL result = [(NSNumber *)[response objectForKey:RESULT_START_ACTIVITY] boolValue];
    
    //check
    if(!result) 
    {
        NSLog(@"Error starting activity");
        return;
    }
    
    //Good!
    //Success starting activity!  
    //Set the current event
    self.currentEvent = [response objectForKey:RESULT_CURRENT_RUNNING_EVENT];
    
    //This will proably never happen (only if someons on the same account hit clicks stop between the two function calls in the apidb
    //Set to nice null
    if([self.currentEvent isKindOfClass:[NSNull class]])
        self.currentEvent = nil;
    
    //Setup
    NSString *activityName = [[self.activities objectAtIndex:activityIndex] objectForKey:ACTIVITY_NAME];
    self.currentEventLabel.text = activityName;
    
    //Start Timer
    [self beginTimer:[NSDate date]];
    
    //Start Congratulations
    [Assistant startActivity:activityWithInfo];
}

- (IBAction)finishClicked {
    
    //Only do something if there is a current running event
    if(!self.currentEvent) return;
    
    //Stop Timer
    [self stopTimer];
    
    //Stop Activity
    NSString *eventId = [self.currentEvent objectForKey:EVENT_ID];
    BOOL result = [API finishEvent:eventId withAuthToken:self.authToken];
    
    //No Current Event!
    self.currentEvent = nil;
    
    //Check
    if(!result)
        NSLog(@"Error with stopping event!");
    
    //Set label
    self.currentEventLabel.text = @"I am doing nothing";
    
    //Clear Congratulations
    [Assistant clearCongratulations]; 

   }

/*
    Activity Clicked
 
    Click handler
 */

- (void)activityClicked:(UIButton *)sender
{
    int activityIndex = [sender tag];

    //Start activity
    [self startActivity:activityIndex];
}


/* 
    Start Current Event
 
    Starts the timer for the current event
    Sets the label
 */
- (void)startCurrentEvent:(NSDictionary *)currentEvent
{
    //If the event is null - return
    //if([currentEvent isKindOfClass:[NSNull class]])
        //return;
    if(!currentEvent)
        return;
    
    //Set label
    self.currentEventLabel.text = [currentEvent objectForKey:EVENT_ACTIVITY_NAME];
     
    //Clear Timer
    [self stopTimer];
    
    //Start Timer
    NSString *timeString = [currentEvent objectForKey:EVENT_ACTIVITY_START_TIME];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *startTime = [dateFormatter dateFromString:timeString];
    
    [self beginTimer:startTime];
}

/*
 
    Get Progress Indicator Coordinates
    
    calculates the coordinates for the progress buttons
 
 */
- (CGPoint)getProgressIndicatorCoordinates:(int)index
{
    CGPoint coordinates;
    
    //If odd
    if(index % 2 == 1) 
        coordinates.x = 35;
    else 
        coordinates.x = 185;
    
    int verticalIndex = index/2;
    
    coordinates.y = BUTTON_OFFSET_Y + verticalIndex*150;
    
    return coordinates;
}

/*
 
    Progress for activity
 
    Gets the current progress based on the current percentages
 
 */

- (double)progressForActivity:(NSDictionary *)activity
{
    //Find the activity
    for(NSDictionary *result in self.percentages)
    {
        //TODO: make sure (is currnetly a number)
        if([[result objectForKey:PERCENTAGE_ACTIVITY_ID] isEqualToString:[activity objectForKey:ACTIVITY_ID]])
            return [[result objectForKey:PERCENTAGE_ACTIVITY_PERCENTAGE] intValue];
    }
    
    return 0;
}


/*
    Add Activities
 
    Adds buttons for activities to the display
*/
- (void)addActivities:(NSArray *)activities
{
    //Add a button for each activity
    for(int i=0; i < [activities count]; i++)
    {
        //Get activity
        NSDictionary *activity = [activities objectAtIndex:i];
        
        //Create button
        CircularProgressButton *activityButton = [[CircularProgressButton alloc] init];
        
        //Set frame
        CGPoint position = [self getProgressIndicatorCoordinates:i];
        activityButton.frame = CGRectMake(position.x, position.y, activityButton.frame.size.width, activityButton.frame.size.height);
        
        //Set title
        activityButton.text = [activity objectForKey:ACTIVITY_NAME];

        //TODO: store the activity id
        [activityButton setTag:i];
        
        //TODO: set the progress
        [activityButton setProgress:[self progressForActivity:activity]/100.0];

        
        //Add click handler
        [activityButton addTarget:self action:@selector(activityClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Add
        [self.scrollView addSubview:activityButton];
    }
}



/*
    Setup Scroll View
    
    Set content size of the scroll
*/
- (void)setupScrollView:(int)numActivities
{
    CGFloat contentWidth = self.view.frame.size.width;
    CGFloat contentHeight = BUTTON_OFFSET_Y + numActivities*(BUTTON_HEIGHT + BUTTON_SPACER);
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    //Set the wood image
    //This is so the image scrolls as the controls
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood.jpg"]];

}



/*
    Setup Display

    Sets upt he display to mimic the current version of the site (what is currently going on)
    activities, timer, current events progress behavior indicatorse
*/
- (void)setupDisplay:(NSDictionary *)currentData
{
    NSLog(@"Setting up display!");
    
    //Get the data
    self.activities = [currentData objectForKey:RESULT_DATA_ACTIVITIES];
    //NSArray *completedEvents = [currentStatus objectForKey:RESULT_DATA_COMPLETED_EVENTS];
    self.currentEvent = [currentData objectForKey:RESULT_DATA_CURRENT_EVENT];
    //Translate to iOs Nil
    if([self.currentEvent isKindOfClass:[NSNull class]])
        self.currentEvent = nil;
    
    self.percentages = [currentData objectForKey:RESULT_DATA_PERCENTAGES];
    
    [self setupScrollView:[self.activities count]];
    [self addActivities:self.activities];
    [self startCurrentEvent:self.currentEvent];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SHOW_LOGIN_SEGUE])
    {
        //Set the delegate
        ((AuthenticationViewController *)[segue destinationViewController]).delegate = self;
    }
}

/*
    Updates the device token on server
*/
- (void)updateDeviceToken
{
    TimeAppDelegate *delegate = (TimeAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString * pushToken = [delegate deviceToken];
    
    
    //NSLog(@"trying to update device token.  Push Token: %@ and Auth Token = %@", pushToken, self.authToken);

    //Need the push token and the auth token
    if(pushToken && self.authToken)
    {
        
        NSLog(@"Updating push token!");
        dispatch_queue_t pushQueue = dispatch_queue_create("update token", NULL);
        
        dispatch_async(pushQueue, ^{

            //QUESTION: should use the authToken (without the property?)
            [API setPushToken:pushToken withAuthToken:self.authToken]; 
        });
    }
}

- (void)updateInfo
{
      
    //TODO: We should check if this is a valid auth token and handle
    //If we have the auth token or got it just now from defaults
    //(Also assign)
    if(self.authToken || (self.authToken = [Util authTokenFromDefaults]))
    {
    
        //CS193p See Slides for Lecture 10
        //Create the Queue
        dispatch_queue_t updateQueue = dispatch_queue_create("update data", NULL);
        
        //Dispatch Async
        dispatch_async(updateQueue, ^{
           
            NSLog(@"getting the data!");
            //Get data from web server
            NSDictionary *currentData = [API getInformation:self.authToken];    

            //Get the main queue and update the ui
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Update the UI
                [self setupDisplay:currentData];
            });
        });
        
        //Release the queue
        dispatch_release(updateQueue);
        
        
        [self updateDeviceToken];
    }
    
    //Not logged in 
    //Show Login Screen
    else {
        [self performSegueWithIdentifier:SHOW_LOGIN_SEGUE sender:self];
    }

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    //TODO: update view!
    //http://stackoverflow.com/questions/5277940/why-does-viewwillappear-not-get-called-when-an-app-comes-back-from-the-backgroun

    //TODO: see if we need both this and initreminder
    self.activityReminder = [[ActivityReminder alloc] init];
    
    //Set the Delegate
    self.activityReminder.delegate = self;
    
    //And this
    [self.activityReminder initReminder];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"[before test run] Current Scheduled Notifications: %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);

    //TODO: check for internet and if not show a message
    [self updateInfo];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setTimer:nil];
    [self setScrollView:nil];
    [self setCurrentEventLabel:nil];
    [super viewDidUnload];
}

@end
