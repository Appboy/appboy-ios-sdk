#import "AppDelegate.h"
#import <AppboyKit.h>
#import "NUISettings.h"
#import "ABKPushUtils.h"
#import <Crittercism/Crittercism.h>
#import "OverrideEndpointDelegate.h"
#import "IDFADelegate.h"
#import "ABKThemableFeedNavigationBar.h"

#ifdef PUSH_DEV
static NSString *const AppboyApiKey = @"appboy-sample-ios";
#else
static NSString *const AppboyApiKey = @"appboy-sample-ios";
#endif
static NSString *const CrittercismAppId = @"51b67d141386207417000002";
static NSString *const CrittercismObserverName = @"CRCrashNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Application delegate method didFinishLaunchingWithOptions is called with launch options: %@", launchOptions);

  NSString *overrideApiKey = [[NSUserDefaults standardUserDefaults] stringForKey:OverrideApiKeyStorageKey];
  NSString *overrideEndpoint = [[NSUserDefaults standardUserDefaults] stringForKey:OverrideEndpointStorageKey];
  
  OverrideEndpointDelegate* endpointDelegate = nil;
  
  if (overrideEndpoint != nil && overrideEndpoint.length != 0) {
    endpointDelegate = [[OverrideEndpointDelegate alloc] initWithEndpoint:overrideEndpoint];
  }

  NSString *apiKeyToUse = (overrideApiKey != nil && overrideApiKey.length != 0) ? overrideApiKey : AppboyApiKey;
  
  NSMutableDictionary *appboyOptions = [NSMutableDictionary dictionary];
  appboyOptions[ABKRequestProcessingPolicyOptionKey] = @(ABKAutomaticRequestProcessing);
  appboyOptions[ABKMinimumTriggerTimeIntervalKey] = @(5);
  if (endpointDelegate != nil) {
    appboyOptions[ABKAppboyEndpointDelegateKey] = endpointDelegate;
  }
  
  IDFADelegate *idfaDelegate = [[IDFADelegate alloc] init];
  appboyOptions[ABKIDFADelegateKey] = idfaDelegate;

  // Set ABKInAppMessageControllerDelegate on startup
  BOOL setInAppDelegate = [[NSUserDefaults standardUserDefaults] boolForKey:SetInAppMessageControllerDelegateKey];
  if (setInAppDelegate) {
    appboyOptions[ABKInAppMessageControllerDelegateKey] = self;
  }

  // Starts up Appboy, opening a new session and causing an updated in-app message/feed to be requested.
  [Appboy startWithApiKey:apiKeyToUse
          inApplication:application
      withLaunchOptions:launchOptions
      withAppboyOptions:appboyOptions];
  
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
  
  // Set feed navigation bar to opaque green
  [[ABKThemableFeedNavigationBar appearance] setTranslucent:NO];
  [[ABKThemableFeedNavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.25 green:0.81 blue:0.50 alpha:1.0]];
  
  [self setUpRemoteNotification];
  return YES;
}

- (void) setupRemoteNotificationForiOS7 {
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
   (UIRemoteNotificationTypeAlert |
    UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeSound)];
}

- (void) setupRemoteNotificationForiOS8And9 {
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
  
  // Adding Appboy default categories
  NSMutableSet *categories = [NSMutableSet setWithSet:[ABKPushUtils getAppboyUIUserNotificationCategorySet]];
  [categories addObject:likeCategory];
  UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:categories];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
  [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void) setupRemoteNotificationForiOS10 {
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
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
  // Adding Appboy default categories
  NSMutableSet *categories = [NSMutableSet setWithSet:[ABKPushUtils getAppboyUNNotificationCategorySet]];
  [categories addObject:likeCategory];
  [center setNotificationCategories:categories];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void) setUpRemoteNotification {
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
    [self setupRemoteNotificationForiOS10];
  } else if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
    [self setupRemoteNotificationForiOS8And9];
  } else {
    [self setupRemoteNotificationForiOS7];
  }
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
  return NO;
}

// Pass the deviceToken to Appboy as well
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"didRegisterForRemoteNotificationsWithDeviceToken: %@",deviceToken]];
  NSLog(@"In application:didRegisterForRemoteNotificationsWithDeviceToken, token is %@", [NSString stringWithFormat:@"%@", deviceToken]);
  [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
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
  
  if ([[Appboy sharedInstance] pushNotificationWasSentFromAppboy:userInfo]) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"User notification was sent from Appboy, clearing badge number.");
  }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
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

// Here we are trying to handle deep linking with scheme beginning with "stopwatch".
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  NSLog(@"Stopwatch get a deep link request: %@", url.absoluteString);
  NSString *urlString = url.absoluteString.stringByRemovingPercentEncoding;
  UIAlertView *deepLinkAlert = [[UIAlertView alloc] initWithTitle:@"Deep Linking" message:urlString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [deepLinkAlert show];
  deepLinkAlert = nil;
  return YES;
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

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  NSLog(@"Application delegate method userNotificationCenter:willPresentNotification:withCompletionHandler: is called.");
  completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  [[Appboy sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
  NSLog(@"Application delegate method userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: is called with user info: %@", response.notification.request.content.userInfo);

  if ([[Appboy sharedInstance] userNotificationWasSentFromAppboy:response]) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"User notification was sent from Appboy, clearing badge number.");
  }
}

#pragma mark - ABKInAppMessageControllerDelegate methods

- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage withKeyboardIsUp:(BOOL)keyboardIsUp {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You've got mail!"
                                                  message:inAppMessage.message
                                                 delegate:nil
                                        cancelButtonTitle:@"Unset this from the Advanced tab"
                                        otherButtonTitles:nil];
  [alert show];
  return ABKDiscardInAppMessage;
}

@end
