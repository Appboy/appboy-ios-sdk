#import <AdSupport/AdSupport.h>
#import "ABKIdentifierForAdvertisingProvider.h"

/*!
 * Do not call these methods within your code. They are meant for Braze internal use only.
 */

/*!
 * ABKIdentifierForAdvertisingProvider.m and ABKIdentifierForAdvertisingProvider.h must be added to your project
 * regardless of whether or not you enable collection. This occurs automatically if you integrate/update via the CocoaPod.
 */

@implementation ABKIdentifierForAdvertisingProvider

/*!
 * @discussion Returns the identifier for advertising if AdSupport framework is available and the identifier for
 *   advertising is enabled.
 *
 *  If you’re using advertising elsewhere in the app or through our in-app News Feed, we recommend continuing to collect
 * the IDFA through Braze. You should be able to do so safely without fear of rejection from the iOS App Store.
 * The future availability of IDFAs will enable functionality like integrating with other third-party systems,
 * including your own servers, and enabling re-targeting of existing users outside of Braze.
 * If you continue to record them we will store IDFAs free of charge so you can take advantage of these options
 * immediately when they are released without additional development work.
 *
 * To enable IDFA collection add a PreProcessor Macro to your build settings called ABK_ENABLE_IDFA_COLLECTION=1
 */
+ (NSString *)getIdentifierForAdvertiser {
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
 *   and the user has not disallowed advertising tracking. Note that you can still retrieve the IFA in the case that
 *   the user has not enabled advertising tracking, but rather the rules surrounding its use become more strict.
 */
+ (NSNumber *)getIsAdvertisingTrackingEnabledAsNSNumber {
#ifdef ABK_ENABLE_IDFA_COLLECTION
  ASIdentifierManager *sharedManager = [self getASIdentifierManager];
  if (sharedManager) {
    return @([sharedManager isAdvertisingTrackingEnabled]);
  }
#endif
  return nil;
}

#ifdef ABK_ENABLE_IDFA_COLLECTION
/*!
 * @discussion Returns the [ASIdentifierManager sharedManager] if it is available (i.e. if the app is linked
 *   against AdSupport framework).
 */
+ (ASIdentifierManager *)getASIdentifierManager {
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
