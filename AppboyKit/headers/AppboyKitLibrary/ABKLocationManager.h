#import <Foundation/Foundation.h>

@class ABKServerConfig;

NS_ASSUME_NONNULL_BEGIN

@interface ABKLocationManager : NSObject

/*!
 * Use ABKDisableAutomaticLocationCollectionKey to disable automatic location tracking. 
 * For more information, please refer to Appboy.h.
 */
@property (readonly) BOOL disableLocationTracking;

/*!
 * Calling this method gives Braze permission to request WhenInUse authorization on your behalf the next time we attempt to collect
 * location in the foreground.
 */
- (void)allowRequestWhenInUseLocationPermission;

/*!
 * Calling this method gives Braze permission to request Always authorization on your behalf the next time we attempt to collect
 * significant location changes.
 */
- (void)allowRequestAlwaysPermission;

/*!
 * Calling this method will log a location using the regular location provider if a location is reported in under
 * 60 seconds. After 60 seconds expires the regular location provider will stop collecting location.
 */
- (void)logSingleLocation;

@end
NS_ASSUME_NONNULL_END
