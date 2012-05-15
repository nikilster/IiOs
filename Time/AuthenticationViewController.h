//
//  AuthenticationViewController.h
//  Time
//
//  Created by Nikil Viswanathan on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for the delegate to follow
@protocol AuthenticationDelegate <NSObject>
- (void)successfulAuthentication:(NSString *)authToken;
@end

@interface AuthenticationViewController : UIViewController
//Delegate - the sender
@property (nonatomic, weak) id <AuthenticationDelegate> delegate;
@end
