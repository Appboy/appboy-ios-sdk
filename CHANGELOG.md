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
