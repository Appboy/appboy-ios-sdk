#import <Foundation/Foundation.h>

static NSString *const ABKAppboyPushNotificationUninstallTrackingKey = @"appboy_uninstall_tracking";

/*
 * Appboy Public API: ABKPushUtils
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKPushUtils : NSObject

+ (BOOL) isUninstallTrackingNotification:(NSDictionary *)userInfo;

@end
NS_ASSUME_NONNULL_END
