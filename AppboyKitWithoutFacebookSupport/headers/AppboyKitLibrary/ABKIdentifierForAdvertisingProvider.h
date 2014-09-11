#import <Foundation/Foundation.h>

/*! 
 * Do not call these methods within your code. They are meant for Appboy internal use only. 
 */

/*!
 * ABKIdentifierForAdvertisingProvider.m and ABKIdentifierForAdvertisingProvider.h must be added to your project
 * regardless of whether or not you enable collection. This occurs automatically if you integrate/update via the CocoaPod.
 */

@interface ABKIdentifierForAdvertisingProvider : NSObject
+ (NSString *) getIdentifierForAdvertiser;
+ (NSNumber *) getIsAdvertisingTrackingEnabledAsNSNumber;
@end
