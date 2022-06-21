#import "Appboy.h"
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <XCTest/XCTest.h>

/**
 * A collection of test cases to verify a successful implementation of push
 * notifications using Braze.

 * In a unit testing target, as long as this file is included,
 * the target will run all of this class's unit tests. No additional code is required.
 *
 * @seealso https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_notifications/integration/
 */
@interface AppboyPushUnitTests : XCTestCase

@end

@implementation AppboyPushUnitTests

// MARK: - Push Registration

/**
 * Checks whether the app registers for push notifications when launching.
 *
 * @discussion This test case will pass if the AppDelegate's
 * @c application:didFinishLaunchingWithOptions: method results in a call to:
 *
 * @code
 * [[UIApplication sharedApplication] registerForRemoteNotifications];
 * @endcode
 *
 * @seealso https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_notifications/integration/#step-3-register-for-push-notifications
 */
- (void)testDidFinishLaunchingWithOptions_RegistersForPush {
  id partialMock = [OCMockObject partialMockForObject:UIApplication.sharedApplication];
  UIApplication *application = UIApplication.sharedApplication;

  // Launch app
  [application.delegate application:application didFinishLaunchingWithOptions:nil];

  // Confirm app registered for push
  OCMVerify([partialMock registerForRemoteNotifications]);
}

// MARK: - Push Tokens

/**
 * Checks whether the app registers the device's push token with the
 * Braze SDK when the system registers for push notifications.
 *
 * @discussion This test case will pass if the AppDelegate's
 * @c application:didRegisterForRemoteNotificationsWithDeviceToken: method
 * results in a call to:
 *
 * @code
 * [[Appboy sharedInstance] registerDeviceToken:deviceToken];
 * @endcode
 *
 * @seealso https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_notifications/integration/#step-4-register-push-tokens-with-braze
 */
- (void)testDidRegisterForRemoteNotificationsWithDeviceToken {
  id partialMock = [OCMockObject partialMockForObject:[Appboy sharedInstance]];
  UIApplication *application = UIApplication.sharedApplication;
  NSData *token = [[NSData alloc] init];

  // Register with device token
  [application.delegate application:application didRegisterForRemoteNotificationsWithDeviceToken:token];

  // Confirm device token logged to Braze
  OCMVerify([partialMock registerDeviceToken:token]);
}

// MARK: - Push Analytics and Handling

/**
 * Checks whether the app uses Braze to handle newly received push notifications.
 *
 * @discussion This test case will pass if the AppDelegate's
 * @c application:didFinishLaunchingWithOptions: method sets a valid
 * @c UNUserNotificationCenterDelegate as the
 *
 * @code
 * [UNUserNotificationCenter currentNotificationCenter].delegate
 * @endcode
 *
 * AND the AppDelegate's
 * @c application:didReceiveRemoteNotification:fetchCompletionHandler: method
 * results in a call to:
 *
 * @code
 * [[Appboy sharedInstance] registerApplication:application
 *                 didReceiveRemoteNotification:userInfo
 *                       fetchCompletionHandler:completionHandler];
 * @endcode
 *
 * @seealso https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_notifications/integration/#step-5-enable-push-handling
 */
- (void)testDidReceiveRemoteNotification {
  id partialMock = [OCMockObject partialMockForObject:[Appboy sharedInstance]];
  UIApplication *application = UIApplication.sharedApplication;

  // Receive notification
  [application.delegate application:application
       didReceiveRemoteNotification:@{}
             fetchCompletionHandler:^(UIBackgroundFetchResult result) {}];

  // Confirm notification logged to Braze
  OCMVerify([partialMock registerApplication:application
                didReceiveRemoteNotification:@{}
                      fetchCompletionHandler:[OCMArg any]]);
}

/**
 * Checks whether the app uses Braze to handle any interaction with a push notification.
 *
 * @discussion This test case will pass if the AppDelegate's
 * @c application:didFinishLaunchingWithOptions: method sets a valid
 * @c UNUserNotificationCenterDelegate as the
 *
 * @code
 * [UNUserNotificationCenter currentNotificationCenter].delegate
 * @endcode
 *
 * AND the AppDelegate's
 * @c userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: method
 * results in a call to:
 *
 * @code
 * [[Appboy sharedInstance] userNotificationCenter:center
 *                  didReceiveNotificationResponse:response
 *                           withCompletionHandler:completionHandler];
 * @endcode
 *
 * @seealso https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_notifications/integration/#step-5-enable-push-handling
 */
- (void)testDidReceiveNotificationResponse {
  id partialMock = [OCMockObject partialMockForObject:[Appboy sharedInstance]];
  UNUserNotificationCenter *notificationCenter = UNUserNotificationCenter.currentNotificationCenter;
  UNNotificationResponse *response = OCMClassMock([UNNotificationResponse class]);

  // Receive notification response
  [notificationCenter.delegate userNotificationCenter:notificationCenter
                       didReceiveNotificationResponse:response
                                withCompletionHandler:^{}];

  // Confirm response logged to Braze
  OCMVerify([partialMock userNotificationCenter:notificationCenter
                 didReceiveNotificationResponse:response
                          withCompletionHandler:[OCMArg any]]);
}

/**
 * Checks whether the app handles push notifications while foregrounded.
 *
 * @discussion This test case will pass if the AppDelegate's
 * @c userNotificationCenter:willPresentNotification:withCompletionHandler: method
 * results in calling the provided @c completionHandler
 *
 * @seealso https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_notifications/integration/#step-5-enable-push-handling
 */
- (void)testForegroundPushHandling {
  UNUserNotificationCenter *notificationCenter = UNUserNotificationCenter.currentNotificationCenter;
  UNNotification *notification = OCMClassMock([UNNotification class]);

  XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Completion handler should be called"];

  [notificationCenter.delegate userNotificationCenter:notificationCenter
                              willPresentNotification:notification
                                withCompletionHandler:^(UNNotificationPresentationOptions options) {
    [expectation fulfill];
  }];

  [self waitForExpectations:@[expectation] timeout:0.5];
}

@end
