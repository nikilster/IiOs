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
+ (NSDictionary *)loginWithEmail:(NSString *)emailAddress
              andPassword:(NSString *)password
{
    
    //Create request
    //value, key, value, key 
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:API_FUNCTION_LOGIN, API_ARG_FUNCTION,
                                                                        emailAddress, API_ARG_EMAIL,
                                                                        password, API_ARG_PASSWORD, nil];
    //Make request
    NSDictionary *result = [API makeAPICall:request];
    
    //return result
    return result;
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
+(NSDictionary *)startActivity:(NSString *)activityId
             withAuthToken:(NSString *)authToken
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             API_FUNCTION_START_ACTIVITY, API_ARG_FUNCTION,
                             authToken, API_ARG_AUTH_TOKEN,
                             activityId, API_ARG_ACTIVITY_ID, nil];
    
    //Make Request
    //TODO: what happens on the error boolean 
    NSDictionary *result = [API makeAPICall:request];
    
    //
    
    return result;
}

/*
    Finish Current Activity
 
    
*/
+(BOOL)finishEvent:(NSString *)eventId 
     withAuthToken:(NSString *)authToken;
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             API_FUNCTION_STOP_EVENT, API_ARG_FUNCTION,
                             eventId, API_ARG_EVENT_ID,
                             authToken, API_ARG_AUTH_TOKEN,nil];
    
    //Make request
    NSNumber *result = (NSNumber *)[API makeAPICall:request];
    
    //NSCFBoolean
    return [result boolValue];
}



/* 
    Login Result 
 */

+ (BOOL)successfulLogin:(NSDictionary *)loginResult
{
    //Check if it was a good login
    NSString *result = [loginResult objectForKey:RESULT_LOGIN_RESULT];
    return [result intValue] == 1;
}

+ (NSString *)authTokenForSuccessfulLogin:(NSDictionary *)loginResult
{
    //Get the auth token
    NSString *authToken = [loginResult objectForKey:RESULT_LOGIN_AUTH_TOKEN];
    
    //Make sure this is a valid result
    if(!authToken) return @"Not a valid login result for this function";

    //Message
    return authToken;
}

+ (NSString *)errorMessageForAuthentication:(NSDictionary *)loginResult
{
    //Get the message
    NSString *errorMessage = [loginResult objectForKey:RESULT_LOGIN_ERROR_MESSAGE];
    
    //Make sure this is a invalid login
    if(!errorMessage) return @"Not a invalid login result as needed for this";
    
    return errorMessage;
}
@end
