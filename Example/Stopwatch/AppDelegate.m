#import "AppDelegate.h"
#import <AppboyKit.h>
#import "NUISettings.h"

static NSString *const AppboyApiKey = @"appboy-sample-ios";
static NSString *const CrittercismAppId = @"51b67d141386207417000002";

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Sets up Crittercism for crash and error tracking.
  NSLog(@"Application delegate method didFinishLaunchingWithOptions is called with launch options: %@", launchOptions);
  
  [Crittercism enableWithAppID:CrittercismAppId];
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"startWithApiKey: %@", AppboyApiKey]];

  // Starts up Appboy, opening a new session and causing an updated in-app message/feed to be requested.
  [Appboy startWithApiKey:AppboyApiKey
            inApplication:application
        withLaunchOptions:launchOptions
        withAppboyOptions:@{ABKRequestProcessingPolicyOptionKey: @(ABKAutomaticRequestProcessing),
                            ABKSocialAccountAcquisitionPolicyOptionKey:@(ABKAutomaticSocialAccountAcquisition)}];

  if ([Appboy sharedInstance].user.email) {
    [Crittercism setUsername:[Appboy sharedInstance].user.email];
  }

  // Enable/disable Appboy to use NUI theming. Try turning it on and off to see the results!  (Look at the Appboy
  // feedback form and news feed).
  [Appboy sharedInstance].useNUITheming = YES;
  
  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
  } else {
    [self setupPushCategories];
  }
  return YES;
}

// When a notification is received, pass it to Appboy
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  NSLog(@"Application delegate method didReceiveRemoteNotification is called with user info: %@", userInfo);
  [Crittercism leaveBreadcrumb:@"registerApplicaion:didReceiveRemoteNotification:"];
  [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo];
}

// Pass the deviceToken to Appboy as well
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken: %@",deviceToken]];
  NSLog(@"In application:didRegisterForRemoteNotificationsWithDeviceToken, token is %@", [NSString stringWithFormat:@"%@", deviceToken]);
  [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
  NSLog(@"Application delegate method handleActionWithIdentifier:forRemoteNotification:completionHandler: is called with identifier: %@, userInfo:%@", identifier, userInfo);
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  [[Appboy sharedInstance] getActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

// When a notification is received, pass it to Appboy. If the notification is received when the app
// is in the background, Appboy will try to fetch the news feed, and call completionHandler after
// the request finished; otherwise, Appboy won't fetch the news feed, nor call the completionHandler.
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  NSLog(@"Application delegate method didReceiveRemoteNotification:fetchCompletionHandler: is called with user info: %@", userInfo);
  }

- (void)setupPushCategories {
  id UIMutableUserNotificationActionClass = NSClassFromString(@"UIMutableUserNotificationAction");
  UIMutableUserNotificationAction *likeAction = [[UIMutableUserNotificationActionClass alloc] init];
  likeAction.identifier = @"LIKE_IDENTIFIER";
  likeAction.title = @"Like";
  // Given seconds, not minutes, to run in the background acceptAction.activationMode = UIUserNotificationActivationModeBackground;
  likeAction.activationMode = UIUserNotificationActivationModeForeground;
  likeAction.destructive = NO;
  // If YES requires passcode, but does not unlock the device acceptAction.authenticationRequired = NO;
  likeAction.authenticationRequired = NO;
  
  UIMutableUserNotificationAction *unlikeAction = [[UIMutableUserNotificationActionClass alloc] init];
  unlikeAction.identifier = @"UNLIKE_IDENTIFIER";
  unlikeAction.title = @"Unlike";
  // Given seconds, not minutes, to run in the background acceptAction.activationMode = UIUserNotificationActivationModeBackground;
  unlikeAction.activationMode = UIUserNotificationActivationModeBackground;
  unlikeAction.destructive = NO;
  // If YES requires passcode, but does not unlock the device acceptAction.authenticationRequired = NO;
  unlikeAction.authenticationRequired = NO;
  
  id UIMutableUserNotificationCategoryClass = NSClassFromString(@"UIMutableUserNotificationCategory");
  UIMutableUserNotificationCategory *likeCategory = [[UIMutableUserNotificationCategoryClass alloc] init];
  likeCategory.identifier = @"LIKE_CATEGORY";
  [likeCategory setActions:@[likeAction, unlikeAction] forContext:UIUserNotificationActionContextDefault];
  
  NSSet *categories = [NSSet setWithObjects:likeCategory, nil];
  id UIUserNotificationSettingsClass = NSClassFromString(@"UIUserNotificationSettings");
  UIUserNotificationSettings *settings = [UIUserNotificationSettingsClass settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:categories];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
  [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

// Here we are trying to handle deep linking with scheme beginning with "stopwatch".
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  NSLog(@"Stopwatch get a deep link request: %@", url.absoluteString);
  UIAlertView *deepLinkAlert = [[UIAlertView alloc] initWithTitle:@"Deep Linking" message:url.absoluteString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [deepLinkAlert show];
  [deepLinkAlert release];
  return YES;
}
@end
