//
//  AppDelegate.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppboyKit.h"
#import "NUIAppearance.h"

static NSString *const AppboyApiKey = @"5e4a8e9e-d908-497c-9272-a6003b91ac71";

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // This starts up Appboy
  [Appboy startWithApiKey:AppboyApiKey
            inApplication:application
        withLaunchOptions:launchOptions];

  // This lets us use NUI, the theming/customization package. There is also some initialization code in main.m
  // Look at NUI/NUIStyle.nss to see what's being customized.
  [NUIAppearance init];

  // Enable/disable Appboy to use NUI theming. Try turning it on and off to see the results!  (Look at the Appboy
  // feedback form and news feed).
  [Appboy sharedInstance].useNUITheming = NO;

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
  [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo];
}

// Pass the deviceToken to Appboy as well
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[Appboy sharedInstance] registerPushToken:[NSString stringWithFormat:@"%@", deviceToken]];
}
@end
