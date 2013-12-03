#import "AppDelegate.h"
#import "AppboyKit.h"
#import "NUIAppearance.h"

static NSString *const AppboyApiKey = @"appboy-ios-sample";
static NSString *const CrittercismAppId = @"51b67d141386207417000002";

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Sets up Crittercism for crash and error tracking.
  [Crittercism enableWithAppID:CrittercismAppId];
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"startWithApiKey: %@", AppboyApiKey]];

  // Starts up Appboy, opening a new session and causing an updated slideup/feed to be requested.
  [Appboy startWithApiKey:AppboyApiKey
            inApplication:application
        withLaunchOptions:launchOptions
        withAppboyOptions:@{ABKRequestProcessingPolicyOptionKey: [NSNumber numberWithInteger:ABKAutomaticRequestProcessing],
                            ABKSocialAccountAcquisitionPolicyOptionKey:[NSNumber numberWithInteger:ABKAutomaticSocialAccountAcquisition]}];

  if ([Appboy sharedInstance].user.email) {
    [Crittercism setUsername:[Appboy sharedInstance].user.email];
  }

  // This lets us use NUI, the theming/customization package. There is also some initialization code in main.m
  // Look at NUI/NUIStyle.nss to see what's being customized.
  [NUIAppearance init];

  // Enable/disable Appboy to use NUI theming. Try turning it on and off to see the results!  (Look at the Appboy
  // feedback form and news feed).
  [Appboy sharedInstance].useNUITheming = YES;

  // Register for push notifications
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
      (UIRemoteNotificationTypeAlert |
          UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound)];
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

  return YES;
}

// When a notification is received, pass it to Appboy
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  [Crittercism leaveBreadcrumb:@"registerApplicaion:didReceiveRemoteNotification:"];
  [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo];
}

// Pass the deviceToken to Appboy as well
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken: %@",deviceToken]];
  NSLog(@"In application:didRegisterForRemoteNotificationWithDeviceToken, token is %@", [NSString stringWithFormat:@"%@", deviceToken]);
  [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
@end
