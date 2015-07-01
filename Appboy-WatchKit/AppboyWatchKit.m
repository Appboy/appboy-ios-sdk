#import "AppboyWatchKit.h"
#import "AppboywatchKitKeys.h"
#import <WatchKit/WatchKit.h>

static CGFloat const AppleWatch38mmWidth = 136.0;
static CGFloat const AppleWatch42mmWidth = 156.0;

@implementation AppboyWatchKit

+ (void) logCustomEvent:(NSString *)eventName {
  [self logCustomEvent:eventName withProperties:nil];
}

+ (void) logCustomEvent:(NSString *)eventName withProperties:(NSDictionary *)properties {
  if (properties != nil && properties.count > 0) {
    [self sendToiOSApp:@{ABWKCustomEventKey : @{ABWKCustomEventNameKey : eventName,
                                                ABWKCustomEventPropertiesKey : properties}}];
  } else {
    [self sendToiOSApp:@{ABWKCustomEventKey : @{ABWKCustomEventNameKey : eventName}}];
  }
}

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price {
  [self logPurchase:productIdentifier inCurrency:currencyCode atPrice:price withQuantity:1 andProperties:nil];
}

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withProperties:properties {
  [self logPurchase:productIdentifier inCurrency:currencyCode atPrice:price withQuantity:1 andProperties:properties];
}

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity {
  [self logPurchase:productIdentifier inCurrency:currencyCode atPrice:price withQuantity:quantity andProperties:nil];
}

+ (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity andProperties:(NSDictionary *)properties {
  if (properties != nil && properties.count > 0) {
    [self sendToiOSApp:@{ABWKPurchaseKey : @{ABWKPurchaseProductIdKey : productIdentifier,
                                             ABWKPurchaseCurrencyKey : currencyCode,
                                             // NSDecimalNumber is translated into NSNumber in the iOS SDK, so we parse the NSDeicmalNumber's value to a string to avoid errors.
                                             ABWKPurchasePriceKey : [NSString stringWithFormat:@"%f", [price doubleValue]],
                                             ABWKPurchaseQuantityKey : @(quantity),
                                             ABWKPurchasePropertiesKey : properties}}];
  } else {
    [self sendToiOSApp:@{ABWKPurchaseKey : @{ABWKPurchaseProductIdKey : productIdentifier,
                                             ABWKPurchaseCurrencyKey : currencyCode,
                                             // NSDecimalNumber is translated into NSNumber in the iOS SDK, so we parse the NSDeicmalNumber's value to a string to avoid errors.
                                             ABWKPurchasePriceKey : [NSString stringWithFormat:@"%f", [price doubleValue]],
                                             ABWKPurchaseQuantityKey : @(quantity)}}];
  }
}

+ (void) submitFeedback:(NSString *)replyToEmail message:(NSString *)message isReportingABug:(BOOL)isReportingABug {
  [self sendToiOSApp:@{ABWKSubmitFeedbackKey : @{ABWKSubmitFeedbackEmailKey : replyToEmail,
                                                 ABWKSubmitFeedbackMessageKey : message,
                                                 ABWKSubmitFeedbackIsBugKey : @(isReportingABug)}}];
}

+ (void) logActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification {
  if (identifier != nil && identifier.length > 0) {
    [self sendToiOSApp:@{ABWKWatchPushOpenKey : remoteNotification,
                         ABWKWatchPushOpenActionIdentifierKey : identifier}];
  } else {
    [self sendToiOSApp:@{ABWKWatchPushOpenKey : remoteNotification}];
  }
}

+ (void) sendToiOSApp:(NSDictionary *)dictionary {
  [WKInterfaceController openParentApplication:@{AppboyWatchKitDataKey : dictionary,
                                                 AppboyWatchKitDeviceModelKey : [self getWatchModel]}
                                         reply:nil];
}

+ (NSString *) getWatchModel {
  CGFloat watchWidth = [WKInterfaceDevice currentDevice].screenBounds.size.width;
  NSString *deviceModel = ABKWKDeviceModel;
  if (watchWidth == AppleWatch38mmWidth) {
    deviceModel = ABKWKDeviceModel38mm;
  } else if (watchWidth == AppleWatch42mmWidth) {
    deviceModel = ABKWKDeviceModel42mm;
  }
  return deviceModel;
}

@end
