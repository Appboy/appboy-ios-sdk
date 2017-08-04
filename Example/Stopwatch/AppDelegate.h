#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "ABKInAppMessageControllerDelegate.h"
#import "ABKURLDelegate.h"

static NSString *const OverrideApiKeyStorageKey = @"com.appboy.stopwatch.apikey";
static NSString *const OverrideEndpointStorageKey = @"com.appboy.stopwatch.endpoint";
static NSString *const SetInAppMessageControllerDelegateKey = @"com.appboy.stopwatch.iamdelegate";
static NSString *const SetURLDelegateKey = @"com.appboy.stopwatch.urldelegate";
static NSString *const NewSessionTimeoutKey = @"com.appboy.stopwatch.sessiontimeout";

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate,
ABKInAppMessageControllerDelegate, ABKURLDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

