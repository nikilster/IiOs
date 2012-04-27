//
//  APIConstants.h
//  Time
//
//  Created by Nikil Viswanathan on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//API Constants

//URL
#define API_URL @"http://67.23.22.130/api/api.php?"

//Arguments namesfor the get / Post request
#define API_ARG_FUNCTION    @"f"
#define API_ARG_EMAIL       @"email"
#define API_ARG_PASSWORD    @"password"
#define API_ARG_AUTH_TOKEN  @"authToken"
#define API_ARG_ACTIVITY_ID @"aid"
#define API_ARG_EVENT_ID    @"eid"

//Api function names
#define API_FUNCTION_LOGIN              @"login"
#define API_FUNCTION_GET_INFORMATION    @"getInformation"
#define API_FUNCTION_START_ACTIVITY     @"startActivity"
#define API_FUNCTION_STOP_EVENT         @"stopEvent"


//Result keys
#define RESULT_KEY_API_RESULT           @"apiResult"
#define RESULT_KEY_DATA                 @"data"

//Individual results
//Login
#define RESULT_LOGIN_RESULT             @"result"
#define RESULT_LOGIN_AUTH_TOKEN         @"authToken"

//Get information
#define RESULT_DATA_ACTIVITIES          @"activities"
#define RESULT_DATA_COMPLETED_EVENTS    @"completedEvents"
#define RESULT_DATA_CURRENT_EVENT       @"currentEvent"

//For activities
#define ACTIVITY_NAME                   @"name"
#define ACTIVITY_GOAL                   @"goal"
#define ACTIVITY_ID                     @"id"

//For Events
//TODO: Should I move this to objects?
#define EVENT_ID                        @"id"
#define EVENT_ACTIVITY_ID               @"activityId"
#define EVENT_ACTIVITY_NAME             @"activityName"
#define EVENT_ACTIVITY_START_TIME       @"startTime"

@interface APIConstants : NSObject


@end
