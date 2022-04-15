#import "AppboyBridge.h"
#import <AppboyTVOSKit/AppboyKit.h>

@implementation AppboyBridge

- (instancetype)initWithJSContext:(JSContext *)jsContext
{
  return [super init];
}
- (void)changeUser:(NSString *)userId {
  [[Appboy sharedInstance] changeUser:[userId stringByAppendingString:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]]];
}
- (void)logCustomEventsAndPurchases {
  [[Appboy sharedInstance] logCustomEvent:@"tvOS_TVML_Event_noProps"];
  [[Appboy sharedInstance] logCustomEvent:@"tvOS_TVML_Event" withProperties:@{@"tvOS_TVML_EventPKey" : @123}];

  [[Appboy sharedInstance] logPurchase:@"tvOS_TVML_Purchase_noProps" inCurrency:@"USD" atPrice:[[NSDecimalNumber alloc] initWithString:@"0.11"] withQuantity:1];
  [[Appboy sharedInstance] logPurchase:@"tvOS_TVML_Purchase" inCurrency:@"USD" atPrice:[[NSDecimalNumber alloc] initWithString:@"0.88"] withQuantity:2 andProperties:@{@"tvOS_TVML_PurchasePKey" : @456}];
}
- (void)logAttributes {
  [[Appboy sharedInstance].user setLastName:@"West"];
}
@end
