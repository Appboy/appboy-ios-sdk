#import <AdSupport/AdSupport.h>
#import "ABKIdentifierForAdvertisingProvider.h"

@implementation ABKIdentifierForAdvertisingProvider

/*!
 * @discussion Returns the identifier for advertising if AdSupport framework is available (i.e., iOS >= 6.0) and
 *   the identifier for advertising is enabled.
 */
+ (NSString *) getIdentifierForAdvertiser {
#ifdef ABK_ENABLE_IDFA_COLLECTION
  ASIdentifierManager *sharedManager = [self getASIdentifierManager];
  if (sharedManager) {
    if ([sharedManager isAdvertisingTrackingEnabled]) {
      return [[sharedManager advertisingIdentifier] UUIDString];
    }
  }
#endif
  return nil;
}

/*!
 * @discussion Returns the NSNumber object with IsAdvertisingTrackingEnabled if AdSupport framework is available
 *   (i.e., iOS >= 6.0) and the user has not disallowed advertising tracking. Note that you can still retrieve the IFA
 *   in the case that the user has not enabled advertising tracking, but rather the rules surrounding its use become
 *   more strict.
 */
+ (NSNumber *) getIsAdvertisingTrackingEnabledAsNSNumber {
#ifdef ABK_ENABLE_IDFA_COLLECTION
  ASIdentifierManager *sharedManager = [self getASIdentifierManager];
  if (sharedManager) {
    return [NSNumber numberWithBool:[sharedManager isAdvertisingTrackingEnabled]];
  }
#endif
  return nil;
}

#ifdef ABK_ENABLE_IDFA_COLLECTION
/*!
 * @discussion Returns the [ASIdentifierManager sharedManager] if it is available (i.e., iOS >= 6.0 and app is linked
 *   against AdSupport framework).
 */
+ (ASIdentifierManager *) getASIdentifierManager {
  Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
  if (ASIdentifierManagerClass) {
    // Don't use [ASIdentifierManager sharedManager] here so this method doesn't require that the host app link against
    // the AdSupport framework.
    return [ASIdentifierManagerClass sharedManager];
  }
  return nil;
}
#endif

@end
