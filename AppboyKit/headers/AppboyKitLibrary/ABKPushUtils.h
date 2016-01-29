#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const ABKAppboyPushNotificationUninstallTrackingKey = @"appboy_uninstall_tracking";

/*
 * Appboy Public API: ABKPushUtils
 */
@interface ABKPushUtils : NSObject

+ (BOOL) isUninstallTrackingNotification:(NSDictionary *)userInfo;

@end
NS_ASSUME_NONNULL_END
