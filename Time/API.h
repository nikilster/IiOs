//
//  API.h
//  Time
//
//  Created by Nikil Viswanathan on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

//Login
+ (NSString *)loginWithEmail:(NSString *)emailAddress
                 andPassword:(NSString *)password;

//Get Information
+ (NSDictionary *)getInformation:(NSString *)authToken;

//Start Activity
+(NSDictionary *)startActivity:(NSString *)activityId
             withAuthToken:(NSString *)authToken;

//Stop Activity
+(BOOL)finishEvent:(NSString *)eventId withAuthToken:(NSString *)authToken;

@end
