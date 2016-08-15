#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol AppboyBridgeExport <JSExport>
- (void)changeUser:(NSString *)userId;
- (void)logCustomEventsAndPurchases;
- (void)logAttributes;
- (void)submitFeedback;
@end

@interface AppboyBridge : NSObject <AppboyBridgeExport>
- (instancetype)initWithJSContext:(JSContext *)jsContext;
- (void)changeUser:(NSString *)userId;
- (void)logCustomEventsAndPurchases;
- (void)logAttributes;
- (void)submitFeedback;
@end
