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
  [[Appboy sharedInstance] logCustomEvent:@"tvOSCustomEvent"];
}
- (void)logAttributes {
  [[Appboy sharedInstance].user setLastName:@"West"];
}
- (void)submitFeedback {
  [[Appboy sharedInstance] submitFeedback:@"tvosuser@appboy.com" message:@"Change the channel!" isReportingABug:YES];
}
@end
