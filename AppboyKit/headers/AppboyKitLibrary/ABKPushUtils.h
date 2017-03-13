#import <Foundation/Foundation.h>
#if !TARGET_OS_TV
#import <UserNotifications/UserNotifications.h>
#endif
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const ABKAppboyPushNotificationUninstallTrackingKey = @"appboy_uninstall_tracking";
static NSString *const ABKAppboyPushNotificationFetchTestTriggersKey = @"ab_push_fetch_test_triggers_key";

/*
 * Appboy Public API: ABKPushUtils
 */
@interface ABKPushUtils : NSObject

+ (BOOL)isUninstallTrackingNotification:(NSDictionary *)userInfo;
+ (BOOL)shouldFetchTestTriggersFlagContainedInPayload:(NSDictionary *)userInfo;
#if !TARGET_OS_TV
+ (NSSet<UNNotificationCategory *> *)getAppboyUNNotificationCategorySet;
+ (NSSet<UIUserNotificationCategory *> *)getAppboyUIUserNotificationCategorySet;
#endif

@end
NS_ASSUME_NONNULL_END
