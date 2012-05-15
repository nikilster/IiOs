//
//  Activity.h
//  Time
//
//  Created by Nikil Viswanathan on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

//Name
+ (NSString *)name:(NSDictionary *)activity;

//Remaining
+ (double)hoursTillGoal:(NSDictionary *)activity;

//< halfway?
+ (BOOL)lessThanHalf:(NSDictionary *)activity;

//Hours to 1/2
+ (double)hoursTillHalf:(NSDictionary *)activity;
@end
