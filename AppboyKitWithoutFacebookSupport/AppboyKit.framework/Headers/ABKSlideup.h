#import <Foundation/Foundation.h>
@interface ABKSlideup : NSObject

// The message displayed in the slideup.
@property (nonatomic, copy) NSString *message;

// If YES, the slideup will not render the chevron on the right side of the slideup. The chevron is meant to be a visual
// indicator that the slideup can be touched, so this is a useful property to set to YES if you are overriding the
// touch action on the slideup.
@property (nonatomic, assign) BOOL hideChevron;

@end
