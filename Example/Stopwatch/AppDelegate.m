#import "AppDelegate.h"
#import <AppboyKit.h>
#import "NUISettings.h"
#import "ABKPushUtils.h"
#import <Crittercism/Crittercism.h>

static NSString *const AppboyApiKey = @"appboy-sample-ios";
static NSString *const CrittercismAppId = @"51b67d141386207417000002";
static NSString *const CrittercismObserverName = @"CRCrashNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Application delegate method didFinishLaunchingWithOptions is called with launch options: %@", launchOptions);

  // Starts up Appboy, opening a new session and causing an updated in-app message/feed to be requested.
  [Appboy startWithApiKey:AppboyApiKey
          inApplication:application
      withLaunchOptions:launchOptions
      withAppboyOptions:@{ABKRequestProcessingPolicyOptionKey: @(ABKAutomaticRequestProcessing),
                          ABKMinimumTriggerTimeIntervalKey: @(5)}];
  
  // Sets up Crittercism for crash and error tracking.
  // Need to initialize Appboy before initializing Crittercism so custom events will be logged in crashDidOccur.
  // Need to subscribe to crash notifications before initializing Crittercism.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(crashDidOccur:)
                                               name:CrittercismObserverName object:nil];
  
  [Crittercism enableWithAppID:CrittercismAppId];
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"startWithApiKey: %@", AppboyApiKey]];

  if ([Appboy sharedInstance].user.email) {
    [Crittercism setUsername:[Appboy sharedInstance].user.email];
  }
  [Appboy sharedInstance].appboyPushURIDelegate = self;

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

/* Send crash event to Appboy upon notification */
- (void) crashDidOccur:(NSNotification*)notification {
  NSDictionary *crashInfo = notification.userInfo;
  
  [[Appboy sharedInstance] logCustomEvent:@"ApteligentCrashEvent"
                           withProperties:crashInfo];
  [[Appboy sharedInstance].user setCustomAttributeWithKey:@"lastCrashName" andStringValue:crashInfo[@"crashName"]];
  [[Appboy sharedInstance].user setCustomAttributeWithKey:@"lastCrashReason" andStringValue:crashInfo[@"crashReason"]];
  [[Appboy sharedInstance].user setCustomAttributeWithKey:@"lastCrashDate" andDateValue:crashInfo[@"crashDate"]];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
  NSLog(@"application:continueUserActivity:restorationHandler called");
  return false;
}

// When a notification is received, pass it to Appboy
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  NSLog(@"Application delegate method didReceiveRemoteNotification is called with user info: %@", userInfo);
  [Crittercism leaveBreadcrumb:@"registerApplicaion:didReceiveRemoteNotification:"];
  [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo];
}

// Pass the deviceToken to Appboy as well
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken: %@",deviceToken]];
  NSLog(@"In application:didRegisterForRemoteNotificationsWithDeviceToken, token is %@", [NSString stringWithFormat:@"%@", deviceToken]);
  [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  NSLog(@"applicationDidBecomeActive:(UIApplication *)application");
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
  NSLog(@"Application delegate method handleActionWithIdentifier:forRemoteNotification:completionHandler: is called with identifier: %@, userInfo:%@", identifier, userInfo);
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  [[Appboy sharedInstance] getActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

// When a notification is received, pass it to Appboy. If the notification is received when the app
// is in the background, Appboy will try to fetch the news feed, and call completionHandler after
// the request finished; otherwise, Appboy won't fetch the news feed, nor call the completionHandler.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  if ([ABKPushUtils isUninstallTrackingNotification:userInfo]) {
    NSLog(@"Got uninstall tracking push from Appboy");
  }
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  NSLog(@"Stopwatch get a deep link request: %@", url.absoluteString);
  NSString *urlString = url.absoluteString.stringByRemovingPercentEncoding;
  UIAlertView *deepLinkAlert = [[UIAlertView alloc] initWithTitle:@"Deep Linking" message:urlString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [deepLinkAlert show];
  deepLinkAlert = nil;
  return YES;
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
  NSLog(@"%@",userInfo);
  [[Appboy sharedInstance] handleWatchKitExtensionRequest:userInfo reply:reply];
}

- (BOOL)handleAppboyPushURI:(NSString *)URIString withNotificationInfo:(NSDictionary *)notificationInfo {
  NSRange range = [URIString rangeOfString:@"secret"];
  if (range.location != NSNotFound) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ssh"
                                                    message:@"The deep link of the push is a secret."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    alert = nil;
    return YES;
  } else {
    return NO;
  }
}

@end
