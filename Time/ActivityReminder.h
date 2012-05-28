//
//  ActivityReminder.h
//  Time
//
//  Created by Nikil Viswanathan on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Protocol for delegate
@protocol ActivityReminderDelegate <NSObject>
- (void)movedLocation;
@end


@interface ActivityReminder : NSObject

//Init
- (void)initReminder;

//Delegate
@property (nonatomic, weak) id <ActivityReminderDelegate> delegate;

@end
