#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <StoreKit/StoreKit.h>
#import "ABKInAppMessageControllerDelegate.h"
#import "ABKURLDelegate.h"
#import "ABKInAppMessageUIDelegate.h"

static NSString *const OverrideApiKeyStorageKey = @"com.appboy.stopwatch.apikey";
static NSString *const OverrideEndpointStorageKey = @"com.appboy.stopwatch.endpoint";
static NSString *const SDKAuthKey = @"com.appboy.stopwatch.sdkauth";
static NSString *const SetInAppMessageControllerDelegateKey = @"com.appboy.stopwatch.iamdelegate";
static NSString *const SetURLDelegateKey = @"com.appboy.stopwatch.urldelegate";
static NSString *const NewSessionTimeoutKey = @"com.appboy.stopwatch.sessiontimeout";

static NSString *const ApiKeyInUse = @"com.appboy.stopwatch.apikeyinuse";
static NSString *const EndpointInUse = @"com.appboy.stopwatch.endpointinuse";

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate,
ABKInAppMessageControllerDelegate, ABKURLDelegate, ABKInAppMessageUIDelegate>

@property (strong, nonatomic) UIWindow *window;

/*!
 * Global setting for Stopwatch toggle to display UI content with a Dark Theme, if possible. This boolean defaults to YES.
 *
 * If NO, display the UI with the default light color, even if the campaign includes dark theme fields.
 * If YES, attempt to display the dark theme colors if available; otherwise if not available, display the light colors.
 */
@property (nonatomic, assign) BOOL stopwatchEnableDarkTheme;
@property (nonatomic, assign) BOOL showSilentPushAlerts;

@end

