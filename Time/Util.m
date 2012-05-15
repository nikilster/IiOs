//
//  Util.m
//  Time
//
//  Created by Nikil Viswanathan on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

@implementation Util

//Get the Token
+ (NSString *)authTokenFromDefaults
{
    //Get the current defaults
    NSUserDefaults *currentSaved = [NSUserDefaults standardUserDefaults];
    
    //Return the data (or nil if it not saved)
    return [currentSaved objectForKey:AUTH_TOKEN_KEY];
    
}

//Save authToken to defaults
+ (void)saveToken:(NSString *)authToken
{

    //Get Defaults
    NSUserDefaults *currentSaved = [NSUserDefaults standardUserDefaults];
    
    //Save over any preexisting data
    [currentSaved setObject:authToken forKey:AUTH_TOKEN_KEY];
    
    //Synchronize
    [currentSaved synchronize];
}
@end
