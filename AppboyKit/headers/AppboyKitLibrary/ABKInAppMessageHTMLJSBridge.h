#import <Foundation/Foundation.h>
#import "Appboy.h"

static NSString *const ABKBridgeScheme = @"appboybridge";
static NSString *const ABKFirstParam = @"ab_url_param_0";
static NSString *const ABKSecondParam = @"ab_url_param_1";
static NSString *const ABKThirdParam = @"ab_url_param_2";
static NSString *const ABKFourthParam = @"ab_url_param_3";
static NSString *const ABKFifthParam = @"ab_url_param_4";

static NSString *const ABKArgsKey = @"args";
static NSString *const ABKJSBridgeGenderMale = @"m";
static NSString *const ABKJSBridgeGenderFemale = @"f";
static NSString *const ABKJSBridgeGenderOther = @"o";
static NSString *const ABKJSBridgeGenderUnknown = @"u";
static NSString *const ABKJSBridgeGenderNotApplicable = @"n";
static NSString *const ABKJSBridgeGenderPreferNotToSay = @"p";
static NSString *const ABKJSBridgeSubscriptionStateSubscribed = @"subscribed";
static NSString *const ABKJSBridgeSubscriptionStateUnsubscribed = @"unsubscribed";
static NSString *const ABKJSBridgeSubscriptionStateOptedIn = @"opted_in";

static NSString *const ABKInAppMessageHTMLJSInterfaceParseExceptionName = @"AppboyInAppMessageHTMLJSInterfaceParseException";
static NSString *const ABKInAppMessageHTMLJSInterfaceParseExceptionReason = @"Failed to parse appboyBridge call";

@interface ABKInAppMessageHTMLJSBridge : NSObject

+ (BOOL)isBridgeURL:(NSURL *)url;
  
- (void)handleBridgeCallWithURL:(NSURL *)url appboyInstance:(Appboy *)appboy;

@end
