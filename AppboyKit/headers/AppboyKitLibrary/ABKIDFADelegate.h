#import <Foundation/Foundation.h>

/*
 * Appboy Public API: ABKAppboyIDFADelegate
 */
NS_ASSUME_NONNULL_BEGIN
@protocol ABKIDFADelegate <NSObject>
/*!
 * The result of [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString].
 *
 * @return The current IDFA for the user.
 */
- (NSString *)advertisingIdentifierString;

/*!
 * The result from [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled].
 *
 * @return If advertising tracking is enabled.
 */
- (BOOL)isAdvertisingTrackingEnabled;

@end
NS_ASSUME_NONNULL_END
