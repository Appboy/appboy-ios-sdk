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
    * If you’re using advertising elsewhere in the app or through our in-app News Feed, we recommend continuing to collect the IDFA through Appboy. You should be able to do so safely without fear of rejection from the iOS App Store. 
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
