## 2.3.1
* The Appboy SDK for iOS now has two versions, one for use with apps which incorporate the official Facebook SDK and one for those which do not. In November of 2013, the App Store Validation Process started generating warnings about the usage of isOpen and setActiveSession in the Appboy SDK. These selectors were being sent to instances of classes in the Facebook SDK and are generally able to be used without generating warnings. However because of the way that the classes were initialized in Appboy (a result of building a single Appboy binary to fully support apps with and without the Facebook SDK), the App Store Validation Process started generating warnings the Facebook SDK methods share a name with private selectors elsewhere in iOS. Although none of our customers have been denied App Store approvaly, to protect against potential validation policy changes by Apple, Appboy now provides two versions of its SDK, neither of which generate warnings. Going forward, the appboy-ios-sdk repository will provide both versions of the SDK in the folders 'AppboyKit' (as before) and 'AppboyKitWithoutFacebookSupport'. The 'AppboyKitWithoutFacebookSupport' does not require the host app to include the Facebook SDK, but as a result does not include all of the Appboy features for Facebook data fetching. Integration steps can be found in here within the [Appboy documentation](http://documentation.appboy.com/sdk-integration-ios.html#ios-basic-sdk-integration).
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
