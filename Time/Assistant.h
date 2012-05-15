//
//  Assistant.h
//  Time
//
//  Created by Nikil Viswanathan on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assistant : NSObject

//Schedule notifications for the started activity
+ (void)startActivity:(NSDictionary *)activity;

//Clear
+ (void)clearCongratulations;

@end
