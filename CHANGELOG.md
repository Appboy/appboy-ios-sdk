## 3.15.0

##### Breaking
- Adds support for SDWebImage version 5.0.
  - Note that upgrading to SDWebImage 5.0 also removed the FLAnimatedImage transitive dependency from the SDK.

## 3.14.1

##### Changed
- Changed in-app message trigger behavior to not perform trigger events until after any pending trigger sync requests to the server have finished.

##### Fixed
- Fixed a serialization issue that could cause improper type conversions for certain decimal values.
- Fixed a behavior introduced in 3.12.0 which caused in-app messages to not be considered triggered locally if `ABKDiscardInAppMessage` was returned by the host app in `beforeInAppMessageDisplayed:`.

##### Added
- Added the ability to set the session timeout via the Info.plist.
  - Add the `Appboy` dictionary to your Info.plist file. Inside the `Appboy` Dictionary, add the `SessionTimeout` Number subentry and set the value to your session timeout.
- Added the ability to disable location tracking via the Info.plist.
  - Add the `Appboy` dictionary to your Info.plist file. Inside the `Appboy` Dictionary, add the `DisableAutomaticLocation` Boolean subentry and set the value to `YES`.
- Added dynamic cell resizing for Content Cards cells with templated images in our default Content Cards UI.
- Added validation to the local filename's canonical path during zip file extraction.

## 3.14.0

##### Added
- Improves the look and feel of In-App Messages to adhere to the latest UX and UI best practices. Changes affect font sizes, padding, and responsiveness across all message types. Now supports button border styling.

## 3.13.0

##### Breaking
- Upgrades the delivery mechanism of Push Stories to allow delivery even after a user’s app has been force closed..
  - ***Required:*** Please change your integration to use `ab_cat_push_story_v2` instead of `ab_cat_push_story` for the `UNNotificationExtensionCategory` in your content extension. See [documentation for more details.](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_story/#step-8-set-the-notification-content-extension-plist)

##### Changed
- Improves in-app message triggering logic to fall back to lower priority messages when the Braze server aborts templating (e.g. from a Connected Content abort in the message body, or because the user is no longer in the correct Segment for the message).
- Updates German translations to improve formatting.

## 3.12.0

##### Breaking
- Drops support for iOS 8.
- Adds support for the arm64e architecture when building with Cocoapods. Requires Xcode 10.1.

##### Fixed
- Fixes bitcode support for the Push Story framework when using Xcode 10.
- Improves triggered in-app message re-eligibility logic to better handle templating failures.

##### Changed
- Changes the behavior of News Feed so that only one impression is logged for each card per News Feed open.

##### Added
- Adds HTML IAM `appboyBridge` ready event to know precisely when the `appboyBridge` has finished loading.
  - Example below:
    ```javascript
     <script type="text/javascript">
       function logMyCustomEvent() {
         appboyBridge.logCustomEvent('My Custom Event');
       }
       window.addEventListener('ab.BridgeReady', logMyCustomEvent, false);
     </script>
    ```

##### Removed
- Removes Cross-Promotion cards from the News Feed.
  - Cross-Promotion cards have also been removed as a card model and will thus no longer be returned.

## 3.11.0

##### Added
- Adds the ability to set or remove custom location attributes for a specific user from within HTML IAMs.
- Updates the SDK to report users who disable banner notifications but are still opted-in to push notifications as push enabled. Note this change does not affect provisionally authorized users on iOS 12, who were considered push enabled before this release regardless of their banner notification settings.
- Adds Carthage Core support which allows for integration with the core Braze SDK without any UI components. To implement the core SDK, add `binary "https://raw.githubusercontent.com/Appboy/appboy-ios-sdk/master/appboy_ios_sdk_core.json"` to your `Cartfile`.

##### Changed
- Deprecates the Feedback feature.

##### Fixed
- Fixes an issue with the JS bridge when trying to set a custom attribute with the character '&'.

## 3.10.0

##### Added
- Adds the ability to specify a whitelist for device fields that are collected by the Braze SDK.
  - Configurable device fields are defined in the `ABKDeviceOptions` enum.
  - To specify whitelisted device fields, assign the bitwise `OR` of desired fields to `ABKDeviceWhitelistKey` in the `appboyOptions` of `startWithApiKey:inApplication:withAppboyOptions:`.
    - For example, to specify timezone and locale collection to be whitelisted, set `appboyOptions[ABKDeviceWhitelistKey] = @(ABKDeviceOptionTimezone | ABKDeviceOptionLocale);`.
  - To turn off all fields, set `appboyOptions[ABKDeviceWhitelistKey] = @(ABKDeviceOptionNone);`.
  - By default, all fields are enabled.
- Added the `clicked` property to `ABKContentCard`. Clicks made through `[ABKContentCard logContentCardClicked]` are now saved locally on the device.

##### Breaking
- Removes `ABKSignificantChangeCollectionEnabledOptionKey`, `ABKSignificantChangeCollectionDistanceFilterOptionKey`, and `ABKSignificantChangeCollectionTimeFilterOptionKey` from the `Appboy` interface.

##### Removed
- Removes the ability to optionally track locations in the background.

##### Fixed
- Fixes an issue where Slideup and Full In-App Message content could be obscured by the notch on iPhone XR and iPhone XS Max.

## 3.9.0

##### Breaking
- Adds support for iOS 12. Requires Xcode 10.

##### Fixed
- Fixes minor issues with subclassing `ABKInAppMessageModalViewController` and News Feed request timeouts.
  - Thanks @datkinnguyen for your contribution.

## 3.8.4

##### Fixed
- Fixes a regression introduced in version 3.8.3 that caused background tasks to extend beyond execution time.

## 3.8.3

##### Fixed
- Fixes an issue where `ABKContentCardsController unviewedContentCardCount` would always return 0.

##### Changed
- Updates the Content Cards UI with minor layout improvements.

## 3.8.2

##### Fixed
- Fixes an issue with possible build failure when using Content Cards related to duplicate image names in Content Cards and News Feed pods. Please use this version if integrating Content Cards.

##### Changed
- Updates the Content Cards UI with minor layout improvements.

## 3.8.1

##### Fixed
- **Important**: Fixes an issue with Content Cards syncing. Note: As additional fixes were added in later versions, please use Braze iOS SDK version 3.8.2 or above if integrating Content Cards.

## 3.8.0

##### Added
- In `ABKUser` class, `addLocationCustomAttributeWithKey:latitude:longitude:` and `removeLocationCustomAttributeWithKey:` methods are added to manage location custom attributes.
- Introduces support for the upcoming Content Cards feature, which will eventually replace the existing News Feed feature and adds significant capability. This feature is currently in closed beta testing; if you're interested in joining the beta, please reach out to your Customer Success Manager or Account Manager.

##### Changed
- Status bar is not obscured when displaying a full screen in-app message.

## 3.7.1

##### Changed
- Improves data handling immediately following a user change to bring behavioral parity with the Android and Web SDKs.

## 3.7.0

#### Breaking
- In `ABKInAppMessageUIControlling` protocol, `getCurrentDisplayChoiceForControlInAppMessage` method is added to define whether the control in-app message impression should be logged now, later or discarded.
- In `ABKInAppMessageControllerDelegate` protocol, `beforeControlMessageImpressionLogged` method is added to define whether the control in-app message impression should be logged now, later or discarded.

##### Added
- `CLLocationManager` authorization requests can now be prevented from compiling by setting a Preprocessor flag `ABK_DISABLE_LOCATION_SERVICES`.

##### Fixed
- Fixes an issue where in-app messages triggered on session start could potentially be templated with the old user's attributes.

## 3.6.0

##### Breaking
- In `ABKSDWebImageProxy.h`, renames `removeImageForKey` to `removeSDWebImageForKey` and `clearCache` to `clearSDWebImageCache` to avoid conflicts with internal Apple API. **Important:** We have received reports of sporadic App Store rejection stemming from Apple's static checks mistaking our APIs for an invalid usage of the internal Apple API. We recommend new App Store submissions integrating the Braze iOS SDK ship with this version or above to decrease the likelihood of rejection.

##### Added
- Exposes `handleCardClick` on `ABKNewsFeedTableViewController.h` to enable custom handling via subclassing.
- Improves News Feed image handling on iPad.

## 3.5.1

##### Fixed
- Fixes an issue with integrating the NewsFeed subspec in Swift projects via Cocoapods.

## 3.5.0

##### Breaking
- Open sources the News Feed UI code and moves it into a new subspec named "NewsFeed".
  - Manual integrators must now add the `AppboyUI` folder of this repository to their projects as a group, in addition to `AppboyKit`.
  - The "NewsFeed" subspec contains the Braze News Feed UI and the Core SDK. It does not include the Feedback or In-App Message UI.
  - The "UI" subspec contains all Braze UI and the Core SDK subpsec.
  - `ABKFeedViewControllerDelegate` was removed.
  - To integrate a navigation context News Feed, use the following code:
  ```
  ABKNewsFeedTableViewController *newsFeed = [ABKNewsFeedTableViewController getNavigationFeedViewController];
  [self.navigationController pushViewController:newsFeed animated:YES];
  ```
  - To integrate a modal context News Feed, use the following code:
  ```
  ABKNewsFeedViewController *newsFeed = [[ABKNewsFeedViewController alloc] init];
  [self.navigationController presentViewController:newsFeed animated:YES completion:nil];
  ```
  - See our [News Feed Sample app](https://github.com/Appboy/appboy-ios-sdk/tree/master/Samples/NewsFeed/BrazeNewsFeedSample) for sample implementations and customizations.
- Removes NUI support for Feedback, In-App Messages, and the News Feed.
  - All customization can now be done by using categories or by extending our open sourced view controllers.  
- Removes deprecated `ABKPushURIDelegate` from the SDK. Use `ABKURLDelegate` instead.


## 3.4.0

##### Breaking
- Adds `preferredOrientation` to `ABKInAppMessageUIController` and `ABKInAppMessageWindowController`.
- Removes `supportedOrientations` from `ABKInAppMessageUIController` and `ABKInAppMessageWindowController`.
- Renames `supportedOrientationMasks` to `supportedOrientationMask` in `ABKInAppMessageUIController` and `ABKInAppMessageWindowController`.

##### Fixed
- Fixes an issue that caused GIFs to not animate on SDWebImage versions above or equal to 4.3.0

## 3.3.4

##### Added
- Adds the ability to view verbose logs from the SDK for debugging.
  - To enable verbose logging, add a dictionary named `Appboy` to your `Info.plist` file. Inside the `Appboy` Dictionary, add the `LogLevel` String subentry and set the value to "0".

## 3.3.3

##### Added
- Adds `wipeDataAndDisableForAppRun:` on the `Appboy` interface to support wiping all customer data created by the Braze SDK.
- Adds `disableSDK:` and `requestEnableSDKOnNextAppRun:` to the `Appboy` interface to disable and re-enable the Braze SDK.

##### Fixed
- Fixes an issue where events setting custom attribute arrays to `nil` would persist on the SDK beyond their useful life.

## 3.3.2

##### Changed
- Updates the SDK with internal, non-functional improvements.

## 3.3.1

##### Added
- Adds `Other`, `Unknown`, `Not Applicable`, and `Prefer not to Say` options for user gender.
- Adds umbrella header files `AppboyFeedback.h` and `AppboyInAppMessage.h` for the `Feedback` and `InAppMessage` subspecs.

##### Fixed
- Fixes an issue where the method `beforeInAppMessageDisplayed:` in class `ABKInAppMessageControllerDelegate` is not called when the host app is using the `Core` subspec.

## 3.3.0

##### Breaking
- Open sources the In-App Message UI code and moves it into a new subspec named "InAppMessage".
  - Manual integrators must now add the `AppboyUI` folder of this repository to their projects as a group, in addition to `AppboyKit`.
  - The "InAppMessage" subspec contains the Braze In-App Message UI and the Core SDK. It does not include Feedback or the News Feed UI.
  - The "UI" subspec contains all Braze UI and the Core SDK subpsec.
  - The open-sourced In-App Message view controllers offer backward compatible NUI support, although we recommend using categories or subclassing the In-App Message view controllers for customization as the NUI library isn't actively maintained any more. Support for NUI customization will be removed in a future release.
  - Most delegate customization methods are moved from ABKInAppMessageControllerDelegate to ABKInAppMessageUIDelegate.
  - See our [In-App Message Sample app](https://github.com/Appboy/appboy-ios-sdk/tree/master/Samples/InAppMessage/BrazeInAppMessageSample) for sample implementations and customizations.
 - Removes support for original in-app messages. Moving forward, triggered in-app messages must be used.
  - Removes `requestInAppMessageRefresh` method from `Appboy`.

##### Changed
- Removes the current behavior of displaying an in-app message from the stack on app open, if the stack is non-empty

##### Fixed
- Adds Macros for methods which are only available from iOS 10.
  - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/128.
- Stops using deprecated `openURL:` method when in iOS 10 and above.
  - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/132.

## 3.2.3

##### Fixed
- Fixes an issue introduced in version 3.0.0 which caused detailed device model information to not be collected by the SDK.
- Fixes an issue where Braze's Carthage framework did not support simulators.

## 3.2.2

##### Fixed
- Fixes an issue where Slideup and Full In-App Message content could be obscured by the notch on iPhone X.

## 3.2.1

##### Fixed
- Fixes an issue where Push Story Framework did not support bitcode.

## 3.2.0

##### Added
- Adds Push Stories, a new push type that uses UNNotificationContentExtension to display multiple images in a single notification.
  - This feature requires iOS 10 and above.

##### Fixed
- Fixes an issue where tvOS SDK did not support bitcode.

## 3.1.1

##### Added
- Adds a new property `language` to `ABKUser` to allow explicit control over the user's language in the Braze dashboard. Note that this is separate and independent from the language settings on the user's device.
- Adds an Objective-C sample app for the Core subspec of the SDK. See `Samples/Core/ObjCSample`.

##### Fixed
 - Fixes a bug introduced in version 2.30 where crashes could occur if the SDK was directed to handle a custom scheme deep link inside a WebView.   
   - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/122.
 - Fixes a bug introduced in version 3.0 where new custom attributes were not being flushed if custom attributes had been previously flushed in the same foregrounded session.
 - Fixes a bug introduced in version 3.0 where previously flushed custom attributes were being re-sent.
 - Fixes an issue where slow image fetching blocked image-only modal in-app messages from displaying.
   - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/118.

## 3.1.0

##### Breaking
- Adds support for iOS 11. Requires Xcode 9.

## 3.0.2

##### Added
- Adds the ability to set a custom API endpoint via the Info.plist.
   - Add the `Appboy` dictionary to your Info.plist file. Inside the `Appboy` Dictionary, add the `Endpoint` String subentry and set the value to your custom endpoint (e.g., `sdk.api.braze.eu`).

##### Fixed
- Fixes an issue where changing the IDFA settings through a third party wrapper could cause a crash.

## 3.0.1

##### Fixed
- Fixes an issue where calling `incrementCustomUserAttribute:` on `ABKUser` could cause a crash.

## 3.0.0

##### Breaking
- Removes the deprecated `foursquareAccessToken` property from `ABKUser`. To associate a Foursquare access token with a user profile, use `setCustomAttributeWithKey:andStringValue:` instead.
- Note: Braze iOS SDK version 3.0.0 will **only support downgrading to iOS SDK version 2.31.0**. Downgrading to versions prior to 2.31.0 may result in app crashes.

##### Added
- Adds a major performance upgrade that reduces CPU usage, memory footprint, and network traffic.

## 2.31.0

##### Breaking
 - Open sources the Feedback view controllers and moves them into a new subspec "Feedback".
   - The "Feedback" subspec has the Braze Feedback UI and the Core SDK. It will not include in-app messages or News Feed UI.
   - Removes the popover context for Feedback due to the deprecation of `UIPopoverViewController` in iOS.
   - Renames the `ABKFeedbackViewControllerModalContext` and `ABKFeedbackViewControllerNavigationContext` class to `ABKModalFeedbackViewController` and `ABKNavigationFeedbackViewController`.
   - The open-sourced Feedback view controllers offer backward compatible NUI support, although we recommend using categories or subclassing the Feedback view controllers for customization as NUI library isn't actively maintained any more. See [here](https://github.com/Appboy/appboy-ios-sdk/tree/master/AppboyUI/ABKFeedbackViewController/FeedbackViewController/ABKFeedbackViewController.h) for customization details.
   - See our [Feedback Sample app](https://github.com/Appboy/appboy-ios-sdk/tree/master/Samples/Feedback/AppboyFeedbackSample) for sample implementations and customizations.

##### Added
- Adds user aliasing capability. Aliases can be used in the API and dashboard to identify users in addition to their ID. See the `addAlias:withLabel:` method on `ABKUser` for more information.

##### Changed
 - Updates the `AppboyKit.h` to include all the public header files in the SDK.

## 2.30.0

##### Breaking
 - Open sources the `ABKModalWebViewController` class, which is used to display the web URLs from push or in-app message clicks.
   - Drops NUI customization support for the navigation bar and navigation bar button item on `ABKModalWebViewController`. To customize the UI, create an ABKModalWebViewController category and override the corresponding method(s) exposed.
 - Open sources the `ABKNoConnectionLocalization` class, which provides Braze's default localized string for "No Connection" error.
   - You can customize the localization by adding `Appboy.no-connection.message` as the key in your `Localizable.strings` files.
 - Removes the `Appboy.bundle` from the Core subspec of the SDK.
   - If you use the Core subspec, the in-app messages will not display, and trying to display Braze's News Feed and Feedback UI will lead to unpredictable behavior.

## 2.29.1

##### Added
 - Adds a new property `buttonTextFont` to `ABKInAppMessageButton`. It allows clients to set customized fonts on in-app message buttons before the in-app message is displayed.

##### Fixed
 - Makes class `ABKInAppMessageWindowController.h` public.
   - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/105.
 - Fixes an issue where device information was not flushed for a new user when server requests were queued for two or more users.

##### Changed
 - Removes the warnings in `ABKSDWebImageProxy`.

## 2.29.0

##### Breaking
 - Drops support for iOS 7.
 - Removes the `shouldOpenURIExternally` field from `ABKInAppMessage`.
 - Requires XCode 8.3.
 - Changes the behavior of the `onCardClicked:feedViewController:` method in `ABKFeedViewControllerDelegate` to let Braze handle the card click action if the delegate method returns `NO`.
   - Previously, Braze would handle the card click action if `onCardClicked:feedViewController:` returned `YES`.
   - This change standardizes delegate behavior with `ABKInAppMessageControllerDelegate` and `ABKURLDelegate`.

##### Added
 - Adds the property `openUrlInWebView` to `ABKInAppMessage`, `ABKInAppMessageButton` and `ABKCard`. This property determines if the URL associated with the object will be opened in a `UIWebView`.
 - Adds a Javascript interface to HTML in-app messages with ability to log custom events, log purchases, set user attributes, navigate users, and close the message.
 - Adds an `abDeepLink` query field to HTML in-app messages, which defaults to false. To prevent the SDK from opening deep links in a `UIWebView`, specify `abDeepLink=true` in your link (e.g., `https://www.braze.com?abDeepLink=true`).
 - Adds the `ABKURLDelegate` protocol for customizing URL handling across channels. Set the `ABKURLDelegate` by passing a delegate object to the `ABKURLDelegateKey` in the `appboyOptions` of `startWithApiKey:inApplication:withAppboyOptions:`. See our [Stopwatch sample application](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/AppDelegate.m) for a Universal Link implementation sample.
 - Adds the following utility methods to `ABKPushUtils` for detecting if a push notification was sent by Braze for internal feature purposes:
   - `+ (BOOL)isAppboyInternalUserNotification:(UNNotificationResponse *)response;`
   - `+ (BOOL)isAppboyInternalRemoteNotification:(NSDictionary *)userInfo;`
   - `+ (BOOL)isUninstallTrackingUserNotification:(UNNotificationResponse *)response;`
   - `+ (BOOL)isGeofencesSyncUserNotification:(UNNotificationResponse *)response;`
   - `+ (BOOL)isGeofencesSyncRemoteNotification:(NSDictionary *)userInfo;`
   - These methods can be used to ensure that your app does not take any undesired or unnecessary actions upon receiving Braze's internal content-available notifications (e.g., pinging your server for content).

##### Changed
 - Deprecates `ABKPushURIDelegate`. If you were previously using `ABKPushURIDelegate`, use `ABKURLDelegate` instead.
 - Deprecates `userNotificationWasSentFromAppboy:` and `pushNotificationWasSentFromAppboy:` on `Appboy`. Use `isAppboyUserNotification:` and `isAppboyRemoteNotification:` on `ABKPushUtils` instead.
 - Deprecates `shouldFetchTestTriggersFlagContainedInPayload:` on `ABKPushUtils`.

## 2.28.0

##### Breaking:
 - Removes support for watchOS 1, including Braze WatchKit SDK and all public APIs for watchOS in Braze iOS SDK.

##### Added
 - Adds `ABKSDWebImageProxy` to access the SDWebImage framework. This will prevent the Core subspec of the SDK from calling any SDWebImage methods directly.

## 2.27.0

##### Breaking
 - Removes the following deprecated items:  the `bio` field of `ABKUser`, the `setIsSubscribedToEmails:` method of `ABKUser`, and the `getResourceEndpoint:` method of the `ABKAppboyEndpointDelegate` protocol.

##### Added
 - Adds support for registering geofences and messaging on geofence events. Please reach out to success@braze.com for more information about this feature.
 - Adds Braze default push categories which can be fetched from `ABKPushUtils`.
   - To use the Braze default push categories, you need to manually add the Braze categories when you register for push. You can get the Braze categories from `[ABKPushUtils getAppboyUNNotificationCategorySet]` or `[ABKPushUtils getAppboyUIUserNotificationCategorySet]`.
   - In this version, we add four sets of push action buttons: accept/decline, yes/no, confirm/cancel, more. These will be available as button sets on the dashboard when creating an iOS push campaign.
   - All Braze push action buttons support localization.
 - Adds support for web link and deep link handling of push action buttons.

##### Fixed
 - Fixes the issue where the combination of the Core subspec of the SDK and a non-supported version of SDWebImage framework can cause apps to crash.
   - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/104.

##### Changed
 - HTML in-app messages now log body click analytics on all links that are not `appboy://customEvent` and do not include the `abButtonId` query field. Previously, no body click analytics were logged.

##### Removed
 - Removes deprecated method `- (NSString *)getResourceEndpoint:(NSString *)appboyResourceEndpoint` from `ABKAppboyEndpointDelegate`.
 - Removes deprecated property `bio` and deprecated method `- (BOOL)setIsSubscribedToEmails:(BOOL)subscribed` from `ABKUser`.

## 2.26.0

##### Breaking
 - Adds support for SDWebImage version 4.0.0 with GIF support. SDWebImage version 3.x will not be supported from this version on. Please make sure you are using the correct version of SDWebImage.framework.  Note: SDWebImage 4.0.0 relies on FLAnimatedImage - users integrating in ways besides CocoaPods should ensure they link the FLAnimatedImage framework if they want GIF support.
 - Removes the `url` property from subclasses of `ABKCard`. This property has been renamed to `urlString` and moved onto the `ABKCard` superclass.

##### Added
 - Adds Cocoapods subspecs "Core" and "UI".
   - The "UI" subspsec has the full feature set of the current SDK. This is the default subspec when no subspec is specified in the Podfile.
   - The "Core" subspec removes the SDWebImage framework dependency. This is for apps who do not use any Braze UI that leverages images (News Feed, in-app messages). If you use the "Core" subspec, in-app messages with images will not display, and the News Feed will render with plain white images.
 - Makes `ABKThemableFeedNavigationBar.h` and `ABKNavigationBar.h` public.
   - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/68
 - Adds an `unsafeInstance` method that returns a nonoptional `Appboy` instance. If used before calling `startWithApiKey:` an exception will be thrown.
   - Addresses https://github.com/Appboy/appboy-ios-sdk/issues/45.
 - Adds `ABKIDFADelegate` protocol that can be used to create a delegate to pass Braze the IDFA in `startWithApiKey:` in the `appboyOptions` dictionary under the `ABKIDFADelegateKey` key.  Alternative to existing `ABKIdentifierForAdvertisingProvider` compile flag solution.

##### Changed
 - Disables the `-webkit-touch-callout` property on HTML in-app messages. Long presses and 3D Touch on links will no longer display pop-ups with additional link information.

## 2.25.0

##### Added
- Adds the ability to set the `ABKInAppMessageControllerDelegate` when the SDK starts by passing a delegate object to the `ABKInAppMessageControllerDelegateKey` in the `appboyOptions` of `startWithApiKey:inApplication:withAppboyOptions:`.
  - This is the recommended way to set the `ABKInAppMessageControllerDelegate` and circumvents a potential race condition where in-app messages can be shown before the delegate has been set.
- Exposes the ABKFeedback object and adds a new method `- (void)submitFeedback:(ABKFeedback *)feedback withCompletionHandler:(nullable void (^)(ABKFeedbackSentResult feedbackSentResult))completionHandler;` in `Appboy`. The new method accepts a completion handler which receives an ABKFeedbackSentResult enum as feedback sending result.
  - The possible feedback sending results are: invalid feedback object(ABKInvalidFeedback), fail to send feedback(ABKNetworkIssue), and feedback sent successfully(ABKFeedbackSentSuccessfully).
- Adds the utility method `- (BOOL)userNotificationWasSentFromAppboy:(UNNotificationResponse *)response;` to `Appboy`. This method is compatible with the `UserNotifications` framework and returns whether a push notification was sent from Braze's server.
  - Those using `- (BOOL)pushNotificationWasSentFromAppboy:(NSDictionary *)options;` who have integrated the `UserNotifications` framework should use this method instead.

##### Fixed
 - Changes the ABKInAppMessageButton from a `UIButton` object to a pure data model class in `NSObject`.
   - This resolves the issue https://github.com/Appboy/appboy-ios-sdk/issues/97.

##### Changed
 - Adds more protection around triggered in-app message display.

## 2.24.5

##### Fixed
 - Fixes an issue where in-app messages triggered off of push clicks wouldn't fire when the push click happened before the in-app message configuration was synced to the device.

##### Changed
 - Updates push registration to flush the token to the server immediately.
 - Improves the accessibility of in-app messages and news feed cards.
   - When in voiceOver mode, the SDK auto-focuses on in-app messages when they appear and resets focus on dismissal.  
   - VoiceOver no longer reads Braze internal labels.  
   - News feed cards are enhanced to be more accessible.

## 2.24.4

##### Added
 - Adds protection around in-app message UI code to avoid displaying in-app messages with corrupted images.

##### Fixed
 - Fixes the iOS version number in the deprecation warnings in Appboy.h.

## 2.24.3

##### Breaking
 - Update REQUIRED for apps using Braze SDK 2.24.0, 2.24.1 or 2.24.2 with UserNotifications.framework

##### Fixed
 - Fixes an issue where a user's foreground push enabled status could erroneously be marked as disabled.
   - This issue can occur when opening the app from suspended mode. At that time, the foreground push enabled status was defaulted to disabled until the UserNotifications.framework returned the user's push authorization status. If the user closed the app within a few seconds, the SDK would not flush the updated push status and the user would mistakenly be marked as "push disabled".
   - This issue only affected apps using UserNotifications.framework to register for push notifications.
   - The updated code stores the push authorization status on disk to fix the issue.
 - Fixes an issue where triggered in-app messages with event property templating did not respect re-eligibility settings.

##### Changed
 - Updates the Podspecs for iOS and tvOS SDK.
 - Updates deprecation warnings to specify iOS version.
 - Updates the ABKFeedController with more generic nullability.
 - Disables all data detectors on HTML in-app messages. Phone numbers, web URLs, addresses and calendar events will no longer be automatically converted.
 - Disables scrolling bounces on HTML in-app messages.

## 2.24.2

##### Fixed
 - Fixes an issue where HTML in-app messages loaded JavaScript more than once.
 - Fixes the Appboy.inAppMessage.webview.done-button.title string in the French localization file, which was named incorrectly and wasn't being found.

## 2.24.1

##### Added
 - Adds nullability annotation for the completionHandler in `userNotificationCenter :didReceiveNotificationResponse:withCompletionHandler`.

## 2.24.0

##### Breaking
 - Updates the SDK to require XCode 8.
 - iOS 10 changes behavior of `application:didReceiveRemoteNotification:fetchCompletionHandler` and subsequently breaks open tracking and deep link handling on most existing Braze iOS integrations. If you don't currently implement `application:didReceiveRemoteNotification:` you need to modify your integration, and we recommend that all users update.

##### Added
 - Updates the iOS and tvOS SDKs to support iOS 10.
 - Adds a new method `- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler`. This method supports the new delegate method for push notification handling in `UserNotification` framework.

##### Changed
 - Deprecates two push delegate methods:
  `- (void)registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification` and
  `- (void)getActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(nullable void (^)())completionHandler`.

## 2.23.0

##### Added
 - Adds support for upgraded in-app messages including image-only messages, improved image sizing/cropping, text scrolling, text alignment, configurable orientation, and configurable frame color.
 - Adds support for in-app messages triggered on custom event properties, purchase properties, and in-app message clicks.
 - Adds support for templating event properties within in-app messages.

##### Removed
 - Removes the deprecated method `logSocialShare` from `Appboy` class.

## 2.22.1

##### Changed
 - Updates tvOS bitcode support, patching an error introduced by an Xcode bug.

## 2.22.0

##### Added
 - Adds tvOS support for logging analytics; adds sample applications for tvOS and TVML.
 - Adds Hebrew localization support.

## 2.21.0

##### Breaking
 - Drops support for iOS 6.

##### Added
 - Adds support for deep links with non-URL-encoded characters. The SDK will encode unencoded url strings to create valid deep link NSURLs.

##### Fixed
 - Fixes a bug where the background of a slideup in-app message remained transparent when configured with 100% opacity.

##### Changed
 - Updates the podspec SDWebImage dependency to fetch the latest version.
 - Replaces SDK usage of NSURLConnection with NSURLSession.
 - Updates the SDK to always call `canOpenURL:` before opening a deep link. After this change, the SDK will only direct deep links whose schemes are whitelisted.
 - Updates push registration to immediately, asynchronously send up the push token.

## 2.20.1

##### Fixed
 - Fixes an issue where in certain conditions NSUserDefault blocking would cause custom events logged in the main thread to result in UI freezing.

##### Changed
 - Implements an optimization in push handling to not prefetch the News Feed when a push arrives and the app is in the background.

## 2.20.0

##### Added
 - Adds Carthage support.

##### Fixed
 - Fixes a multithreading issue where logging custom events from different threads would sporadically cause errors.
 - Fixes the issue where a close button's color on modal and full in-app messages didn't respect the opacity value.
 - Fixes an issue where failure to download HTML in-app message assets mid-download resulted in display without assets.

##### Changed
 - Now the `onInAppMessageHTMLButtonClicked:clickedURL:buttonID:` delegate method will be called every time a URL is clicked. The method used to be only called when there was a button ID in the URL link.
 - Updates the feedback element to reject messages that contain only whitespace.
 - Updates remote push handling to call the completion handler passed in every time (a code path previously existed that would return without calling it).

##### Removed
 - Removes the delegate method `onInAppMessageHTMLButtonClicked:buttonID:` from `ABKInAppMessageControllerDelegate` protocol.

## 2.19.3

##### Added
 - Adds a new feature allowing manual control of deep link handling in push notications. To use this, add a `ABKPushURIDelegate` value for the `ABKPushURIDelegate` key in the `appboyOptions` dictionary of `startWithApiKey:inApplication:inApplication:withAppboyOptions:`. Also updates the `ABKPushURIDelegate` integration to be initialized through that integration point.
 - Adds guarding against a possible crash caused by a user's offline state being corrupted and not including an active session when a network request
occurred.

##### Fixed
 - Fixes an issue where duplicate data could be recorded when a force quit or crash occurs after a network request completed successfully, but before any other activity (such as leaving the app, putting it to sleep, updating an attribute or firing some other event or purchase) occurred.

## 2.19.2

##### Added
 - Adds warning when messaging doesn't succeed because SDWebImage is not integrated.

##### Fixed
 - Fixes a bug where users who went from being eligible for triggered messages to not being eligible for any triggered messages didn't see their local triggers configuration get updated.  This has already been fixed with a server-side update for affected versions; this update fixes the issue client-side.

##### Changed
 - Updates headers to be compatible with Swift 2.2.


## 2.19.1

##### Added
 - Adds sample code for a universal link in Stopwatch.

##### Fixed
 - Fixes the benign issue that caused the log message `*** -[NSKeyedUnarchiver initForReadingWithData:]: data is NULL`.
 - Fixes an issue where NULL campaign IDs in push messages (e.g. from a REST API push message without a specified campaign id) resulted in push-clicked triggers for triggered in-app messages not firing.
 - Fixes an issue where calling `changeUser` between identified users caused the read/unread state of the news feed cards of the old user to be set as the new user's read/unread states.
 - Fixes an issue where a user attribute value that had been set to multiple different values created a state that would not let you set the original value again. The bug was introduced in version 2.17.1.

##### Changed
 - Analytics are now logged for in-app messages and in-app message buttons with 'ABKInAppMessageNoneClickAction' click actions.  `ABKInAppMessageNoneClickAction` is set when an in-app message on the dashboard has a click action that only closes the in-app message; formerly this did not count as a click.

## 2.19.0

##### Added
 - Adds support for action-based, locally triggered in-app messages. In-app messages are now sent to the device at session start with associated trigger events. The SDK will display in-app messages in near real-time when the trigger event associated with a message occurs. Trigger events can be app opens, push opens, purchases, and custom events.

##### Changed
 - Deprecates the old system of requesting in-app message display, now collectively known as 'original' in-app messaging, where messages were limited to displaying at app start.  

## 2.18.4

##### Fixed
 - Fixes a Cocoapods issue that emerged during the release of 2.8.13.

## 2.18.3

##### Changed
 - Makes an internal update to provide functionality for SDKs that embed this library.

## 2.18.2

##### Added
 - Adds warning logging if `[Appboy sharedInstance]` is called while in an uninitialized state.

##### Changed
 - Deprecates the delegate method `getResourceEndpoint:` in ABKAppboyEndpointDelegate. The SDK will no longer call this delegate method.

## 2.18.1

##### Fixed
 - Fixes the nullability annotation warnings in the public header files.

##### Changed
 - Updates HelloSwift sample app to adopt swift 2.0.

## 2.18

##### Added
 - Adds nullability annotations to all Braze public APIs.
 - Adds a new delegate method to support custom push URI handle. For more detail, please see [ABKPushURIDelegate.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/headers/AppboyKitLibrary/ABKPushURIDelegate.h);

##### Changed
 - Updates to auto-dismiss the Braze web view when a user returns to the app after following a link out of the app from an Braze web view.

##### Removed
 - Removes the deprecated method `requestSlideupRefresh` from Braze class.

## 2.17.1

##### Fixed
 - Fixes a bug where in certain conditions the SDK would resend user attributes that had already synced with the server.

## 2.17

##### Added
 - Adds a new button clicked delegate method for HTML in-app message. The new delegate method also passes the URL of the clicked button.

##### Fixed
 - Fixes the crash caused by inserting a nil object into an NSDictionary when parsing an event object.

##### Changed
 - Makes the WebView background for HTML in-app messages transparent.  Ensure HTML in-app messages you send to the device are created expecting a transparent background.
 - Applies the Braze endpoint delegate methods to in-app messages' resource(zip and image) fetching.

##### Removed
 - Removes the Facebook button from Feedback page.

## 2.16.1

##### Added
 - Adds the ability to log a custom event from an HTML in-app message. To log a custom event from an HTML in-app message, navigate a user to a url of the form `appboy://customEvent?name=customEventName&p1=v2`, where the `name` URL parameter is the name of the event, and the remaining parameters are logged as String properties on the event.
 - Adds the support for customization of the background color of modal in-app messages.

##### Fixed
 - Fixes an issue where daylight savings changes were not reflected in the user profile timezone.

##### Changed
 - Enables users to input text into HTML in-app messages by allowing HTML in-app messages to be displayed with a keyboard on screen. For all other in-app messages, the in-app message will be dismissed when a keyboard is displayed.

## 2.16

##### Added
 - Adds HTML In-App Message types.
   - HTML In-App Messages consist of HTML and a url of a zipped archive of assets (e.g. images, css) to download locally which the HTML can reference. See [InAppMessageUIViewController](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/InAppMessageUIViewController.m#213) in our Stopwatch sample app for an example for the callbacks on the actions inside the WebView hosting the HTML In-App Message.

##### Changed
 - Deprecates the method `- (void) logSocialShare:(ABKSocialNetwork)socialNetwork` and enum `ABKSocialNetwork` in the `Appboy` class. If you use `logSocialShare:` to track user's social account sharing, you can use `logCustomEvent:` instead.
 - Deprecates the property `bio` in the `ABKUser` class.

## 2.15.1

##### Fixed
 - Fixes the warning "full bitcode bundle could not be generated because XXX was built only with bitcode marker".

## 2.15

##### Changed
 - Updates the SDK to support iOS 9.  In iOS9, previous versions of the SDK:  1) did not have bitcode support, 2) had a minor UI issue in in-app messages where the slideup messages were not docked on the bottom of the screen if they had one line of text, 3) failed to localize for zh-HK and zh-TW.

## 2.14

##### Breaking
 - Migrates the SDK to ARC.  If you are using our Apple Watch Extension and not using ARC, you must apply -fobjc-arc to the extension files.

##### Added
 - Adds configurable session timeout feature.
 - Adds feedbackViewControllerBeforeFeedbackSent method to the feedback delegate protocols, which can be used to modify the feedback message before it's sent to Braze.
 - Adds a `setAttributionData` method to `ABKUser` that sets an `ABKAttributionData` object for the user.  To be used with attribution provider SDKs when attribution events are fired.

## 2.13.2

##### Changed
 - Increases the number of supported currency codes from 22 to 171. All common currency codes are now supported. The full list of supported codes is available at `Appboy.h`.

## 2.13.1

##### Changed
 - Updates the `isUninstallTrackingNotification` method in `ABKPushUtils` to return the correct value.

## 2.13

##### Added
 - Adds an open-source Watch SDK to support data analytics on watchKit apps. You can use the Appboy-WatchKit SDK by downloading and adding the "Appboy-WatchKit" folder in your watchKit extension target. For more detail, please refer to [ABWKUser.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/Appboy-WatchKit/ABWKUser.h) and [AppboyWatchKit.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/Appboy-WatchKit/AppboyWatchKit.h).
 - Adds an opt-in location service that logs background location events; adds ABKLocationManager with methods for allowing Braze to request location permission on your behalf and logging the current location.  More information on the background location capabilities will be made available when dashboard support is released.
 - Adds client side blocking of blacklisted attributes and events.
 - Adds ABKPushUtils with method `+ (BOOL) isUninstallTrackingNotification:(NSDictionary *)userInfo;` that can be used to detect if a content-available push is from Braze uninstall tracking (and shouldn't be acted upon).
 - Adds a new property `expiresAt` in class ABKCard. The property is the unix timestamp of the card's expiration time. For more detail, please refer to ABKCard.h.

##### Changed
 - Stops collecting user's Twitter data automatically. You can pass a user's Twitter information to Braze by initialzing a ABKTwitterUser object with the twitter data, and setting it to [Appboy sharedInstance].user.twitterUser. For more information, please refer to ABKUser.h and ABKTwitterUser.h.
 - Stops logging foreground push as a push open as it is not delivered by the system.

##### Removed
 - Removes the feature of prompting a user to connect his/her social account. You can refer to the method `promptUserToConnectTwitterAccountOnDeviceAndFetchAccountData` in [TwitterViewController.m](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/TwitterViewController.m) to continue prompting the user to connect the Twitter account.

## 2.12.2

##### Fixed
 - Fixes the slideup in-app message display issue. When the host app sets the launch screen file, slideup in-app message from bottom sometimes didn't dock at the bottom of the screen on iPhone 6 and iPhone 6 Plus.

## 2.12.1

##### Added
 - Adds font and font size customization to all in-app message's header and message text through NUI. You can customize in-app message's font by adding `ABKInAppMessageSlideupMessageLabel`, `ABKInAppMessageeModalHeaderLabel`,`ABKInAppMessageModalMessageLabel`, `ABKInAppMessageFullHeaderLabel`, `ABKInAppMessageFullMessageLabel` to your NUI nss style sheet.

##### Fixed
 - Fixes news feed issue where no news feed cards resulted in the loading spinner remaining on screen.

##### Changed
 - Cleans up the console logging in Class ABKIdentifierForAdvertisingProvider.

## 2.12.0

##### Fixed
 - Fixes the incorrect path runtime error for users who integrate our pod as a dynamic framework. For SDK versions before 2.12, when you integrate Braze with `use_frameworks!` in the Podfile, the library is integrated as a dynamic framework and the Appboy.bundle is stored in a different path.

##### Changed
 - Changes HelloSwift sample app to integrate Braze SDK as a dynamic framework.

##### Removed
 - Removes the subspecs from the podspec. This fixes the duplicate symbol error https://github.com/Appboy/appboy-ios-sdk/issues/24. If you are still using subspec like `pod 'Appboy-iOS-SDK/AppboyKit'` in your podfile, please make sure to change it to `pod 'Appboy-iOS-SDK'`.

## 2.11.3

##### Added
 - Adds the ability to send and retrieve extra key-value pairs via a News Feed card.
 - Adds the ability to define custom key-value properties on a custom event or purchase. Property keys are strings and values may be NSString, NSDate, or NSNumber objects.
 - Added the fix for an edge case when there are extra UIWindows at the time in-app message is going to display, the in-app message would have issue during dismissing.

## 2.11.2

##### Changed
 - Updates the serialize and deserialize methods for in-app message classes. This is for use by wrappers such as Braze's Unity SDK for iOS.

## 2.11.1

##### Fixed
 - Fixes a UI issue in modal in-app messages displayed on iPads running iOS 6/7.

## 2.11

##### Added
 - Adds support for modal and full screen style in-app messages. Also adds support for including fontawesome icons and images with in-app messages, changing colors on in-app message UI elements, expanded customization options, and message resizing for tablets. Please visit our documentation for more information.

##### Changed
 - Updates the completionHandler signature in getActionWithIdentifier:forRemoteNotification:completionHandler: to match the comletionHandler passed by the system in method `- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler`.

## 2.10.2

##### Added
 - Adds the fix for an edge case when there are extra UIWindows at the time in-app message is going to display, the in-app message would have issue during dismissing.

## 2.10.1

##### Fixed
 - Fixes a bug which would cause the host app to crash when a deep link was launched from a push notification. In versions 2.10.0 and 2.9.4, if the host app used `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification:];` instead of `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification: fetchCompletionHandler:];`, opening a push with a deep link would crash the host app in some circumstances.

## 2.10.0

##### Changed
 - Updates the minimum deployment targets of Braze iOS SDK to iOS 6.0.  For apps supporting lower iOS versions, please continue to use 2.9.+ versions of the Braze SDK.
 - Stops collecting user's Facebook data automatically. You can pass a user's Facebook information to Braze by initializing a ABKFacebookUser object with the facebook data, and set it to [Appboy sharedInstance].user.facebookUser. For more information, please refer to ABKUser.h and ABKFacebookUser.h.

##### Removed
 - Removes Facebook SDK dependent builds.  Now there is a single library - AppboyKit - and a single Pod without functional subspecs - Appboy-iOS-SDK (note we now have both the subspecs pointing at the same library). Please update your Podfile to `pod 'Appboy-iOS-SDK` if you are integrating Braze with Cocoapods.
 - Removes the feature of prompting a user to connect his/her Facebook account. You can refer to the method `promptUserToConnectFacebookAccountOnDeviceAndFetchAccountData` in [FacebookViewController.m](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/FacebookViewController.m) to continue prompting the user to connect the Facebook account.

## 2.9.6

##### Added
 - Adds the fix for an edge case when there are extra UIWindows at the time in-app message is going to display, the in-app message would have issue during dismissing.

## 2.9.5

##### Fixed
 - Fixes a bug which would cause the host app to crash when a deep link was launched from a push notification. In versions 2.9.4, if the host app used `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification:];` instead of `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification: fetchCompletionHandler:];`, opening a push with a deep link would crash the host app in some circumstances.

## 2.9.4

##### Added
 - Adds a major performance upgrade that reduces CPU usage, memory footprint, and network traffic.
 - Adds 26 additional languages to localization support for Braze UI elements.
 - Adds support for deep linking from APNS push notification clicks.
 - Adds ability to customize the font of Feedback text using NUI with NUI class name `ABKFeedbackTextView`.

##### Fixed
 - Fixes the feedback page UI issues in iOS 8: when the device's orientation is UIInterfaceOrientationPortraitUpsideDown, the contact info bar was off.
 - Fixes in-app messages to display correctly in landscape mode in iOS 8.

##### Changed
 - Updates the SDK to adopt the latest SDWebImage protocol methods.

##### Removed
 - Removes the "required" labels on the feedback page.

## 2.9.3

##### Added
 - Adds a new method `- (void) registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler` to support push with background fetch. This method should be called in `- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler`. For more details, please refer to [Appboy.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/Appboy.h).
 - Adds a HelloSwift sample app to demo how to use Braze in a swift app.
 - Adds a new NSString property "displayPrice" in ABKCrossPromotionCard to enable server side price localization.

##### Fixed
 - Fixes a bug of when sessions were being created when the app opened in the background.
 - Fixes a bug where requesting the news feed with a news feed open led to card impressions not updating until the next feed refresh.

## 2.9.2

##### Added
 - Adds the ability to turn off Braze's automatic location collection by setting the ABKDisableAutomaticLocationCollectionKey boolean in AppboyOptions in startWithApiKey:inApplication:inApplication:withAppboyOptions:.
 - Adds the ability to send location tracking events to Braze manually using setLastKnownLocationWithLatitude:longitude:horizontalAccuracy: and setLastKnownLocationWithLatitude:longitude:horizontalAccuracy:altitude:verticalAccuracy: on the ABKUser. this is intended to be used with ABKDisableAutomaticLocationCollectionKey set to true in the AppboyOptions so that locations are only being recorded from a single source.

##### Fixed
 - Fixes a news feed bug: sometimes the spinner keeps spinning on the screen even after the news feed card image is displayed.

##### Changed
 - Updates sample app core location fetching code based on the changes in iOS 8.

## 2.9.1

##### Fixed
 - Fixes a news feed bug: When a user refreshed the news feed by swiping down, if the total number of cards in the feed was going to be reduced by the refresh, the app would crash.

## 2.9.0

##### Fixed
 - Fixes an App Store validation error introduced when the App Store started accepting submissions for iOS8. This was done by changing the packaging of the Braze framework to include a universal binary and a resource bundle (instead of combining them both together in a universal framework). Due to this change, Cocoapod integration is even more highly recommended than before to fully automate integration.

## 2.8.1

##### Added
 - Adds a new method `- (void) getActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo` to collect analytics data for push actions in iOS 8. It should be called in the UIApplication delegate method `- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler`. For more details, please refer to [Appboy.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/Appboy.h).
 - New Custom Attribute Data Type (Array): Braze now supports custom attributes which contain an array of string elements. In addition, we also provide methods for adding or removing an string element from an array type custom attribute. For more information, please refer to [ABKUser.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKUser.h).
 - Users can now pull down on the Braze Newsfeed to refresh the content on iOS version 6.0 or later.

##### Changed
 - Restricts product identifier string to 255 characters for method `- (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price` and `- (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity`.
 - News feed card now can update the card height and display a full image based on the image ratio. Card image ratio used to be a fix number and images were aspect stretched to fit in the views.
 - The right and left margins in the news feed are now touchable areas for scrolling.
 - Card titles have been improved and will now truncate with "..." when they are more than 2 lines.

## 2.8

##### Breaking
 - Renames the class names of news feed cards to match the names on dashboard:

 | v2.8                    | v2.7 |
 | ------------------------| ---------------------------|
 | ABKBannerCard           | ABKCardBanner              |
 | ABKCaptionedImageCard   | ABKCardCaptionedMessage    |
 | ABKCrossPromotionCard   | ABKCardCrossPromotionSmall |
 | ABKClassicCard          | ABKCardNews                |
 | ABKTextAnnouncementCard | ABKCardTextAnnouncement    |

##### Added
 - Adds email and push notification subscription types for a user. Subscription types are explicitly opted in, subscribed, and unsubscribed. The previous email boolean subscribe method has been deprecated.
 - Adds custom slideup orientation support. You can now ask the slideup to only support certain orientations. For more details on slideup custom orientation support, please refer to [ABKSlideupController.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupController.h).
 - Adds quantity parameter as an option when logging purchase. The quanlity should be an unsigned interger greater than 0 and no larger than 100. For more information, please refer to [Appboy.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/Appboy.h).
 - Adds a class method in ABKCard to deserialize a given dictionary to a card. This is for use by wrappers such as Braze's Unity SDK for iOS. Please refer to [ABKCard.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupController.h) for more information.

## 2.7

### News Feed Update
- Exposes raw card data in ABKFeedController
  - Developers can use the raw card data to creat custom user interfaces for the news feed. For more details on the card data, please refer to ABKFeedController.h.
- Addes support for categories on cards and news feed view controllers.
  - Categories include Announcement, Advertising, Social, News and No Category. You can get cards of certain categories from ABKFeedController, or you can make ABKFeedViewController only display certain categories of cards.
- Uses SDWebImage to handle images downloading and caching in the news feed, display a spinner while downloading images and show a default image when no image available.
  - Adds support for asynchronous image downloading in the news feed, asynchronous memory and disk image caching with automatic cache expiration handling.
- Adds news feed view controller delegate to support custom handling of card clicks on news feed.
  - The app can customize click actions from the feed and display any card link in their own user interface.

### Slideup Changes
- Updates ABKSlideupControllerDelegate method onSlideupClicked to return a BOOL value to indicate if Braze should continue to execute the click action.
- Stops logging slideup click when the slideup click action is ABKSlideupNoneClickAction.

### Feedback Changes
- Updates the ABKFeedbackViewControllerPopoverContext so now it should be used in all cases where the feedback page displayed in a popover, including the case that the feedback is push on a navigation controller in a popover.
- Fixes the ABKFeedbackVIewControllerModalContext cancel button delegate issue.
- Fixes the form sheet style ABKFeedbackViewControllerModalContext layout issue.

### Other Changes
- Adds API to request feed and slideup refresh.
- Adds API to log news feed displayed and feedback displayed.
  - Allows updating analytics data even using customized news feed or feedback user interfaces.
- Updates badge count policy to only update when app is foreground.
- Adds clearTwitterDataWhenNoDataOfTwitterIdentifier to ABKUser, allowing developer to clear user data when a user disconnectes their twitter accounts.
- Updates custom key and string value for custom attributes to automatically trim.

## 2.6.3

##### Changed
 - Updates the SDK to authenticate with the Twitter API using SSL.

## 2.6.2

##### Fixed
 - Fixes a news feed card click tracking issue.

##### Changed
 - Updates data flush time interval.

## 2.6.1

##### Fixed
 - Fixes a minor display problem that affected news items with no image or link for version 2.6.

## 2.6

##### Breaking
 - Braze iOS SDK now supports 64 bit as well. The minimum deployment targets that Braze iOS SDK supports is iOS 5.1.1.
   - The Braze iOS SDK will now allow function with 64-bit apps. This version of the SDK only supports iOS 5.1.1+. Legacy iOS apps should continue to use version 2.5 of the SDK.
   - You can install legacy versions of our SDK via [CocoaPods](http://guides.cocoapods.org/) by following changing the [podfile](http://guides.cocoapods.org/syntax/podfile.html) to include something like the following example `pod 'Appboy-iOS-SDK/AppboyKit', '~> 2.5'`.

## 2.5.1

##### Fixed
 - Fixes a minor display problem that affected news items with no image or link for version 2.5.

## 2.5
### Localization

Localization is now supported in version 2.5 of the Braze SDK. We have provided `.string` files for English, Simplified Chinese and Traditional Chinese. You can also optionally override our Braze's default `LocalizedAppboyUIString.strings` right within your app's `Localizable.Strings` file in much the same way you would do an override in CSS. To do so, copy the key and string pair into your `Localizable.Strings` file and edit the string as you so desire.

For your convenience our CocoaPod integrates the `LocalizedAppboyUIString.strings` files for the three aforementioned languages. If you do not wish to use one or more of these languages, you can feel free to delete these files from your project.

###  Slideup Upgrade

Braze version 2.5 provides a substantial upgrade to the slideup code and reorganization for better flexibility moving forward, but at the expense of a number of breaking changes. We've detailed the changes in this changelog and hope that you'll love the added power, increased flexibility, and improved UI that the new Braze slideup provides. If you have any trouble with these changes, feel free to reach out to success@braze.com for help, but most migrations to the new code structure should be relatively painless.

#### New Slideup Controller
- The property `slideupController` has been added to the Braze object. Please see [ABKSlideupController.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupController.h) for details.
  - The `delegate` property allows you to specify a delegate for the slideup.
    - This replaces `slideupDelegate` which has been removed.
  - The `displayNextSlideupWithDelegate:` method displays the next available slideup with the specified delegate.
    - This replaces `provideSlideupToDelegate:` which has been removed from Braze.
  - The `slideupsRemainingOnStack` method returns the number of slideups that are waiting locally to be displayed.
  - The `addSlideup:` method allows you to display a slideup object with custom content. This is useful in testing or if you want to use the Braze slideup's UI/UX with another notification system that you are using.
    - Clicks and impressions of slideups added by this method will not be collected by Braze.
  - `hideCurrentSlideup:` method will remove any slideup currently on screen, with or without animation.

#### New Slideup Properties and Methods in `ABKSlideup.h`
The following properties and methods all belong to the `ABKSlideup` object. Please see [`ABKSlideup.h`](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideup.h) for more information.

##### New Properties

- The `extras` property carries additional data within key value pairs that have been defined on the dashboard, just like a push notification. Braze does nothing with the extras property, any additional behavior is at your discretion.
- The `slideupAnchor` property defines whether the slideup originates from the top or the bottom of the screen.
- The `slideupDismissType` property controls whether the slideup will dismiss automatically after a period of time has lapsed, or if it will wait for interaction with the user before disappearing.
  - The slideup will be dismissed automatically after the number of seconds defined by the newly added `duration` property if the slideup's `slideupDismissType` is `ABKSlideupDismissAutomatically`.
- The `slideupClickActionType` property defines the action behavior after the slideup is clicked: displaying a news feed, redirect to a uri, or nothing but dismissing the slideup. This property is read only. If you want to change the slideup's click behavior, you can call one of the following method: `setSlideupClickActionToNewsFeed`, `setSlideupClickActionToUri:` or `setSlideupClickActionToNone`.
- The `uri` property defines the uri string that the slide up will open when the slideupClickActionType is ABKSlideupRedirectToURI. This is a read only property, you can call `setSlideupClickActionToUri:` to change it's value.

##### New Methods
- `logSlideupImpression` and `logSlideupClicked` have been added to allow you to report user interactions with the slideup in the case that you've fully customized the slideup experience and Braze is not handling the interactions.
- `setSlideupClickActionToNewsFeed`, `setSlideupClickActionToUri:` and `setSlideupClickActionToNone` have been added to allow you to change the slideup's click action behavior. `setSlideupClickActionToUri:` accepts a uri string as parameter and required the given uri string is valid.

#### Delegate Method Changes

All former Braze slideup delegate methods have been depreciated and removed. In their place Braze has added new slideup delegate methods within [`ABKSlideupControllerDelegate.h`](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupControllerDelegate.h).

- `onSlideupReceived:` is called when slideup objects are received from the Braze server.
- `beforeSlideupDisplayed:withKeyboardIsUp:` is called before slideup objects are displayed, the return value determines whether the slideup will be displayed, queued or discarded.
- `slideupViewControllerWithSlideup:` This delegate method allows you to specify custom view controllers in which your slideups will be displayed.
  - The custom view controller should be a subclass of `ABKSlideupViewController`.
    - Alternatively, it can also be an instance of `ABKSlideupViewController`.
  - The view of the returned view controller should be an instance of `ABKSlideupView` or its subclass.
  - For integration examples of a custom slideup view controller, see the `CustomSlideupViewController` class in Braze's sample app Stopwatch.
- `onSlideupClicked:` is called when a user clicks on a slideup. We recommend that you specify behavior on click via the dashboard, but you can additionally specify behavior on click by defining this delegate method.
- `onSlideupDismissed:` is called whenever the slideup is dismissed regardless of whether the dismissal occurs automatically or via swipe. This method is not called if the user clicks on the slideup. If the user clicks or taps on the slideup, `onSlideupClicked` is called instead.

#### New Options on the Dashboard
- Slideup behavior on click can now be set within the dashboard to open a modal news feed, open a URI within a modal, or do nothing.
- The following properties can be set remotely from the Braze Dashboard:
  - `extras`
  - `slideupAnchor`
  - `slideupDismissType`
  - `slideupClickActionType`
  - `uri`

### News Feed Changes
- News feed items are now cached in offline storage, allowing the news feed to render even when no internet connectivity is available. Braze will still automatically try to pull down a new news feed when a session opens, even if an offline feed is available.
- Each card now has a maximum height of no more than 2009 points to avoid any performance issues as recommended by iOS developer guidelines.
- The entirety of captioned image cards are now clickable. Formerly, only the link itself was clickable.
- When the news feed is brought to the foreground, it will now automatically check for new content if the cached version of the feed was received more than 60 seconds ago.
— The width of news feed cards as well as the minimum margin between any card and the left & right edges of the view controller can now be customized. These values can be set separately for both iPad and iPhone. This allows for a larger news feed to render on larger screen sizes. All card images will scale proportionally. Please see `ABKFeedViewControllerContext.h` and `ABKFeedViewController.h` for more information.

### Other Changes
- Various internal and news feed display optimizations.

## 2.4
* IDFA Collection is now optional.
  * By default, IDFA collection is now disabled by the Braze SDK.
    * There will be no loss of continuity on user profiles or loss of functionality whatsoever as a result of this change.
    * If you’re using advertising elsewhere in the app or through our in-app news feed, we recommend continuing to collect the IDFA through Braze. You should be able to do so safely without fear of rejection from the iOS App Store.
    * The future availability of IDFAs will enable functionality like integrating with other third-party systems, including your own servers, and enabling re-targeting of existing users outside of Braze. If you continue to record them we will store IDFAs free of charge so you can take advantage of these options immediately when they are released without additional development work.
  * Necessary Project Changes
    * ABKIdentifierForAdvertisingProvider.m and ABKIdentifierForAdvertisingProvider.h must be added to your project regardless of whether or not you enable collection. This occurs automatically if you integrate/update via the CocoaPod.
  * Enabling Braze IDFA Collection
    * IDFA collection can be enabled via adding the following PreProcessor Macro to the Build Settings of your app:
      * `ABK_ENABLE_IDFA_COLLECTION`

## 2.3.1
* The Braze SDK for iOS now has two versions, one for use with apps which incorporate the official Facebook SDK and one for those which do not. In November of 2013, the App Store Validation Process started generating warnings about the usage of isOpen and setActiveSession in the Braze SDK. These selectors were being sent to instances of classes in the Facebook SDK and are generally able to be used without generating warnings. However because of the way that the classes were initialized in Braze (a result of building a single Braze binary to fully support apps with and without the Facebook SDK), the App Store Validation Process started generating warnings the Facebook SDK methods share a name with private selectors elsewhere in iOS. Although none of our customers have been denied App Store approval yet, to protect against potential validation policy changes by Apple, Braze now provides two versions of its SDK, neither of which generate warnings. Going forward, the appboy-ios-sdk repository will provide both versions of the SDK in the folders 'AppboySDK' (as before) and 'AppboySDKWithoutFacebookSupport'. The 'AppboySDKWithoutFacebookSupport' does not require the host app to include the Facebook SDK, but as a result does not include all of the Braze features for Facebook data fetching. More information is available here within the [Braze documentation](http://documentation.braze.com/sdk-integration-ios.html#ios-basic-sdk-integration).
* Fixed a bug that repeatedly updated the push token of some users unnecessarily.
* The "Reporting an Issue?" box within the UI layout of the Feedback Page has been moved to the left side of the label away from the "Send" button. This change was made to reduce the number of misclicks of the "Send" button. The "Reporting an Issue?" label is now clickable as well.
* Cross Promotion Cards for apps with long titles will now render appropriately in iOS5. Before the title would render abnormally large on these devices.
* Fixed a bug where view recycling would cause incorrect card images to appear for newly rendered cards (until the image for that card finished downloading). Card images for newly rendered cards will now remain empty until the correct image is downloaded.
* Internal changes to enable future support for a 64 bit library release.
* Improvements to the Braze Sample App.
* Internal code structure and performance improvements including the move of more offline caching to background tasks.

## 2.3
* BREAKING CHANGE: The ABKSlideupControllerDelegate interface has been changed to work with ABKSlideup objects instead of simply the slideup message. This provides you with more control over the click actions and display of slideups and is also being made in anticipation of the augmentation of the ABKSlideup object with more data properties in future releases. To access the message previously sent to shouldDisplaySlideup, simply access the message property on the provided ABKSlideup argument.
* displayNextAvailableSlideup has been deprecated and will be removed in the next minor release, it has been replaced by provideSlideupToDelegate, see Appboy.h documentation for more information.
* provideSlideupToDelegate has been added to Braze to allow for more fine grained control over slideup display.
* Fixes a bug where the slideupDelegate property getter on Braze would always return nil.
* Changes the slideupDelegate property on Braze to be retained, instead of assigned.

## 2.2.1
* Adds a startup option to appboyOptions to control the automatic capture of social network data. See the documentation on ABKSocialAccountAcquisitionPolicy in Appboy.h for more information.
* Changes a table cell's default background color to clear, from the white value that became default in iOS7.
* Adds support for developer to send up image_url for user avatars, allowing for custom images to be included in user profiles on the dashboard.

## 2.2
* Adds support for new banner and captioned image card types.
* Adds support for submitting feedback programmatically through an Appboy.h method without using Braze feedback form. This allows you to create your own feedback form.
* Fixes an issue where the the news feed's web view would display "Connection Error" when a user came back into the app after a card had directed him or her to a protocol URL. Now when users come back from a redirected protocol URL, the feed is properly displayed.
* Fixes an issue where the SDK might have incorrectly sent both read and write Facebook permissions at the same time, instead preferring to request only those read permissions that Braze is interested in and have already been requested by the incorporating app.
* Fixes a corner case where card impressions could be miscounted when the feed view controller is the master view controller of a split view.
* Makes cards truncate properly at two lines.

## 2.1.1
* URGENT BUGFIX: This fixes an issue which exists in all previous versions of the v2 SDK which is causing crashes on the just release iPhone 5c and iPhone 5s. All users of v2 are recommended to upgrade the Braze SDK to 2.1.1 immediately and re-submit to the app store.

## 2.1.0
* Adds support for iOS 7. You will need to use Xcode 5 to use this and future versions of the Braze iOS SDK.
* Updates internal usage of NUI. If you're using NUI, please ensure that you are at least using version 0.3.3 (the most up to date as of this writing is 0.3.4).
* Removes support for iOS 4.3.
* Optimizes news feed rendering for faster start up times and smoother scrolling of long feeds.
* Removes the deprecated - (void) logPurchase:(NSString *)productId priceInCents:(NSUInteger)price method in favor of the new multi-currency tracking method. Conversion of old method calls is straightforward. `[[Appboy sharedInstance] logPurchase:@"powerups" priceInCents:99];` should turn into `[[Appboy sharedInstance] logPurchase:@"powerups" inCurrency:@"USD" atPrice:[[[NSDecimalNumber alloc] initWithFloat:.99f] autorelease]];`
* Any references to the `delegate` property of ABKFeedbackViewControllerModalContext should be updated to the new property name `feedbackDelegate`.
* Following the removal of support for 4.3, removes SBJson parsing and uses built-in parsing added in iOS5 to improve performance and lower the SDK footprint.

## 2.0.4
* Adds support for reporting purchases in multiple currencies. Also, changes the price reporting object type to NSDecimalNumber for consistency with StoreKit.
* Adds additional space savings optimizations to image assets.
* Minor fix to orientation change handling in the example app code.

## 2.0.3
* Adds the ability to assign a Foursquare access token for each user. Doing so will cause the Braze backend to make Foursquare data available in user profiles on the dasbhard.
* Adds more fine grained control options for Braze's network activity. See Appboy.h for more information.

## 2.0.2
* Fixes a bug where Braze might reopen a Facebook read session when a publish session already exists

## 2.0.1
* UI Improvements
  * Fixed a bug when using the nav context feedback in a popover window that would cause the email bar to disappear
  * Updated news feed's close button when opened from a slide up
  * Added a loading spinner on the feedback page when fetching email address from Facebook
  * Fixed the bug where the modal context feed page's navigation bar would not adhere to NUI theming
  * Improved the look of the popover content feedback page
  * Enabled resizable webpages when clicking on to a web URL through a card
* API updates
  * Updated custom user attribute setting methods to return a boolean value indicating if the setting is successful
  * Added methods for incrementing custom user attributes
  * Added support for device push tokens as NSData when registering the token to Braze
  * More detailed error messages logged in console
  * Removed the enable/disable Braze methods from `Appboy.h`

## 2.0
* Initial release
