#import <AppboyKit.h>
#import <BuddyBuildSDK/BuddyBuildSDK.h>

#import "AppDelegate.h"
#import "ABKPushUtils.h"
#import "IDFADelegate.h"
#import "Branch.h"
#import "AlertControllerUtils.h"
#import "ColorUtils.h"
#import <CoreLocation/CoreLocation.h>

#ifdef PUSH_DEV
static NSString *const AppboyApiKey = @"appboy-sample-ios";
#else
static NSString *const AppboyApiKey = @"appboy-sample-ios";
#endif

@implementation AppDelegate

# pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Application delegate method didFinishLaunchingWithOptions is called with launch options: %@", launchOptions);
  
  [BuddyBuildSDK setup];
  
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

  NSString *overrideApiKey = [preferences stringForKey:OverrideApiKeyStorageKey];
  NSString *overrideEndpoint = [preferences stringForKey:OverrideEndpointStorageKey];

  NSString *apiKeyToUse = (overrideApiKey != nil && overrideApiKey.length != 0) ? overrideApiKey : AppboyApiKey;
  
  NSMutableDictionary *appboyOptions = [NSMutableDictionary dictionary];
  appboyOptions[ABKRequestProcessingPolicyOptionKey] = @(ABKAutomaticRequestProcessing);
  appboyOptions[ABKMinimumTriggerTimeIntervalKey] = @(1);
  if (overrideEndpoint != nil) {
    appboyOptions[ABKEndpointKey] = overrideEndpoint;
  } else {
    appboyOptions[ABKEndpointKey] = @"sondheim.appboy.com";
  }
  
  IDFADelegate *idfaDelegate = [[IDFADelegate alloc] init];
  appboyOptions[ABKIDFADelegateKey] = idfaDelegate;
  
  // Set custom session timeout
  id sessionTimeout = [preferences objectForKey:NewSessionTimeoutKey];
  if (sessionTimeout != nil) {
    appboyOptions[ABKSessionTimeoutKey] = sessionTimeout;
  }

  // Set ABKInAppMessageControllerDelegate on startup
  BOOL setInAppDelegate = [preferences boolForKey:SetInAppMessageControllerDelegateKey];
  if (setInAppDelegate) {
    NSLog(@"Setting ABKInAppMessageControllerDelegate for app run.");
    appboyOptions[ABKInAppMessageControllerDelegateKey] = self;
  }

  // Set ABKURLDelegate on startup
  BOOL setUrlDelegate = YES; // default value
  if ([preferences objectForKey:SetURLDelegateKey] != nil) {
    setUrlDelegate = [preferences boolForKey:SetURLDelegateKey];
  } else {
    [preferences setBool:setUrlDelegate forKey:SetURLDelegateKey];
  }
  if (setUrlDelegate) {
    NSLog(@"Setting ABKURLDelegateKey for app run.");
    appboyOptions[ABKURLDelegateKey] = self;
  }
  appboyOptions[ABKPushStoryAppGroupKey] = @"group.com.appboy.stopwatch";

  // Starts up Braze, opening a new session and causing an updated in-app message/feed to be requested.
  [[NSUserDefaults standardUserDefaults] setObject:apiKeyToUse forKey:ApiKeyInUse];
  [[NSUserDefaults standardUserDefaults] setObject:appboyOptions[ABKEndpointKey] forKey:EndpointInUse];
  [Appboy startWithApiKey:apiKeyToUse
          inApplication:application
      withLaunchOptions:launchOptions
      withAppboyOptions:appboyOptions];
  
  // Define and initialize Branch
  Branch *branch = [Branch getInstance];
  [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
    if (!error && params) {
      // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
      NSLog(@"Calling Branch deep link handler on params: %@", params.description);
    }
  }];
  
  // Set ABKInAppMessageUIDelegate
  [[Appboy sharedInstance].inAppMessageController.inAppMessageUIController setInAppMessageUIDelegate:self];

  [self setUpRemoteNotifications];
  self.stopwatchEnableDarkTheme = YES;
  self.showSilentPushAlerts = NO;
  
  NSLog(@"Appboy device identifier is %@", [[Appboy sharedInstance] getDeviceId]);

  return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
  NSLog(@"application:continueUserActivity:restorationHandler called");
  
  if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
    NSString *urlString = [[userActivity.webpageURL absoluteString] stringByRemovingPercentEncoding];
    [self handleUniversalLinkString:urlString withABKURLDelegate:NO];
  }

  return [[Branch getInstance] continueUserActivity:userActivity];
}

// Pass the deviceToken to Braze as well
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"In application:didRegisterForRemoteNotificationsWithDeviceToken, token is %@", [NSString stringWithFormat:@"%@", deviceToken]);
  [[Appboy sharedInstance] registerDeviceToken:deviceToken];
}

// When a notification is received, pass it to Braze. If the notification is received when the app
// is in the background, Braze will try to fetch the news feed, and call completionHandler after
// the request finished; otherwise, Appboy won't fetch the news feed, nor call the completionHandler.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"Application delegate method didReceiveRemoteNotification:fetchCompletionHandler: is called with user info: %@", userInfo);
  if ([ABKPushUtils isAppboyInternalRemoteNotification:userInfo]) {
    NSLog(@"Detected Braze internal push in didReceiveRemoteNotification:fetchCompletionHandler:.");
  }
  [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  
  if ([ABKPushUtils isAppboyRemoteNotification:userInfo] && ![ABKPushUtils isAppboyInternalRemoteNotification:userInfo]) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"Remote notification was sent from Braze, clearing badge number.");

    if (userInfo != nil && userInfo[@"aps"][@"content-available"]) {
      if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive && self.showSilentPushAlerts) {
        [AlertControllerUtils presentAlertWithOKButtonForTitle:@"Silent Push Received"
                                                       message:[self getExtrasFromPush:userInfo]
                                                  presentingVC:[self topViewController:self.window.rootViewController]];
      }
    }
  }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler {
  NSLog(@"application:handleActionWithIdentifier:forRemoteNotification:completionHandler: with identifier %@", identifier);
  [[Appboy sharedInstance] getActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  NSLog(@"applicationDidBecomeActive:(UIApplication *)application");
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
  NSLog(@"Stopwatch openURL delegate called with: %@", url.absoluteString);
  
  // Handle deep linking with scheme beginning with "stopwatch"
  NSString *urlString = url.absoluteString.stringByRemovingPercentEncoding;
  if ([urlString isEqualToString:@"stopwatch:appstore-review"]) {
    NSLog(@"Received app store review request.");
    if (@available(iOS 10.3, *)) {
      [SKStoreReviewController requestReview];
    }
    return YES;
  }
  [AlertControllerUtils presentAlertWithOKButtonForTitle:@"Deep Linking"
                                                 message:urlString
                                            presentingVC:[self topViewController:self.window.rootViewController]];

  // Handle Branch deep links
  [[Branch getInstance] handleDeepLink:url];

  return YES;
}

# pragma mark - Braze Push Registration

- (void)setUpPushWithApplicationDelegates {
  UIMutableUserNotificationAction *likeAction = [[UIMutableUserNotificationAction alloc] init];
  likeAction.identifier = @"LIKE_IDENTIFIER";
  likeAction.title = @"Like";
  // Given seconds, not minutes, to run in the background acceptAction.activationMode = UIUserNotificationActivationModeBackground;
  likeAction.activationMode = UIUserNotificationActivationModeForeground;
  likeAction.destructive = NO;
  // If YES requires passcode, but does not unlock the device acceptAction.authenticationRequired = NO;
  likeAction.authenticationRequired = NO;
  
  UIMutableUserNotificationAction *unlikeAction = [[UIMutableUserNotificationAction alloc] init];
  unlikeAction.identifier = @"UNLIKE_IDENTIFIER";
  unlikeAction.title = @"Unlike";
  // Given seconds, not minutes, to run in the background acceptAction.activationMode = UIUserNotificationActivationModeBackground;
  unlikeAction.activationMode = UIUserNotificationActivationModeBackground;
  unlikeAction.destructive = NO;
  // If YES requires passcode, but does not unlock the device acceptAction.authenticationRequired = NO;
  unlikeAction.authenticationRequired = NO;
  
  UIMutableUserNotificationCategory *likeCategory = [[UIMutableUserNotificationCategory alloc] init];
  likeCategory.identifier = @"LIKE_CATEGORY";
  [likeCategory setActions:@[likeAction, unlikeAction] forContext:UIUserNotificationActionContextDefault];
  
  // Adding Braze default categories
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wdeprecated-declarations"
  NSMutableSet *categories = [NSMutableSet setWithSet:[ABKPushUtils getAppboyUIUserNotificationCategorySet]];
  #pragma clang diagnostic pop
  [categories addObject:likeCategory];
  UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:categories];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
  [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)setUpPushWithUserNotificationCenter {
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
  if (@available(iOS 12.0, *)) {
    options = options | UNAuthorizationOptionProvisional;
  }
  [center requestAuthorizationWithOptions:(options)
                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
                          NSLog(@"Permission granted.");
                          [[Appboy sharedInstance] pushAuthorizationFromUserNotificationCenter:granted];
                        }];
  center.delegate = self;
  
  UNNotificationAction *likeAction = [UNNotificationAction actionWithIdentifier:@"LIKE_IDENTIFIER"
                                                                          title:@"Like"
                                                                        options:UNNotificationActionOptionForeground];
  UNNotificationAction *unlikeAction = [UNNotificationAction actionWithIdentifier:@"UNLIKE_IDENTIFIER"
                                                                            title:@"Unlike"
                                                                          options:0];
  UNNotificationCategory *likeCategory = [UNNotificationCategory categoryWithIdentifier:@"LIKE_CATEGORY"
                                                                                actions:@[likeAction, unlikeAction]
                                                                      intentIdentifiers:@[]
                                                                                options:0];
  // Adding Braze default categories
  NSMutableSet *categories = [NSMutableSet setWithSet:[ABKPushUtils getAppboyUNNotificationCategorySet]];
  [categories addObject:likeCategory];
  [center setNotificationCategories:categories];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)setUpRemoteNotifications {
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
    [self setUpPushWithUserNotificationCenter];
  } else {
    [self setUpPushWithApplicationDelegates];
  }
}

# pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  NSLog(@"Application delegate method userNotificationCenter:willPresentNotification:withCompletionHandler: is called.");
  completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  [[Appboy sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
  NSLog(@"Application delegate method userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: is called with user info: %@", response.notification.request.content.userInfo);
  
  if ([ABKPushUtils isAppboyUserNotification:response]) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"User notification was sent from Braze, clearing badge number.");
  }
}

#pragma mark - ABKInAppMessageControllerDelegate

/*!
* Note that this method will only be called if setting ABKInAppMessageControllerDelegate is enabled from the Stopwatch UI. By default, ABKInAppMessageControllerDelegate is not set.
*/
- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage {
  NSLog(@"beforeInAppMessageDisplayed: delegate called in Stopwatch.");
  inAppMessage.overrideUserInterfaceStyle = [[[NSUserDefaults standardUserDefaults] valueForKey:StopwatchInAppThemeSettingsKey] integerValue];
  if (inAppMessage.extras != nil && inAppMessage.extras[@"Appstore Review"] != nil) {
    [[UIApplication sharedApplication] openURL:inAppMessage.uri options:@{} completionHandler:nil];
    return ABKDiscardInAppMessage;
  }

  // Allows Stopwatch to disable dark theme for in-app messages based off a toggle switch
  inAppMessage.enableDarkTheme = self.stopwatchEnableDarkTheme;

  return ABKDisplayInAppMessageNow;
}

#pragma mark - ABKInAppMessageUIDelegate

/*- (WKWebViewConfiguration *)setCustomWKWebViewConfiguration {
  WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
  webViewConfiguration.allowsInlineMediaPlayback = YES;
  webViewConfiguration.suppressesIncrementalRendering = YES;
  if (@available(iOS 10.0, *)) {
    webViewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
  } else {
    webViewConfiguration.requiresUserActionForMediaPlayback = YES;
  }
  return webViewConfiguration;
}*/

#pragma mark - ABKURLDelegate

/*!
* Note that this method will only be called if setting ABKURLDelegate is enabled from the Stopwatch UI. By default, ABKURLDelegate is set.
*/
- (BOOL)handleAppboyURL:(NSURL *)url fromChannel:(ABKChannel)channel withExtras:(NSDictionary *)extras {
  // Use ABKURLDelegate to handle Universal Links
  if ([[url.host lowercaseString] isEqualToString:@"sweeney.appboy.com"]) {
    [self handleUniversalLinkString:[[url absoluteString] stringByRemovingPercentEncoding] withABKURLDelegate:YES];
    return YES;
  }
  // Let Braze handle links otherwise
  return NO;
}

# pragma mark - Helper methods

- (void)handleUniversalLinkString:(NSString *)uriString withABKURLDelegate:(BOOL)withURIDelegate {
  NSString *alertTitle = withURIDelegate ? @"Universal Link (ABKURLDelegate)" : @"Universal Link (UIApplicationDelegate)";
  [AlertControllerUtils presentAlertWithOKButtonForTitle:alertTitle
                                                 message:uriString
                                            presentingVC:[self topViewController:self.window.rootViewController]];
}

- (NSString *)getExtrasFromPush:(NSDictionary *)userInfo {
  NSMutableDictionary *dict =  [[NSMutableDictionary alloc] init];
  for (NSString* key in userInfo) {
    // Skip 'ab' because it's a Braze defined key and 'aps' because it's an Apple defined key
    if ([key isEqualToString:@"aps"] || [key isEqualToString:@"ab"]) {
      continue;
    }
    dict[key] = userInfo[key];
  }
  return ([dict count] > 0) ? [NSString stringWithFormat:@"%@", dict] : @"No KVP's attached";
}

- (UIViewController *)topViewController:(UIViewController *)topVC {
  while (true) {
    if (topVC.presentedViewController) {
      topVC = topVC.presentedViewController;
    } else if ([topVC isKindOfClass:[UINavigationController class]]) {
      topVC = ((UINavigationController *)topVC).topViewController;
    } else if ([topVC isKindOfClass:[UITabBarController class]]) {
      topVC = ((UITabBarController *)topVC).selectedViewController;
    } else {
      return topVC;
    }
  }
}

@end
