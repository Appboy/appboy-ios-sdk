#import <UIKit/UIKit.h>
#import "ABKPushURIDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "ABKInAppMessageControllerDelegate.h"

static NSString *const OverrideApiKeyStorageKey = @"com.appboy.stopwatch.apikey";
static NSString *const OverrideEndpointStorageKey = @"com.appboy.stopwatch.endpoint";
static NSString *const SetInAppMessageControllerDelegateKey = @"com.appboy.stopwatch.iamdelegate";

@interface AppDelegate : UIResponder <UIApplicationDelegate, ABKPushURIDelegate, UNUserNotificationCenterDelegate, ABKInAppMessageControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

