#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import <Foundation/Foundation.h>
/*
 * This ABWKUser class is parallel with the Appboy in the Appboy iOS SDK.
 *
 * NOTE: Please make sure the passed parameter(s) is not nil, or the watch SDK will throw an exception when trying to
 * parse the data to a dictionary.
 */

@interface AppboyWatchKit : NSObject

+ (void) logCustomEvent:(NSString *)eventName;

+ (void) logCustomEvent:(NSString *)eventName withProperties:(NSDictionary *)properties;

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price;

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withProperties:properties;

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity;

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity andProperties:(NSDictionary *)properties;

+ (void) submitFeedback:(NSString *)replyToEmail message:(NSString *)message isReportingABug:(BOOL)isReportingABug;

+ (void) logActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification;

+ (void) sendToiOSApp:(NSDictionary *)dictionary;

@end
