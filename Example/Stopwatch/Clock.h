#import <Foundation/Foundation.h>

static NSString *const TimeUpdatedNotification = @"timeUpdated";

@interface Clock : NSObject

- (void) stop;
- (void) start;
- (void) reset;
- (NSString *) timeString;

@property (assign, nonatomic) BOOL clockRunning;
@end

