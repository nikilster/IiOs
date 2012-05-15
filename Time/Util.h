//
//  Util.h
//  Time
//
//  Created by Nikil Viswanathan on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//For NSUserDefaults
#define AUTH_TOKEN_KEY @"authToken"

@interface Util : NSObject

+ (NSString *)authTokenFromDefaults;
+ (void)saveToken:(NSString *)authToken;

@end
