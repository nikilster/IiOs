#import "CircularProgressView.h"
#define forcolor(x) x/255.0f

@interface CircularProgressView()  {
@private
    float _progress;
    UILabel* progressLabel;
    UILabel* textLabel;
    BOOL isClicked;

}
@end

@implementation CircularProgressView

#pragma mark -
#pragma mark Accessors

- (float)progress {
    return _progress;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Lifecycle

- (id)init {

    //[self addSubview:progressLabel];
    //int xoffset = self.progress == 1 ? 20 : 15;
    //progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0-xoffset, self.bounds.size.width/2.0-15, 50, 30)];
    //textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 17)];
    //textLabel.textAlignment = UITextAlignmentCenter;
    //textLabel.text = self.text;
    //[self addSubview:textLabel];
    //[self addSubview:progressLabel];


    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 100, 100)];
}

- (void)viewDidLoad
{
}

/*
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    [self setNeedsDisplay];
    return TRUE;
}
*/

- (void)enable {
    isClicked = TRUE;
    [self setNeedsDisplay];
}

- (void)disable {
    isClicked = FALSE;
    [self setNeedsDisplay];
}
/*

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self setNeedsDisplay];
}
 */


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        isClicked = FALSE;
    }
    return self;
}


#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    //[[UIImage imageNamed:@"backbround.png"] drawInRect:CGRectMake(0, 0, 100, 100)];

    CGContextSaveGState(context);
        
    [[UIColor blackColor] setFill];
            
    CGPoint center = CGPointMake(self.bounds.size.width / 2, 100 / 2);
    CGFloat radius = (self.bounds.size.width - 4) / 2;
    CGFloat startAngle =  ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    CGContextSetRGBFillColor(context, forcolor(0), forcolor(0), forcolor(0), 1.0f); // white
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, -startAngle, -endAngle, 1);
    CGContextClosePath(context);    
    CGContextFillPath(context);
        
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, CGRectMake(0, 0, 100, 100));

    //CGContextRestoreGState(context);
    
        
    CGContextSaveGState(context);
    CGContextClipToMask(context, CGRectMake(0, 0, 100, 100), alphaMask);
    
    [[UIImage imageNamed:@"circle.png"] drawInRect:CGRectMake(0, 0, 100, 100)];
    
    CGContextRestoreGState(context);
    CGImageRelease(alphaMask);
    
    CGImageRef progressImage = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, CGRectMake(0, 0, 100, 100));
    
    if(isClicked) {
        [[UIImage imageNamed:@"background_sel.png"] drawInRect:CGRectMake(0, 0, 100, 100)];
    }else {
        [[UIImage imageNamed:@"background.png"] drawInRect:CGRectMake(0, 0, 100, 100)];
    }
    
    //CGContextDrawImage(context, self.bounds, progressImage);
    [[UIImage imageWithCGImage:progressImage] drawInRect: CGRectMake(0, 0, 100, 100)];
    CGImageRelease(progressImage);

    /*
    int xoffset = self.progress == 1 ? 20 : 15;
    progressLabel.frame =CGRectMake(self.bounds.size.width/2.0-xoffset, self.bounds.size.width/2.0-15, 50, 30);
        

    progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(100*self.progress)];
    //progressLabel.text = [NSString stringWithFormat:@"%d", self.highlighted];
    progressLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    textLabel.text = self.text;
    
    //[textLabel setNeedsDisplay];
    //[progressLabel setNeedsDisplay];
    [self addSubview:progressLabel];
    [self addSubview:textLabel];
     */
 }

@end
