#import "ABKLocationManagerProvider.h"

#if !TARGET_OS_TV && !defined(ABK_DISABLE_LOCATION_SERVICES)
#import <CoreLocation/CoreLocation.h>
#endif

@implementation ABKLocationManagerProvider

+ (BOOL)locationServicesEnabled {
#if !TARGET_OS_TV && !defined(ABK_DISABLE_LOCATION_SERVICES)
  return YES;
#endif
  return NO;
}

@end
