#import <Foundation/Foundation.h>

static NSString *const ABKAppboyPushNotificationUninstallTrackingKey = @"appboy_uninstall_tracking";

/*
 * Appboy Public API: ABKPushUtils
 */
@interface ABKPushUtils : NSObject

+ (BOOL) isUninstallTrackingNotification:(NSDictionary *)userInfo;

@end
