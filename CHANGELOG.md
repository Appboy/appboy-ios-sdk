## 2.24.2
- Fixes an issue where HTML in-app messages loaded JavaScript more than once.
- Fixes the Appboy.inAppMessage.webview.done-button.title string in the French localization file, which was named incorrectly and wasn't being found.

## 2.24.1
- Adds nullability annotation for the completionHandler in `userNotificationCenter :didReceiveNotificationResponse:withCompletionHandler`.

## 2.24.0
### BREAKING CHANGE - UPDATE REQUIRED
- Updates the SDK to requres XCode 8.
- iOS 10 changes behavior of `application:didReceiveRemoteNotification:fetchCompletionHandler` and subsequently breaks open tracking and deep link handling on most existing Appboy iOS integrations.  Please see our updated documentation [here](https://www.appboy.com/documentation/iOS/#step-4-update-application-code); if you don't currently implement `application:didReceiveRemoteNotification:` you need to modify your integration, and we recommend that all users update. 
- Updates the iOS and tvOS SDKs to support iOS 10.
- Adds a new method `- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler`. This method supports the new delegate method for push notification handling in `UserNotification` framework. 
- Deprecates two push delegate methods: 
  `- (void)registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification` and 
  `- (void)getActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(nullable void (^)())completionHandler`.

## 2.23.0
- Removes the deprecated method `logSocialShare` from Appboy class.
- Adds support for upgraded in-app messages including image-only messages, improved image sizing/cropping, text scrolling, text alignment, configurable orientation, and configurable frame color.
- Adds support for in-app messages triggered on custom event properties, purchase properties, and in-app message clicks.
- Adds support for templating event properties within in-app messages.

## 2.22.1
- Updates tvOS bitcode support, patching an error introduced by an Xcode bug.

## 2.22.0
- Adds tvOS support for logging analytics; adds sample applications for tvOS and TVML.
- Adds Hebrew localization support.

## 2.21.0
- Drops support for iOS 6.
- Updates the podspec SDWebImage dependency to fetch the latest version.
- Replaces SDK usage of NSURLConnection with NSURLSession.
- Adds support for deep links with non-URL-encoded characters. The SDK will encode unencoded url strings to create valid deep link NSURLs.
- Updates the SDK to always call `canOpenURL:` before opening a deep link. After this change, the SDK will only direct deep links whose schemes are whitelisted.
- Updates push registration to immediately, asynchronously send up the push token.
- Fixes a bug where the background of a slideup in-app message remained transparent when configured with 100% opacity.

## 2.20.1
- Implements an optimization in push handling to not prefetch the News Feed when a push arrives and the app is in the background.
- Fixes an issue where in certain conditions NSUserDefault blocking would cause custom events logged in the main thread to result in UI freezing.

## 2.20.0
- Removed the delegate method `onInAppMessageHTMLButtonClicked:buttonID:` from `ABKInAppMessageControllerDelegate` protocol.
- Adds Carthage support.
- Fixes a multithreading issue where logging custom events from different threads would sporadically cause errors.
- Now the `onInAppMessageHTMLButtonClicked:clickedURL:buttonID:` delegate method will be called every time a URL is clicked. The method used to be only called when there was a button ID in the URL link.
- Fixes the issue where a close button's color on modal and full in-app messages didn't respect the opacity value.
- Updates the feedback element to reject messages that contain only whitespace.
- Updates remote push handling to call the completion handler passed in every time (a code path previously existed that would return without calling it).
- Fixes an issue where failure to download HTML in-app message assets mid-download resulted in display without assets.

## 2.19.3
- Adds a new feature allowing manual control of deep link handling in push notications. To use this, add a `ABKPushURIDelegate` value for the `ABKPushURIDelegate` key in the `appboyOptions` dictionary of `startWithApiKey:inApplication:inApplication:withAppboyOptions:`. Also updates the `ABKPushURIDelegate` integration to be initialized through that integration point.
- Fixes an issue where duplicate data could be recorded when a force quit or crash occurs after a network request completed successfully, but before any other activity (such as leaving the app, putting it to sleep, updating an attribute or firing some other event or purchase) occurred.
- Adds guarding against a possible crash caused by a user's offline state being corrupted and not including an active session when a network request occurred.

## 2.19.2
- Fixes a bug where users who went from being eligible for triggered messages to not being eligible for any triggered messages didn't see their local triggers configuration get updated.  This has already been fixed with a server-side update for affected versions; this update fixes the issue client-side.
- Updates headers to be compatible with Swift 2.2.
- Adds warning when messaging doesn't succeed because SDWebImage is not integrated.

## 2.19.1
- Analytics are now logged for in-app messages and in-app message buttons with 'ABKInAppMessageNoneClickAction' click actions.  `ABKInAppMessageNoneClickAction` is set when an in-app message on the dashboard has a click action that only closes the in-app message; formerly this did not count as a click.
- Fixes the benign issue that caused the log message `*** -[NSKeyedUnarchiver initForReadingWithData:]: data is NULL`.
- Fixes an issue where NULL campaign IDs in push messages (e.g. from a REST API push message without a specified campaign id) resulted in push-clicked triggers for triggered in-app messages not firing.
- Fixes an issue where calling `changeUser` between identified users caused the read/unread state of the news feed cards of the old user to be set as the new user's read/unread states.
- Fixes an issue where a user attribute value that had been set to multiple different values created a state that would not let you set the original value again. The bug was introduced in version 2.17.1.
- Adds sample code for a universal link in Stopwatch.

## 2.19.0
- Adds support for action-based, locally triggered in-app messages. In-app messages are now sent to the device at session start with associated trigger events. The SDK will display in-app messages in near real-time when the trigger event associated with a message occurs. Trigger events can be app opens, push opens, purchases, and custom events.
- Deprecates the old system of requesting in-app message display, now collectively known as 'original' in-app messaging, where messages were limited to displaying at app start.  

## 2.18.4
- Fixes a Cocoapods issue that emerged during the release of 2.8.13.

## 2.18.3
- Makes an internal update to provide functionality for SDKs that embed this library.

## 2.18.2
- Deprecates the delegate method `getResourceEndpoint:` in ABKAppboyEndpointDelegate. The SDK will no longer call this delegate method.
- Adds warning logging if `[Appboy sharedInstance]` is called while in an uninitialized state.

## 2.18.1
- Fixes the nullability annotation warnings in the public header files.
- Updates HelloSwift sample app to adopt swift 2.0.

## 2.18
- Removes the deprecated method `requestSlideupRefresh` from Appboy class.
- Adds nullability annotations to all Appboy public APIs.
- Adds a new delegate method to support custom push URI handle. For more detail, please see [ABKPushURIDelegate.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/headers/AppboyKitLibrary/ABKPushURIDelegate.h);
- Updates to auto-dismiss the Appboy web view when a user returns to the app after following a link out of the app from an Appboy web view.

## 2.17.1
- Fixes a bug where in certain conditions the SDK would resend user attributes that had already synced with the server.

## 2.17
- Removes the Facebook button from Feedback page.
- Makes the WebView background for HTML in-app messages transparent.  Ensure HTML in-app messages you send to the device are created expecting a transparent background.
- Fixed the crash caused by inserting a nil object into an NSDictionary when parsing an event object.
- Adds a new button clicked delegate method for HTML in-app message. The new delegate method also passes the URL of the clicked button.
- Applies the Appboy endpoint delegate methods to in-app messages' resource(zip and image) fetching.

## 2.16.1
- Adds the ability to log a custom event from an HTML in-app message. To log a custom event from an HTML in-app message, navigate a user to a url of the form `appboy://customEvent?name=customEventName&p1=v2`, where the `name` URL parameter is the name of the event, and the remaining parameters are logged as String properties on the event.
- Enables users to input text into HTML in-app messages by allowing HTML in-app messages to be displayed with a keyboard on screen. For all other in-app messages, the in-app message will be dismissed when a keyboard is displayed.
- Fixes an issue where daylight savings changes were not reflected in the user profile timezone.
- Adds the support for customization of the background color of modal in-app messages.

## 2.16
- Deprecates the method `- (void) logSocialShare:(ABKSocialNetwork)socialNetwork` and enum `ABKSocialNetwork` in the `Appboy` class. If you use `logSocialShare:` to track user's social account sharing, you can use `logCustomEvent:` instead.
- Deprecates the property `bio` in the `ABKUser` class.
- Adds HTML In-App Message types. HTML In-App Messages consist of HTML and a url of a zipped archive of assets (e.g. images, css) to download locally which the HTML can reference. See [InAppMessageUIViewController](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/InAppMessageUIViewController.m#213) in our Stopwatch sample app for an example for the callbacks on the actions inside the WebView hosting the HTML In-App Message.

## 2.15.1
- Fixes the warning "full bitcode bundle could not be generated because XXX was built only with bitcode marker".

## 2.15
- Updates the SDK to support iOS 9.  In iOS9, previous versions of the SDK:  1) did not have bitcode support, 2) had a minor UI issue in in-app messages where the slideup messages were not docked on the bottom of the screen if they had one line of text, 3) failed to localize for zh-HK and zh-TW.

## 2.14
- Adds configurable session timeout feature.
- Adds feedbackViewControllerBeforeFeedbackSent method to the feedback delegate protocols, which can be used to modify the feedback message before it's sent to Appboy.
- Migrates the SDK to ARC.  If you are using our Apple Watch Extension and not using ARC, you must apply -fobjc-arc to the extension files.
- Adds a `setAttributionData` method to `ABKUser` that sets an `ABKAttributionData` object for the user.  To be used with attribution provider SDKs when attribution events are fired.

## 2.13.2
- Increases the number of supported currency codes from 22 to 171. All common currency codes are now supported. The full list of supported codes is available at `Appboy.h`.

## 2.13.1
- Updates the `isUninstallTrackingNotification` method in `ABKPushUtils` to return the correct value.

## 2.13
- Stops collecting user's Twitter data automatically. You can pass a user's Twitter information to Appboy by initialzing a ABKTwitterUser object with the twitter data, and setting it to [Appboy sharedInstance].user.twitterUser. For more information, please refer to ABKUser.h and ABKTwitterUser.h.
- Removes the feature of prompting a user to connect his/her social account. You can refer to the method `promptUserToConnectTwitterAccountOnDeviceAndFetchAccountData` in [TwitterViewController.m](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/TwitterViewController.m) to continue prompting the user to connect the Twitter account.
- Adds an open-source Watch SDK to support data analytics on watchKit apps. You can use the Appboy-WatchKit SDK by downloading and adding the "Appboy-WatchKit" folder in your watchKit extension target. For more detail, please refer to [ABWKUser.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/Appboy-WatchKit/ABWKUser.h) and [AppboyWatchKit.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/Appboy-WatchKit/AppboyWatchKit.h).
- Adds an opt-in location service that logs background location events; adds ABKLocationManager with methods for allowing Appboy to request location permission on your behalf and logging the current location.  More information on the background location capabilities will be made available when dashboard support is released.
- Adds client side blocking of blacklisted attributes and events.
- Adds ABKPushUtils with method `+ (BOOL) isUninstallTrackingNotification:(NSDictionary *)userInfo;` that can be used to detect if a content-available push is from Appboy uninstall tracking (and shouldn't be acted upon).
- Adds a new property `expiresAt` in class ABKCard. The property is the unix timestamp of the card's expiration time. For more detail, please refer to ABKCard.h.
- Stops logging foreground push as a push open as it is not delivered by the system.

## 2.12.2
- Fixes the slideup in-app message display issue. When the host app sets the launch screen file, slideup in-app message from bottom sometimes didn't dock at the bottom of the screen on iPhone 6 and iPhone 6 Plus.

## 2.12.1
- Fixes news feed issue where no news feed cards resulted in the loading spinner remaining on screen.
- Adds font and font size customization to all in-app message's header and message text through NUI. You can customize in-app message's font by adding `ABKInAppMessageSlideupMessageLabel`, `ABKInAppMessageeModalHeaderLabel`,`ABKInAppMessageModalMessageLabel`, `ABKInAppMessageFullHeaderLabel`, `ABKInAppMessageFullMessageLabel` to your NUI nss style sheet.
- Cleans up the console logging in Class ABKIdentifierForAdvertisingProvider.

## 2.12.0
- Removes the subspecs from the podspec. This fixes the duplicate symbol error https://github.com/Appboy/appboy-ios-sdk/issues/24. If you are still using subspec like `pod 'Appboy-iOS-SDK/AppboyKit'` in your podfile, please make sure to change it to `pod 'Appboy-iOS-SDK'`.
- Fixes the incorrect path runtime error for users who integrate our pod as a dynamic framework. For SDK versions before 2.12, when you intergrate Appboy with `use_frameworks!` in the Podfile, the library is integrated as a dynamic framework and the Appboy.bundle is stored in a different path.
- Changes HelloSwift sample app to integrate Appboy SDK as a dynamic framework.

## 2.11.3
- Adds the ability to send and retrieve extra key-value pairs via a News Feed card.
- Adds the ability to define custom key-value properties on a custom event or purchase. Property keys are strings and values may be NSString, NSDate, or NSNumber objects.
- Added the fix for an edge case when there are extra UIWindows at the time in-app message is going to display, the in-app message would have issue during dismissing.

## 2.11.2
- Update the serialize and deserialize methods for in-app message classes. This is for use by wrappers such as Appboy's Unity SDK for iOS.

## 2.11.1
- Fixes a UI issue in modal in-app messages displayed on iPads running iOS 6/7.

## 2.11
- Adds support for modal and full screen style in-app messages. Also adds support for including fontawesome icons and images with in-app messages, changing colors on in-app message UI elements, expanded customization options, and message resizing for tablets. Please visit our documentation for more information.
- Updates the completionHandler signature in getActionWithIdentifier:forRemoteNotification:completionHandler: to match the comletionHandler passed by the system in method `- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler`.

## 2.10.2
- Added the fix for an edge case when there are extra UIWindows at the time in-app message is going to display, the in-app message would have issue during dismissing.

## 2.10.1
- Corrected a bug which would cause the host app to crash when a deep link was launched from a push notification. In versions 2.10.0 and 2.9.4, if the host app used `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification:];` instead of `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification: fetchCompletionHandler:];`, opening a push with a deep link would crash the host app in some circumstances.

## 2.10.0
- Updated the minimum deployment targets of Appboy iOS SDK to iOS 6.0.  For apps supporting lower iOS versions, please continue to use 2.9.+ versions of the Appboy SDK.
- Stop collecting user's Facebook data automatically. You can pass a user's Facebook information to Appboy by initialzing a ABKFacebookUser object with the facebook data, and set it to [Appboy sharedInstance].user.facebookUser. For more information, please refer to ABKUser.h and ABKFacebookUser.h.
- Removed the feature of prompting a user to connect his/her Facebook account. You can refer to the method `promptUserToConnectFacebookAccountOnDeviceAndFetchAccountData` in [FacebookViewController.m](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/FacebookViewController.m) to continue prompting the user to connect the Facebook account.
- Removed Facebook SDK dependent builds.  Now there is a single library - AppboyKit - and a single Pod without functional subspecs - Appboy-iOS-SDK (note we now have both the subspecs pointing at the same library). Please update your Podfile to `pod 'Appboy-iOS-SDK` if you are integrating Appboy with Cocoapods.

## 2.9.6
- Added the fix for an edge case when there are extra UIWindows at the time in-app message is going to display, the in-app message would have issue during dismissing.

## 2.9.5
- Corrected a bug which would cause the host app to crash when a deep link was launched from a push notification. In versions 2.9.4, if the host app used `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification:];` instead of `[[Appboy sharedInstance] registerApplication: didReceiveRemoteNotification: fetchCompletionHandler:];`, opening a push with a deep link would crash the host app in some circumstances.

## 2.9.4
- Added a major performance upgrade that reduces CPU usage, memory footprint, and network traffic.
- Added 26 additional languages to localization support for Appboy UI elements.
- Added support for deep linking from APNS push notification clicks.
- Added ability to customize the font of Feedback text using NUI with NUI class name `ABKFeedbackTextView`.
- Fixed the feedback page UI issues in iOS 8: when the device's orientation is UIInterfaceOrientationPortraitUpsideDown, the contact info bar was off.
- Fixed in-app messages to display correctly in landscape mode in iOS 8.
- Updated the SDK to adopt the latest SDWebImage protocol methods.
- Removed the "required" labels on the feedback page.

## 2.9.3
 - Added a new method `- (void) registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler` to support push with background fetch. This method should be called in `- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler`. For more details, please refer to [Appboy.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/Appboy.h).
 - Fixed a bug of when sessions were being created when the app opened in the background.
 - Fixed a bug where requesting the news feed with a news feed open led to card impressions not updating until the next feed refresh.
 - Added a HelloSwift sample app to demo how to use Appboy in a swift app.
 - Added a new NSString property "displayPrice" in ABKCrossPromotionCard to enable server side price localization.

## 2.9.2
- Added the ability to turn off Appboy's automatic location collection by setting the ABKDisableAutomaticLocationCollectionKey boolean in AppboyOptions in startWithApiKey:inApplication:inApplication:withAppboyOptions:.
- Added the ability to send location tracking events to Appboy manually using setLastKnownLocationWithLatitude:longitude:horizontalAccuracy: and setLastKnownLocationWithLatitude:longitude:horizontalAccuracy:altitude:verticalAccuracy: on the ABKUser. this is intended to be used with ABKDisableAutomaticLocationCollectionKey set to true in the AppboyOptions so that locations are only being recorded from a single source.
- Updated sample app core location fetching code based on the changes in iOS 8.
- Fixed a news feed bug: sometimes the spinner keeps spinning on the screen even after the news feed card image is displayed.

## 2.9.1
- Fixes a news feed bug: When a user refreshed the news feed by swiping down, if the total number of cards in the feed was going to be reduced by the refresh, the app would crash.

## 2.9.0
- Fixes an App Store validation error introduced when the App Store started accepting submissions for iOS8. This was done by changing the packaging of the Appboy framework to include a universal binary and a resource bundle (instead of combining them both together in a universal framework). Due to this change, Cocoapod integration is even more highly recommended than before to fully automate integration.

## 2.8.1
- Restrict product identifier string to 255 characters for method `- (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price` and `- (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity`.
- News feed card now can update the card height and display a full image based on the image ratio. Card image ratio used to be a fix number and images were aspect stretched to fit in the views.
- Add a new method `- (void) getActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo` to collect analytics data for push actions in iOS 8. It should be called in the UIApplication delegate method `- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler`. For more details, please refer to [Appboy.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/Appboy.h).
- New Custom Attribute Data Type (Array): Appboy now supports custom attributes which contain an array of string elements. In addition, we also provide methods for adding or removing an string element from an array type custom attribute. For more information, please refer to [ABKUser.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKUser.h).
- Users can now pull down on the Appboy Newsfeed to refresh the content on iOS version 6.0 or later.
- The right and left margins in the news feed are now touchable areas for scrolling.
- Card titles have been improved and will now truncate with "..." when they are more than 2 lines.

## 2.8
- Renamed the class names of news feed cards to match the names on dashboard:

| v2.8                    | v2.7 |
| ------------------------| ---------------------------|
| ABKBannerCard           | ABKCardBanner              |
| ABKCaptionedImageCard   | ABKCardCaptionedMessage    |
| ABKCrossPromotionCard   | ABKCardCrossPromotionSmall |
| ABKClassicCard          | ABKCardNews                |
| ABKTextAnnouncementCard | ABKCardTextAnnouncement    |

- Added email and push notification subscription types for a user. Subscription types are explicitly opted in, subscribed, and unsubscribed. The previous email boolean subscribe method has been deprecated.
- Added custom slideup orientation support. You can now ask the slideup to only support certain orientations. For more details on slideup custom orientation support, please refer to [ABKSlideupController.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupController.h).
- Added quantity parameter as an option when logging purchase. The quanlity should be an unsigned interger greater than 0 and no larger than 100. For more information, please refer to [Appboy.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/Appboy.h).
- Added a class method in ABKCard to deserialize a given dictionary to a card. This is for use by wrappers such as Appboy's Unity SDK for iOS. Please refer to [ABKCard.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupController.h) for more information.

## 2.7
### News Feed Update
- Exposed raw card data in ABKFeedController
  - Developers can use the raw card data to creat custom user interfaces for the news feed. For more details on the card data, please refer to ABKFeedController.h.
- Added support for categories on cards and news feed view controllers.
  - Categories include Announcement, Advertising, Social, News and No Category. You can get cards of certain categories from ABKFeedController, or you can make ABKFeedViewController only display certain categories of cards.
- Used SDWebImage to handle images downloading and caching in the news feed, display a spinner while downloading images and show a default image when no image available.
  - Added support for asynchronous image downloading in the news feed, asynchronous memory and disk image caching with automatic cache expiration handling.
- Added news feed view controller delegate to support custom handling of card clicks on news feed.
  - The app can customize click actions from the feed and display any card link in their own user interface.

### Slideup Changes
- Updated ABKSlideupControllerDelegate method onSlideupClicked to return a BOOL value to indicate if Appboy should continue to execute the click action.
- Stopped logging slideup click when the slideup click action is ABKSlideupNoneClickAction.

### Feedback Changes
- Updated the ABKFeedbackViewControllerPopoverContext so now it should be used in all cases where the feedback page displayed in a popover, including the case that the feedback is push on a navigation controller in a popover.
- Fixed the ABKFeedbackVIewControllerModalContext cancel button delegate issue.
- Fixed the form sheet style ABKFeedbackViewControllerModalContext layout issue.

### Other Changes
- Added API to request feed and slideup refresh.
- Added API to log news feed displayed and feedback displayed.
  - Allows updating analytics data even using customized news feed or feedback user interfaces.
- Updated badge count policy to only update when app is foreground.
- Added clearTwitterDataWhenNoDataOfTwitterIdentifier to ABKUser, allowing developer to clear user data when a user disconnectes their twitter accounts.
- Updated custom key and string value for custom attributes to automatically trim.

## 2.6.3
- Updates the SDK to authenticate with the Twitter API using SSL.

## 2.6.2
- Fixes a news feed card click tracking issue.
- Update data flush time interval.

## 2.6.1
- Fixes a minor display problem that affected news items with no image or link for version 2.6.

## 2.6
Appboy iOS SDK now supports 64 bit as well. The minimum deployment targets that Appboy iOS SDK supports is iOS 5.1.1.

The Appboy iOS SDK will now allow function with 64-bit apps. This version of the SDK only supports iOS 5.1.1+. Legacy iOS apps should continue to use version 2.5 of the SDK.

You can install legacy versions of our SDK via [CocoaPods](http://guides.cocoapods.org/) by following changing the [podfile](http://guides.cocoapods.org/syntax/podfile.html) to include something like the following example `pod 'Appboy-iOS-SDK/AppboyKit', '~> 2.5'`.

## 2.5.1
- Fixes a minor display problem that affected news items with no image or link for version 2.5.

## 2.5
### Localization

Localization is now supported in version 2.5 of the Appboy SDK. We have provided `.string` files for English, Simplified Chinese and Traditional Chinese. You can also optionally override our Appboy's default `LocalizedAppboyUIString.strings` right within your app's `Localizable.Strings` file in much the same way you would do an override in CSS. To do so, copy the key and string pair into your `Localizable.Strings` file and edit the string as you so desire.

For your convenience our CocoaPod integrates the `LocalizedAppboyUIString.strings` files for the three aforementioned languages. If you do not wish to use one or more of these languages, you can feel free to delete these files from your project.

###  Slideup Upgrade

Appboy version 2.5 provides a substantial upgrade to the slideup code and reorganization for better flexibility moving forward, but at the expense of a number of breaking changes. We've detailed the changes in this changelog and hope that you'll love the added power, increased flexibility, and improved UI that the new Appboy slideup provides. If you have any trouble with these changes, feel free to reach out to success@appboy.com for help, but most migrations to the new code structure should be relatively painless.

#### New Slideup Controller
- The property `slideupController` has been added to the Appboy object. Please see [ABKSlideupController.h](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupController.h) for details.
  - The `delegate` property allows you to specify a delegate for the slideup.
    - This replaces `slideupDelegate` which has been removed.
  - The `displayNextSlideupWithDelegate:` method displays the next available slideup with the specified delegate.
    - This replaces `provideSlideupToDelegate:` which has been removed from Appboy.
  - The `slideupsRemainingOnStack` method returns the number of slideups that are waiting locally to be displayed.
  - The `addSlideup:` method allows you to display a slideup object with custom content. This is useful in testing or if you want to use the Appboy slideup's UI/UX with another notification system that you are using.
    - Clicks and impressions of slideups added by this method will not be collected by Appboy.
  - `hideCurrentSlideup:` method will remove any slideup currently on screen, with or without animation.

#### New Slideup Properties and Methods in `ABKSlideup.h`
The following properties and methods all belong to the `ABKSlideup` object. Please see [`ABKSlideup.h`](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideup.h) for more information.

##### New Properties

- The `extras` property carries additional data within key value pairs that have been defined on the dashboard, just like a push notification. Appboy does nothing with the extras property, any additional behavior is at your discretion.
- The `slideupAnchor` property defines whether the slideup originates from the top or the bottom of the screen.
- The `slideupDismissType` property controls whether the slideup will dismiss automatically after a period of time has lapsed, or if it will wait for interaction with the user before disappearing.
  - The slideup will be dismissed automatically after the number of seconds defined by the newly added `duration` property if the slideup's `slideupDismissType` is `ABKSlideupDismissAutomatically`.
- The `slideupClickActionType` property defines the action behavior after the slideup is clicked: displaying a news feed, redirect to a uri, or nothing but dismissing the slideup. This property is read only. If you want to change the slideup's click behavior, you can call one of the following method: `setSlideupClickActionToNewsFeed`, `setSlideupClickActionToUri:` or `setSlideupClickActionToNone`.
- The `uri` property defines the uri string that the slide up will open when the slideupClickActionType is ABKSlideupRedirectToURI. This is a read only property, you can call `setSlideupClickActionToUri:` to change it's value.

##### New Methods
- `logSlideupImpression` and `logSlideupClicked` have been added to allow you to report user interactions with the slideup in the case that you've fully customized the slideup experience and Appboy is not handling the interactions.
- `setSlideupClickActionToNewsFeed`, `setSlideupClickActionToUri:` and `setSlideupClickActionToNone` have been added to allow you to change the slideup's click action behavior. `setSlideupClickActionToUri:` accepts a uri string as parameter and required the given uri string is valid.

#### Delegate Method Changes

All former Appboy slideup delegate methods have been depreciated and removed. In their place Appboy has added new slideup delegate methods within [`ABKSlideupControllerDelegate.h`](https://github.com/Appboy/appboy-ios-sdk/blob/master/AppboyKit/AppboyKit.framework/Headers/ABKSlideupControllerDelegate.h).

- `onSlideupReceived:` is called when slideup objects are received from the Appboy server.
- `beforeSlideupDisplayed:withKeyboardIsUp:` is called before slideup objects are displayed, the return value determines whether the slideup will be displayed, queued or discarded.
- `slideupViewControllerWithSlideup:` This delegate method allows you to specify custom view controllers in which your slideups will be displayed.
  - The custom view controller should be a subclass of `ABKSlideupViewController`.
    - Alternatively, it can also be an instance of `ABKSlideupViewController`.
  - The view of the returned view controller should be an instance of `ABKSlideupView` or its subclass.
  - For integration examples of a custom slideup view controller, see the `CustomSlideupViewController` class in Appboy's sample app Stopwatch.
- `onSlideupClicked:` is called when a user clicks on a slideup. We recommend that you specify behavior on click via the dashboard, but you can additionally specify behavior on click by defining this delegate method.
- `onSlideupDismissed:` is called whenever the slideup is dismissed regardless of whether the dismissal occurs automatically or via swipe. This method is not called if the user clicks on the slideup. If the user clicks or taps on the slideup, `onSlideupClicked` is called instead.

#### New Options on the Dashboard
- Slideup behavior on click can now be set within the dashboard to open a modal news feed, open a URI within a modal, or do nothing.
- The following properties can be set remotely from the Appboy Dashboard:
  - `extras`
  - `slideupAnchor`
  - `slideupDismissType`
  - `slideupClickActionType`
  - `uri`

### News Feed Changes
- News feed items are now cached in offline storage, allowing the news feed to render even when no internet connectivity is available. Appboy will still automatically try to pull down a new news feed when a session opens, even if an offline feed is available.
- Each card now has a maximum height of no more than 2009 points to avoid any performance issues as recommended by iOS developer guidelines.
- The entirety of captioned image cards are now clickable. Formerly, only the link itself was clickable.
- When the news feed is brought to the foreground, it will now automatically check for new content if the cached version of the feed was received more than 60 seconds ago.
— The width of news feed cards as well as the minimum margin between any card and the left & right edges of the view controller can now be customized. These values can be set separately for both iPad and iPhone. This allows for a larger news feed to render on larger screen sizes. All card images will scale proportionally. Please see `ABKFeedViewControllerContext.h` and `ABKFeedViewController.h` for more information.

### Other Changes
- Various internal and news feed display optimizations.

## 2.4
* IDFA Collection is now optional.
  * By default, IDFA collection is now disabled by the Appboy SDK.
    * There will be no loss of continuity on user profiles or loss of functionality whatsoever as a result of this change.
    * If you’re using advertising elsewhere in the app or through our in-app news feed, we recommend continuing to collect the IDFA through Appboy. You should be able to do so safely without fear of rejection from the iOS App Store.
    * The future availability of IDFAs will enable functionality like integrating with other third-party systems, including your own servers, and enabling re-targeting of existing users outside of Appboy. If you continue to record them we will store IDFAs free of charge so you can take advantage of these options immediately when they are released without additional development work.
  * Necessary Project Changes
    * ABKIdentifierForAdvertisingProvider.m and ABKIdentifierForAdvertisingProvider.h must be added to your project regardless of whether or not you enable collection. This occurs automatically if you integrate/update via the CocoaPod.
  * Enabling Appboy IDFA Collection
    * IDFA collection can be enabled via adding the following PreProcessor Macro to the Build Settings of your app:
      * `ABK_ENABLE_IDFA_COLLECTION`

## 2.3.1
* The Appboy SDK for iOS now has two versions, one for use with apps which incorporate the official Facebook SDK and one for those which do not. In November of 2013, the App Store Validation Process started generating warnings about the usage of isOpen and setActiveSession in the Appboy SDK. These selectors were being sent to instances of classes in the Facebook SDK and are generally able to be used without generating warnings. However because of the way that the classes were initialized in Appboy (a result of building a single Appboy binary to fully support apps with and without the Facebook SDK), the App Store Validation Process started generating warnings the Facebook SDK methods share a name with private selectors elsewhere in iOS. Although none of our customers have been denied App Store approval yet, to protect against potential validation policy changes by Apple, Appboy now provides two versions of its SDK, neither of which generate warnings. Going forward, the appboy-ios-sdk repository will provide both versions of the SDK in the folders 'AppboySDK' (as before) and 'AppboySDKWithoutFacebookSupport'. The 'AppboySDKWithoutFacebookSupport' does not require the host app to include the Facebook SDK, but as a result does not include all of the Appboy features for Facebook data fetching. More information is available here within the [Appboy documentation](http://documentation.appboy.com/sdk-integration-ios.html#ios-basic-sdk-integration).
* Fixed a bug that repeatedly updated the push token of some users unnecessarily.
* The "Reporting an Issue?" box within the UI layout of the Feedback Page has been moved to the left side of the label away from the "Send" button. This change was made to reduce the number of misclicks of the "Send" button. The "Reporting an Issue?" label is now clickable as well.
* Cross Promotion Cards for apps with long titles will now render appropriately in iOS5. Before the title would render abnormally large on these devices.
* Fixed a bug where view recycling would cause incorrect card images to appear for newly rendered cards (until the image for that card finished downloading). Card images for newly rendered cards will now remain empty until the correct image is downloaded.
* Internal changes to enable future support for a 64 bit library release.
* Improvements to the Appboy Sample App.
* Internal code structure and performance improvements including the move of more offline caching to background tasks.

## 2.3
* BREAKING CHANGE: The ABKSlideupControllerDelegate interface has been changed to work with ABKSlideup objects instead of simply the slideup message. This provides you with more control over the click actions and display of slideups and is also being made in anticipation of the augmentation of the ABKSlideup object with more data properties in future releases. To access the message previously sent to shouldDisplaySlideup, simply access the message property on the provided ABKSlideup argument.
* displayNextAvailableSlideup has been deprecated and will be removed in the next minor release, it has been replaced by provideSlideupToDelegate, see Appboy.h documentation for more information.
* provideSlideupToDelegate has been added to Appboy to allow for more fine grained control over slideup display.
* Fixes a bug where the slideupDelegate property getter on Appboy would always return nil.
* Changes the slideupDelegate property on Appboy to be retained, instead of assigned.

## 2.2.1
* Adds a startup option to appboyOptions to control the automatic capture of social network data. See the documentation on ABKSocialAccountAcquisitionPolicy in Appboy.h for more information.
* Changes a table cell's default background color to clear, from the white value that became default in iOS7.
* Adds support for developer to send up image_url for user avatars, allowing for custom images to be included in user profiles on the dashboard.

## 2.2
* Adds support for new banner and captioned image card types.
* Adds support for submitting feedback programmatically through an Appboy.h method without using Appboy feedback form. This allows you to create your own feedback form.
* Fixes an issue where the the news feed's web view would display "Connection Error" when a user came back into the app after a card had directed him or her to a protocol URL. Now when users come back from a redirected protocol URL, the feed is properly displayed.
* Fixes an issue where the SDK might have incorrectly sent both read and write Facebook permissions at the same time, instead preferring to request only those read permissions that Appboy is interested in and have already been requested by the incorporating app.
* Caught and fixed a corner case where card impressions could be miscounted when the feed view controller is the master view controller of a split view.
* Makes cards truncate properly at two lines.

## 2.1.1
* URGENT BUGFIX: This fixes an issue which exists in all previous versions of the v2 SDK which is causing crashes on the just release iPhone 5c and iPhone 5s. All users of v2 are recommended to upgrade the Appboy SDK to 2.1.1 immediately and re-submit to the app store.

## 2.1.0
* Adds support for iOS 7. You will need to use Xcode 5 to use this and future versions of the Appboy iOS SDK.
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
* Adds the ability to assign a Foursquare access token for each user. Doing so will cause the Appboy backend to make Foursquare data available in user profiles on the dasbhard.
* Adds more fine grained control options for Appboy's network activity. See Appboy.h for more information.

## 2.0.2
* Fixes a bug where Appboy might reopen a Facebook read session when a publish session already exists

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
  * Added support for device push tokens as NSData when registering the token to Appboy
  * More detailed error messages logged in console
  * Removed the enable/disable Appboy methods from Appboy.h

## 2.0
* Initial release
