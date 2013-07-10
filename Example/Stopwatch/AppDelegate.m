//
//  AppDelegate.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppboyKit.h"
#import "NUIAppearance.h"

static NSString *const AppboyApiKey = @"appboy-ios-sample";

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [Crittercism enableWithAppID: @"51b67d141386207417000002"];
  
  // here looks like a Crittercism bug. In the new version they get rid of the sharedInstance method
  // and give the following code(commented) as sample in documentation, but didCrashOnLastLoad is
  // an instance method, not a class method, and it crash the app.
//  if ([Crittercism didCrashOnLastLoad]) {
//    NSLog(@"App crashed the last time it was loaded");
//  }
  
  [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"start Appboy with API key: %@",AppboyApiKey]];
  // This starts up Appboy
  [Appboy startWithApiKey: AppboyApiKey
            inApplication:application
        withLaunchOptions:launchOptions];

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
  [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}
@end
