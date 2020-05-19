#import <Foundation/Foundation.h>
#import "ABKIDFADelegate.h"

@interface IDFADelegate : NSObject <ABKIDFADelegate>

- (NSString *)advertisingIdentifierString;
- (BOOL)isAdvertisingTrackingEnabled;

@end
