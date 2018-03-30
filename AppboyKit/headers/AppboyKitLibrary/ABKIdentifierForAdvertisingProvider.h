#import <Foundation/Foundation.h>

/*! 
 * Do not call these methods within your code. They are meant for Braze internal use only.
 */

/*!
 * ABKIdentifierForAdvertisingProvider.m and ABKIdentifierForAdvertisingProvider.h must be added to your project
 * regardless of whether or not you enable collection. This occurs automatically if you integrate/update via the CocoaPod.
 */

/*
 * Braze Public API: ABKIdentifierForAdvertisingProvider
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKIdentifierForAdvertisingProvider : NSObject

+ (nullable NSString *)getIdentifierForAdvertiser;
+ (nullable NSNumber *)getIsAdvertisingTrackingEnabledAsNSNumber;

@end
NS_ASSUME_NONNULL_END
