#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const ABKAppboyPushNotificationUninstallTrackingKey = @"appboy_uninstall_tracking";
static NSString *const ABKAppboyPushNotificationFetchTestTriggersKey = @"ab_push_fetch_test_triggers_key";

/*
 * Appboy Public API: ABKPushUtils
 */
@interface ABKPushUtils : NSObject

+ (BOOL)isUninstallTrackingNotification:(NSDictionary *)userInfo;
+ (BOOL)shouldFetchTestTriggersFlagContainedInPayload:(NSDictionary *)userInfo;

@end
NS_ASSUME_NONNULL_END
