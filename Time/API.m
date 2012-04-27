//
//  API.m
//  Time
//
//  Created by Nikil Viswanathan on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "API.h"
#import "APIConstants.h"

@implementation API

//Possible strategy
//http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
+ (NSURL *)urlFromDictionaryArguments:(NSDictionary *)arguments
{
    //TODO: Escape
    NSString *loginURL = API_URL;
    
    //Create the (with argument) url string
    for (NSString *key in arguments)
    {
        NSString *value = [arguments objectForKey:key];
        loginURL = [loginURL stringByAppendingFormat:@"%@=%@&", key, value];
    }
    
    //Strip the last &
    loginURL = [loginURL substringToIndex:[loginURL length] - 1];
    
    //Create the url from the string
    NSURL *requestURL = [NSURL URLWithString:loginURL];
    NSLog(@"%@", requestURL);
    return requestURL;
}

+ (NSDictionary *) makeAPICall:(NSDictionary *)arguments
{
 
    //TODO: do this async
    NSData *data = [NSData dataWithContentsOfURL:[API urlFromDictionaryArguments:arguments]];

    //Print the response
    //NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", dataStr);
    
    //Parse JSON
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //If Error Print Error
    if(error) NSLog(@"Error: %@", error);
    NSLog(@"%@", json);
    
    //Check result
    NSString *APICallResult = [json objectForKey:RESULT_KEY_API_RESULT];

    if([APICallResult intValue] != 1) NSLog(@"Error making api call");
    
    //Get data
    NSDictionary *info = [json objectForKey:RESULT_KEY_DATA];
    
    return info;

}
                          
                          
/*
    Login
 */
+ (NSString *)loginWithEmail:(NSString *)emailAddress
              andPassword:(NSString *)password
{
    
    //Create request
    //value, key, value, key 
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:API_FUNCTION_LOGIN, API_ARG_FUNCTION,
                                                                        emailAddress, API_ARG_EMAIL,
                                                                        password, API_ARG_PASSWORD, nil];
    //Make request
    NSDictionary *result = [API makeAPICall:request];
    
    //Check if it was a good login
    NSString *loginResult = [result objectForKey:RESULT_LOGIN_RESULT];
    if([loginResult intValue] == 1)
    {    
        //Get the auth token
        NSString * authToken = [result objectForKey:RESULT_LOGIN_AUTH_TOKEN];
        return authToken;
    }
    else {
        NSLog(@"Error authenticating");
        return @"";
    }
    
}


/* 
    Get Information
*/
+ (NSDictionary *)getInformation:(NSString *)authToken
{
    //Create the url request
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:API_FUNCTION_GET_INFORMATION, API_ARG_FUNCTION,
                                                                        authToken, API_ARG_AUTH_TOKEN, nil];
    
    //request
    NSDictionary *informationResult = [API makeAPICall:request];
    
    return informationResult;
}


/*
    Start Activity
 */
+(BOOL)startActivity:(NSString *)activityId
             withAuthToken:(NSString *)authToken
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             API_FUNCTION_START_ACTIVITY, API_ARG_FUNCTION,
                             authToken, API_ARG_AUTH_TOKEN,
                             activityId, API_ARG_ACTIVITY_ID, nil];
    
    //Make Request
    //TODO: what happens on the error boolean 
    NSNumber *result = (NSNumber *)[API makeAPICall:request];
    
    //NSCFBoolean
    
    return [result boolValue];
}
@end
