//
//  CircularProgressButton.h
//  Time
//
//  Created by Patrick Blaes on 4/26/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularProgressButton : UIButton
{
    NSString* text;
}

- (void)setProgress:(float)progress;
- (float)progress;


@property (readwrite,retain) NSString* text;
@end
