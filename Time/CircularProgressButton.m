//
//  CircularProgressButton.m
//  Time
//
//  Created by Patrick Blaes on 4/26/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "CircularProgressButton.h"
#import "CircularProgressView.h"

@interface CircularProgressButton() {
@private
    float _progress;
    UILabel* progressLabel;
    UILabel* textLabel;
    CircularProgressView* progressView;
    BOOL isClicked;
    
}
@end


@implementation CircularProgressButton
@synthesize text;

- (float)progress {
    return _progress;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    progressView.progress = progress;
    int xoffset = self.progress == 1 ? 20 : 15;
    progressLabel.frame =CGRectMake(self.bounds.size.width/2.0-xoffset, self.bounds.size.width/2.0-15, 50, 30);
    
    
    progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(100*self.progress)];
    //progressLabel.text = [NSString stringWithFormat:@"%d", self.highlighted];
    progressLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

    [self setNeedsDisplay];
}

- (void)setText:(NSString*)newText {
    textLabel.text = newText;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    isClicked = FALSE;
    [progressView disable];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    isClicked = TRUE;
    [progressView enable];
}

/*
- (NSString*)text {
    return self.text;
}
*/

- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 100, 120)];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        progressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        progressView.userInteractionEnabled = NO;
        [self addSubview:progressView];

        int xoffset = self.progress == 1 ? 20 : 15;
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(100/2.0-xoffset, 100/2.0-15, 50, 30)];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 103, 100, 17)];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        textLabel.text = self.text;
        [self addSubview:textLabel];
        [self addSubview:progressLabel];
        isClicked = FALSE;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
 */


@end
