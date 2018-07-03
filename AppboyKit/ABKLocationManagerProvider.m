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

+ (BOOL)requestLocationManagerAlwaysAuthorizationIfAppropriate:(CLLocationManager *)locationManager {
#if !TARGET_OS_TV && !defined(ABK_DISABLE_LOCATION_SERVICES)
  if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [locationManager requestAlwaysAuthorization];
    return YES;
  }
#endif
  return NO;
}

+ (BOOL)requestLocationManagerWhenInUseAuthorizationIfAppropriate:(CLLocationManager *)locationManager {
#if !TARGET_OS_TV && !defined(ABK_DISABLE_LOCATION_SERVICES)
  if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [locationManager requestWhenInUseAuthorization];
    return YES;
  }
#endif
  return NO;
}

@end
