#import <UIKit/UIKit.h>

@interface CircularProgressView : UIView
{
}
- (void)setProgress:(float)progress;
- (float)progress;
- (void)enable;
- (void)disable;

@end
