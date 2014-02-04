#import <Foundation/Foundation.h>

@interface ABKIdentifierForAdvertisingProvider : NSObject
+ (NSString *) getIdentifierForAdvertiser;
+ (NSNumber *) getIsAdvertisingTrackingEnabledAsNSNumber;
@end
