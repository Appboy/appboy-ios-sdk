#import "IDFADelegate.h"
#import <AdSupport/ASIdentifierManager.h> 

@implementation IDFADelegate

- (NSString *)advertisingIdentifierString {
  return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (BOOL)isAdvertisingTrackingEnabled {
  return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
}

@end
