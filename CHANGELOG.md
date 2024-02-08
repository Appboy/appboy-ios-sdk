#### ⚠️ The New Braze [Swift SDK](https://github.com/braze-inc/braze-swift-sdk) is now available!

## 4.7.0

#### Breaking
- Updates the minimum required version of SDWebImage from 5.8.2 to [5.18.7](https://github.com/SDWebImage/SDWebImage/releases/tag/5.18.7).
  - This version includes the privacy manifest for SDWebImage, which appears on the [privacy-impacting SDKs list](https://developer.apple.com/support/third-party-SDK-requirements/).

#### Added
- Adds the privacy manifest to describe data usage collected by Braze. For more details, refer to the [Apple documentation on privacy manifests](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files).
- Adds code signatures to all XCFrameworks in the Braze iOS SDK, signed by `Braze, Inc.`.

##### Fixed
- Fixes an issue in Full or Modal in-app messages where the header text would be duplicated in place of the body text under certain conditions.

## 4.6.0

This release requires Xcode `14.x`.

#### Breaking
- Drops support for iOS 9 and iOS 10.
- Removes support for the outdated `.framework` assets when importing via Carthage in favor of the modern `.xcframework` assets.
  - Use the command `carthage update --use-xcframeworks` to import the appropriate Braze asset.
  - Removes support for `appboy_ios_sdk_full.json` in favor of using `appboy_ios_sdk.json` by including these lines in your `Cartfile`:
    ```
    binary "https://raw.githubusercontent.com/Appboy/appboy-ios-sdk/master/appboy_ios_sdk.json"
    github "SDWebImage/SDWebImage"
    ```

##### Fixed
- Improves resilience when triggering in-app messages with date property filters.

##### Added
- Adds a new option `ABKReenqueueInAppMessage` to enum `ABKInAppMessageDisplayChoice`.
  - Return this option in `beforeInAppMessageDisplayed:` of an `ABKInAppMessageControllerDelegate` to ensure that an in-app message is not displayed and becomes eligible to trigger again.
  - This option will reset any trigger times and re-eligibility rules as if it was never triggered. It will not add the message to the in-app message stack.

## 4.5.4

##### Fixed
- Improves reliability of custom event property type validation.
- Fixes an issue where the status bar would not restore to its original state after a full in-app message was dismissed.

## 4.5.3

##### Fixed
- Fixes a crash that occurs when receiving custom event properties of numeric types under certain conditions.
- Fixes UI responsiveness warnings when requesting location authorization status.

## 4.5.2

##### Fixed
- Improves reliability when validating trigger properties.
- Improves the `NSURLSessionConfiguration` disk and memory cache capacities for file downloads. This change enables larger file downloads to be cached if needed.

## 4.5.1

##### Fixed
- Improves eligibility checks around the minimum trigger timeout for in-app messages by now checking at _trigger time_ in addition to _display time_.
- Fixes an issue where purchases would not trigger certain templated in-app messages.

##### Added
- Adds the delegate method `noMatchingTriggerForEvent:name:` to `ABKInAppMessageControllerDelegate`, which is called if no Braze in-app message was triggered for a given event.

## 4.5.0

##### Added
- Adds support for Content Cards to evaluate Retry-After headers.

## 4.4.4

##### Fixed
- Calling `appboyBridge.closeMessage()` or `brazeBridge.closeMessage()` from an HTML in-app message now correctly triggers `ABKInAppMessageUIDelegate.onInAppMessageDismissed:` when implemented.
- Fixes an issue in `4.4.3` where the tvOS SDK incorrectly referenced an older SDK version.

## 4.4.3

##### Fixed
- Fixes an issue introduced in `4.4.0` which prevented custom events or purchases with an empty dictionary of properties from being logged.
- Improves handling of `ABKInAppMessageWindow`'s dismissal to promptly remove it from the view hierarchy.
- Fixes the position of the pinned indicator for _Captioned Image_ Content Cards when using the default UI.
- Fixes an issue introduced in `4.3.2` and limited to users of `Appboy-tvOS-SDK`, which prevented custom events with properties or purchases with properties from being logged.

##### Added
- Adds a `padding` property to `ABKCaptionedImageContentCardCell` to support modifying the default value.

## 4.4.2

##### Fixed
- Fixes a bug for HTML in-app messages using the _HTML Upload with Preview_ option to improve the reliability of in-app message display.
- Fixes a bug preventing integration via Swift Package Manager in specific contexts.
- Fixes an issue in the default Content Cards UI where the empty feed label was truncated if it was too large for the screen, for example due to accessibility or localization.
- Fixes an issue where Slideup in-app messages would be automatically dismissed after multiple interaction with the app's main window.

##### Changed
- If `changeUser:sdkAuthSignature:` is called with the current user's ID, but with a new and valid SDK Authentication signature, the new signature will be used.
- Improves push tracking accuracy for apps making use of `UISceneDelegate` (UIKit) or `Scene` (SwiftUI).

## 4.4.1

##### Fixed
- Fixes an issue in which `input` elements with `type="date"` in HTML in-app messages do not respond to some user interactions on iOS 14 and iOS 15.
- Fixes `ABKSdkMetadata` availability when using the dynamic variant of the SDK.
- Fixes an issue in which the default content cards UI's empty feed label does not wrap properly when the device is using Larger Accessibility Sizes for its text size.

##### Changed
- Changed `ABKInAppMessageUIDelegate.inAppMessageViewControllerWithInAppMessage:` to accept a `nil` return value.

##### Added
- Adds support for the `playsinline` attribute on HTML `<video>` elements within webpages that are opened in the app by Braze.
- Adds XCFramework support for the Core integration via Carthage. Please follow the [Carthage migration guide](https://github.com/Carthage/Carthage#migrating-a-project-from-framework-bundles-to-xcframeworks) when transitioning to the new artifact.

## 4.4.0

##### Breaking
- Adds XCFramework support to Carthage. This allows projects integrated via Carthage to support Apple Silicon simulators and Mac Catalyst.
  - When migrating from the original `.framework` to the new `.xcframework`, follow [the official Carthage migration guide](https://github.com/Carthage/Carthage#migrating-a-project-from-framework-bundles-to-xcframeworks).
  - For those using the Full integration, use the following lines in your `Cartfile`. Note that it references the file `appboy_ios_sdk.json`:
    ```
    binary "https://raw.githubusercontent.com/Appboy/appboy-ios-sdk/master/appboy_ios_sdk.json"
    github "SDWebImage/SDWebImage"
    ```
    - To continue using the original Full `.framework` file, include the `Cartfile` lines above but reference `appboy_ios_sdk_full.json`. Then, run `carthage update`.
  - For those using the Thin integration, use the same `Cartfile` above but exclude the line with `SDWebImage`.
  - The Core integration does not support XCFrameworks, and you can use the original `.framework` files as before.

##### Added
- Adds a new attachment to the release called `Appboy_iOS_SDK.xcframework.zip`.
  - This artifact has the all-in-one XCFramework containing the full SDK code including all of the assets.
  - When importing this code manually, drag-and-drop the XCFramework into your project and select `Embed & Sign`. Then, add `-ObjC` under `Build Settings > Other Linker Flags` in your app's target.
- Adds localization support for the close button's accessibility label in modal and full in-app messages.
- Adds the ability to set the SDK's log level at runtime by setting `ABKLogLevelKey` to an integer in `appboyOptions`. Descriptions of the available log levels can be found [here](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/other_sdk_customizations/#description-of-log-levels).
- Adds `Appboy.addSdkMetadata:` to allow self reporting of SDK Metadata fields via the `ABKSdkMetadata` enum.

## 4.3.4

This release requires Xcode 13.

##### Fixed
- Fixes an issue in which the pinned indicator for a Banner Content Card would not display in the default Content Cards UI.
- Fixes an issue which prevented custom events and purchases with properties larger than 50 KB to be properly discarded.

## 4.3.3

##### Fixed
- Fixes a race-condition occasionally preventing HTML in-app messages with assets from being displayed from a test push.
- Fixes an issue which prevented HTML in-app messages from opening `sms:`, `mailto:`, `tel:`, `facetime:` and `facetime-audio:` urls.
  - Previously, those urls would fail to open silently.
- Fixes an issue where `ABKContentCardsTableViewController` was not displaying the "no update" label after the last card was deleted from the feed.

##### Added
- Adds methods `addToSubscriptionGroupWithGroupId:` and `removeFromSubscriptionGroupWithGroupId:` to `ABKUser` to manage SMS/Email Subscription Groups.
  - Also adds `appboyBridge.getUser().addToSubscriptionGroup(groupId)` and `appboyBridge.getUser().removeFromSubscriptionGroup(groupId)` to the javascript interface for HTML in-app messages.

## 4.3.2

##### Fixed
- Iframes embedded in an HTML in-app message are now displayed as part of the same in-app message. Previously, iframes would be loaded in a separate webview.

##### Added
- Adds support for navigation bar transparency changes introduced in iOS 15. Apps using Braze default UIs for Content Cards, the News Feed, and the modal WebView should upgrade to this version as soon as possible ahead of iOS 15's release.

## 4.3.1

##### Fixed
- The `sdkAuthenticationDelegate` now works as expected when setting the property directly.
- VoiceOver no longer reads content beneath the displayed in-app message.

##### Changed
- The number of unviewed Content Cards in `ABKContentCardsController`'s `unviewedContentCardCount` now excludes control cards.
- The default Content Cards UI now allows swipe-to-refresh gestures when empty.
- Deprecates `ABKInAppMessageController`'s method `displayNextInAppMessageWithDelegate:` in favor of `displayNextInAppMessage`.

##### Added
- Custom events and purchases now support nested properties.
  - In addition to integers, floats, booleans, dates, or strings, a JSON object can be provided containing dictionaries of arrays or nested dictionaries. All properties combined can be up to 50 KB in total length.

## 4.3.0

##### Breaking
- Refined Content Cards UI public api changes introduced in `4.2.0`.

##### Fixed
- Fixes an issue introduced in `4.2.0` that caused Content Card type `ABKClassicImageContentCardCell` to crash on display when not using Storyboard.

## 4.2.0

##### ⚠️ Known Issues
- This release contains a known issue with the Content Cards default UI on iOS, where showing a "Classic" type card with an image causes a crash. If you are using the default Content Cards UI, do not upgrade to this version.

##### Breaking
- Content Cards and News Feed are now more extensible!
  - Class level API methods have changed to instance methods to make subclassing easier, however `getNavigationContentCardsViewController` and `getNavigationFeedViewController` are left in as class methods for backwards compatibility.
  - Subclassing views is now fully supported for customizations. See the [Content Card sample code for examples](https://github.com/Appboy/appboy-ios-sdk/tree/master/Samples/ContentCards/BrazeContentCardsSampleApp).
  - Alternatively, you can bring your own storyboard with customizations. See our [example custom storyboard implementation](https://github.com/Appboy/appboy-ios-sdk/tree/master/Example/Stopwatch/Sources/ViewControllers/Braze%20UI/FeedUIViewController.m).
  - See the [Content Cards documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/content_cards/) for more information.

##### Fixed
- Fixes an issue with Dynamic Type support introduced in [3.34.0](#3340) to be compatible with iOS 9.

##### Added
- Adds support for new SDK Authentication feature.
- Exposes `window.brazeBridge` in HTML in-app messages which replaces `window.appboyBridge`. `appboyBridge` is deprecated and will be removed in a future version of the SDK.

##### Changed
- Makes in-app message window handling more resilient:
  - The in-app message window tries to display up to 10 times when another window competes for visibility. If the in-app message is not guaranteed visibility, it is dismissed and an error is logged.
- Improves `Appboy`'s `wipeDataAndDisableForAppRun` and `disableSDK` to handle additional use cases.
- Deprecates `flushDataAndProcessRequestQueue` in favor of `requestImmediateDataFlush`.

## 4.1.0

##### Breaking
- `ABKURLDelegate` method `handleAppboyURL:fromChannel:withExtras:` is now invoked for all urls.
  - Previously, this delegate method was not invoked for urls opened in a WebView or the default browser when originating from the News Feed or Content Cards.
- Removes `ABKUIURLUtils` method `openURLWithSystem:fromChannel:`. Use `openURLWithSystem:` as a replacement.

##### Fixed
- Fixes a case where the `ABKURLDelegate` method `handleAppboyURL:fromChannel:withExtras:` was being called twice when opening a push notification with an url.

##### Changed
- Deprecates `ABKUnknownChannel`.

## 4.0.2

##### Fixed
- Fixes a double redirection bug in Push Stories when the app is in a terminated state and `application:didReceiveRemoteNotification:fetchCompletionHandler:` is not implemented.

##### Changed
- Improves the Swift Package Manager bundle lookup to be more flexible.

##### Added
- Adds support to use a dictionary named `Braze` instead of `Appboy` when adding customization in the `Info.plist`. After adding the `Braze` dictionary, please remove the previous `Appboy` dictionary.

## 4.0.1

##### Fixed
- Sets `CFBundleSupportedPlatforms` in _.plist_ files to the correct non-simulator value.
- Removes the Dynamic Type support warnings.

## 4.0.0

##### Breaking
- `AppboyKit` is now distributed as an XCFramework when integrating with Cocoapods. Cocoapods 1.10.0+ is required.
  - This removes the need for integrators to exclude the `arm64` architecture when building for the simulator. Please undo any of the changes that may have been made when upgrading to [3.27.0 (_Integrators will now be required to exclude ..._)](#3.27.0_4.0.0).

##### Fixed
- Fixes the Swift Package Manager cleanup script to remove only the necessary files.

##### Added
- Adds Mac Catalyst support for apps integrating with Cocoapods.

## 3.34.0

##### Breaking
- Replaces `ABKInAppMessageSlideupViewController`'s `slideConstraint` by `offset`.

##### Added
- Adds a new Github repo to optimize import speeds for applications integrating with Swift Package Manager.
  - To use this repo, follow these steps:
    - Remove the existing package in your application that points to the url: `https://github.com/Appboy/Appboy-ios-sdk`.
    - Add a new package using the new url: `https://github.com/braze-inc/braze-ios-sdk`.
    - Follow the rest of [the setup instructions here](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/swift_package_manager/).
- Adds support for Right-to-Left languages in the News Feed.
- Adds support for scaling fonts automatically with [Dynamic Type](https://apple.co/3jSe9hc) for in-app messages and the News Feed.

##### Changed
- Improves accessibility handling for modal and full in-app messages.
- Improves Slideup in-app message animations.

## 3.33.1

##### Fixed
- Fixes Swift Package Manager integration.
  - In Xcode, select _File ▸ Swift Packages ▸ Update to Latest Package Versions_ to update.
- Fixes Push Story integration via CocoaPods for applications that have `use_frameworks!` in their Podfile.

## 3.33.0

##### Breaking
- Changed Push Story integration to use XCFrameworks for Cocoapods and manual integration. Applications currently integrating Push Stories via Cocoapods or manual integration must follow these steps when updating:
  - In your Notification Content Extension target:
    - Remove `AppboyPushStory.framework` from `Frameworks and Libraries` under the `General` tab.
  - In your application target:
    - Delete the `Copy File` build phase copying the `AppboyPushStory.framework` to the `Frameworks` destination.
    - Delete the `Run Script` build phase that starts with:
      ```
      APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

      find "$APP_PATH" -name 'AppboyPushStory.framework' -type d | while read -r FRAMEWORK
      ...
      ```

- Removed `ABKSDWebImageProxy`'s `prefetchURLs:` method.

##### Fixed
- Fixes a double redirection bug in Push Stories when the app is in a terminated state and the `UNUserNotificationCenter` delegate is not the `AppDelegate`.

## 3.32.0

##### Added
- Adds Mac Catalyst support for apps integrating with Swift Package Manager (SPM).
  - Please follow [the instructions here](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/swift_package_manager/) to import the SDK with SPM. The SDK does not currently support Mac Catalyst when integrated through Cocoapods or Carthage.
  - To add Mac Catalyst support, update the `Run Script Action` described in the [3.31.0 section of the Changelog](#3310).
    - Replace the existing script with the following:
      ```
      # iOS
      bash "$BUILT_PRODUCTS_DIR/Appboy_iOS_SDK_AppboyKit.bundle/Appboy.bundle/appboy-spm-cleanup.sh"
      # macOS
      bash "$BUILT_PRODUCTS_DIR/Appboy_iOS_SDK_AppboyKit.bundle/Contents/Resources/Appboy.bundle/appboy-spm-cleanup.sh"
      ```

## 3.31.2

##### Fixed
- Fixes the formatting of Full and Slideup in-app messages when displaying on iPhone 12 mini.

##### Changed
- Improves Push Story click tracking handling.

## 3.31.1

##### Breaking
- Removes the method `getSDWebImageProxyClass` from `ABKUIUtils`.
  - You can access the public class `ABKSDWebImageProxy` directly by importing `ABKSDWebImageProxy.h`.

##### Fixed
- Fixes a bug in the Cocoapods integration that would lead to SDK localizations being embedded for languages not explicitly supported in the app.
- Fixes a rare crash that would occur when no windows exist at `UIWindowLevelNormal` while an in-app message is being displayed and `UIKit` requests UI updates (orientation change, etc.).
- Fixes a bug in modal in-app messages where some languages (such as Burmese) may have clipped text.

## 3.31.0

##### Breaking
- For apps that have previously integrated through Swift Package Manager, please perform the following steps:
  - In the Xcode menu, click `Product > Scheme > Edit Scheme...`
      - Click the expand ▶️ next to `Build` and select `Post-actions`. Press `+` and select `New Run Script Action`.
      - In the dropdown next to `Provide build settings from`, select your app's target.
      - Copy this script into the open field:
        ```
        bash "$BUILT_PRODUCTS_DIR/Appboy_iOS_SDK_AppboyKit.bundle/Appboy.bundle/appboy-spm-cleanup.sh"
        ```
  - If you are updating from 3.29.0 or 3.29.1, remove the `Run Script Action` previously specified in the [3.29.0 section of this changelog](#3290).

##### Added
- Adds Push Stories support for apps integrating with Swift Package Manager.
  - In your app content extension's target, under `Build Settings > Other Linker Flags`, add the `-ObjC` linker flag.

##### Changed
- Updates the email validation on the SDK to be more lenient in favor of more accurate validation by the Braze backend. Valid emails with uncommon patterns or international characters that were previously rejected will now be accepted.
- Deprecates `ABKDeviceWhitelistKey` in favor of `ABKDeviceAllowlistKey`.

##### Fixed
- Fixes a bug in HTML in-app messages where some native WebKit UI elements could be unresponsive.

## 3.30.0

##### Breaking
- Body click analytics will no longer automatically be collected for HTML in-app messages created using the _HTML Upload with Preview_ option in the platform.
  - To continue to receive body click analytics, you must log body clicks explicitly from your message via Javascript using `appboyBridge.logClick()`.

##### Fixed
- Fixes a bug with Full in-app messages where the button positions did not match the preview on the Braze dashboard.
- Fixes a bug where in-app messages would be displayed below the application window under specific conditions.
  - Apps that set up their window asynchronously at startup could accidentally hide the in-app message window if one was being displayed (e.g. as a result of clicking on a test in-app message notification).

##### Added
- Adds support for custom endpoints with a scheme included (`https`, `http`, etc.). For example, `http://localhost:3001` will no longer result in `https://http://localhost:3001` as the resolved endpoint.

## 3.29.1

#### Added
- Adds improved support for in-app message display on iPhone 12 models.

## 3.29.0

##### Added
- Adds initial support for Swift Package Manager. There are 2 new packages that have been added: `AppboyKit` for the core SDK and `AppboyUI` for the full SDK (including UI elements), which correspond to the `Appboy-iOS-SDK/Core` and `Appboy-iOS-SDK` pods, respectively.
  - Note that tvOS support is not available via Swift Package Manager for this release. Push Stories is only available through a side-by-side integration with Cocoapods.
  - To add the package to your project follow these steps:
    - Select `File > Swift Packages > Add Package Dependency`.
      - In the search bar, enter `https://github.com/Appboy/Appboy-ios-sdk`.
      - Select _one_ of `AppboyKit` or `AppboyUI`. Note that `AppboyUI` includes `AppboyKit` automatically.
    - In your app's target, under `Build Settings > Other Linker Flags`, add the `-ObjC` linker flag.
    - In the Xcode menu, click `Product > Scheme > Edit Scheme...`
      - Click the expand ▶️ next to `Build` and select `Post-actions`. Press `+` and select `New Run Script Action`.
      - In the dropdown next to `Provide build settings from`, select your app's target.
      - Copy this script into the open field:
        ```
        rm -rf "${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Frameworks/libAppboyKitLibrary.a"
        rm -rf "${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Plugins/libAppboyKitLibrary.a"
        ```

## 3.28.0

##### Breaking
- Removes `userNotificationWasSentFromAppboy:` and `pushNotificationWasSentFromAppboy:` on `Appboy`. Use `isAppboyUserNotification:` and `isAppboyRemoteNotification:` in `ABKPushUtils` instead.
- Updates `ABKURLDelegate`'s method signature for `handleAppboyURL:fromChannel:withExtras:` to include nullability annotations required for proper Swift support.

##### Fixed
- Fixes a race condition in `Appboy` method `wipeDataAndDisableForAppRun` where certain persisted fields would still be available immediately after calling the method. These fields now are removed synchronously.

##### Changed
- Updated SDWebImage to use version 5.9.x.

## 3.27.0

##### Breaking
- Adds support for iOS 14. Requires Xcode 12.
- Removes the `ABK_ENABLE_IDFA_COLLECTION` preprocessor macro from the SDK.
  - If you wish to send IDFA to Braze, please use the [`ABKIDFADelegate`](https://appboy.github.io/appboy-ios-sdk/docs/protocol_a_b_k_i_d_f_a_delegate-p.html). For more information, reference [our documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/other_sdk_customizations/#implementing-idfa-collection).
- Updates the `ABKIDFADelegate` protocol by renaming `isAdvertisingTrackingEnabled` to `isAdvertisingTrackingEnabledOrATTAuthorized` to reflect the addition of the `AppTrackingTransparency` framework in iOS 14.
  - If you use the `Ad Tracking Enabled` segment filter on the Braze dashboard or are implementing `AppTrackingTransparency`, you must update your integration to use `AppTrackingTransparency` to read the correct user status. Please see our [sample app](https://github.com/Appboy/appboy-ios-sdk/blob/master/Example/Stopwatch/Sources/Utils/IDFADelegate.h) for implementation details.
  - If you do not use the `Ad Tracking Enabled` segment filter and are not implementing `AppTrackingTransparency` yet, your implementation of `isAdvertisingTrackingEnabledOrATTAuthorized` may temporarily continue to use `isAdvertisingTrackingEnabled`. However, [the returned value will always be `NO` in iOS 14](https://developer.apple.com/documentation/adsupport/asidentifiermanager/1614148-isadvertisingtrackingenabled), regardless of actual IDFA availability.
  - Note that Apple announced that they will delay the enforcement of upcoming IDFA changes until early 2021. Please reference our [iOS 14 upgrade guide](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/ios_14/) for more details.
- Updates the minimum required version of SDWebImage from 5.0 to 5.8.2.
- <a name="3.27.0_4.0.0"></a>Integrators will now be required to exclude the `arm64` simulator slice in their entire project.
  - This is done automatically when integrating via Cocoapods.
  - For other cases:
    - If you are using `xcconfig` files to build your app, please set:
      - For iOS targets: `EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64`
      - For tvOS targets: `EXCLUDED_ARCHS[sdk=appletvsimulator*] = arm64`
    - If you are using the Xcode _Build Settings_ panel, enable _Build Active Architecture Only_ for the configuration you use to run your app on the simulator. (`ONLY_ACTIVE_ARCH = YES`)

## 3.26.1

##### Changed
- Deprecates the compilation macro `ABK_ENABLE_IDFA_COLLECTION` in favor of the `ABKIDFADelegate` implementation.
  - `ABK_ENABLE_IDFA_COLLECTION` will not function properly in iOS 14. To continue collecting IDFA on iOS 14 devices, please upgrade to Xcode 12 and implement `App Tracking Transparency` and Braze's `ABKIDFADelegate` (see the [iOS 14 upgrade guide](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/ios_14/#idfa-and-app-tracking-transparency) for more information).

##### Added
- Adds improved support for iOS 14 Approximate Location tracking.

## 3.26.0

##### Breaking
- Removed readonly property `overrideApplicationStatusBarHiddenState` in `ABKInAppMessageViewController.h`.

##### Fixed
- Fixes an issue with in-app messages not respecting the application's status bar style when _View controller-based status bar appearance_ (`UIViewControllerBasedStatusBarAppearance`) is set to `YES` in the Info.plist.
- Fixes an issue which can lead to text being cut off in Content Cards for specific iPhone models.
- Fixes an issue preventing test Content Cards from displaying under specific conditions.

##### Changed
- Added Binary Project Specification file for more efficient Carthage integration of the full SDK.
  - Update your Cartfile to use `binary "https://raw.githubusercontent.com/Appboy/appboy-ios-sdk/master/appboy_ios_sdk_full.json"`
  - Support for this integration method was added starting with version 3.24.0 of the SDK.

##### Added
- Adds support for specifying `PushStoryAppGroup` in the `Appboy` dictionary in your app's `Info.plist`. This [Apple App Group](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups?language=objc) will share the [Braze Push Story](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/push_story/) information such as Campaign IDs between applications from a single Apple Developer account.
- Adds `appboyBridge.getUser().addAlias(alias, label)` to the javascript interface for HTML in-app messages.
- Adds the property `overrideUserInterfaceStyle` to `ABKInAppMessage` that allows forcing Light or Dark mode in the same way as Apple's [`UIViewController.overrideUserInterfaceStyle`](https://developer.apple.com/documentation/uikit/uiviewcontroller/3238087-overrideuserinterfacestyle?language=objc).
  - You can set this property in the `beforeInAppMessageDisplayed:` method of an [ABKInAppMessageControllerDelegate](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/in-app_messaging/customization/#setting-delegates).
- Adds the ability to dismiss modal in-app messages when the user clicks outside of the in-app message.
  - This feature is disabled by default.
  - You can enable the feature by adding the `Appboy` dictionary to your `Info.plist` file. Inside the `Appboy` dictionary, add the `DismissModalOnOutsideTap` boolean subentry and set the value to `YES`.
  - You can also enable the feature at runtime by setting `ABKEnableDismissModalOnOutsideTapKey` to `YES` in `appboyOptions`.

## 3.25.0

##### Breaking
- Removes the `arm64e` architecture when building with Cocoapods.
- Removes the deprecated property `appWindow` from `ABKInAppMessageWindowController`.

## 3.24.2

##### Fixed
- Fixes an issue with post-dismissal view hierarchy restoration for in-app messages under specific conditions.

##### Changed
- Deprecates `ABKInAppMessageWindowController` property `appWindow`.

## 3.24.1

##### Fixed
- Fixes an issue introduced in 3.24.0 breaking the SDK compatibility with Cocoapods.

## 3.24.0

**Important** This release is not compatible with Cocoapods. Do not upgrade to this version and upgrade to 3.24.1 and above instead.

##### Breaking
- Renames `ABKInAppMessageWindow`'s `catchClicksOutsideInAppMessage` to `handleAllTouchEvents`.

##### Fixed
- Fixes an issue where the unread indicator on a Content Card would persist even after being read.
- Fixes an issue preventing long texts from displaying correctly in Full in-app messages.
- Fixes an issue where appboyBridge would not work in an Ajax callback within HTML In-App Messages.

##### Changed
- Changes the manual integration steps for versions 3.24.0 and newer. Please follow the updated integration steps [here](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/initial_sdk_setup/manual_integration_options/).

##### Added
- Adds support for JavaScript functions `window.alert()`, `window.confirm()` and `window.prompt()` in HTML in-app messages.
- Adds the `ABKContentCardsTableViewControllerDelegate` protocol to more intricately handle Content Card clicks using the methods `contentCardTableViewController:shouldHandleCardClick:` and `contentCardTableViewController:didHandleCardClick:`.

## 3.23.0

##### Fixed
- Fixes an issue with regex based event property triggers not working as expected. Previously on iOS they had to match the entire string, now they will search for matches as expected.
- Improves resiliency when handling multiple background requests.

##### Added
- Adds support for upcoming HTML In-App Message templates.
- Adds support for applications using [scenes](https://developer.apple.com/documentation/uikit/app_and_environment/scenes) (`UIWindowSceneDelegate`). In-app messages are now properly displayed in that context.

## 3.22.0

##### Breaking
- Removes the key `ABKInAppMessageHideStatusBarKey` from `appboyOptions` and the property `forceHideStatusBar` from `ABKInAppMessageController`. Full screen in-app messages are now always displayed with the status bar hidden.
- Adds Dark Mode support to Content Cards. This feature is enabled by default and can be disabled by setting `enableDarkTheme` property to `NO` on `ABKContentCardsTableViewController` before the view controller is presented.

##### Fixed
- Fixes an issue in HTML in-app messages where button clicks weren't correctly being attributed for `mailto:` and `tel:` links.
- Fixes an issue in HTML in-app messages where videos would be displayed underneath the in-app message when full screen playback was enabled. The in-app message `UIWindow`'s `windowLevel` is now set to `UIWindowLevelNormal` instead of being above `UIWindowLevelStatusBar`.
- Fixes an issue in Content Cards where `ABKURLDelegate` was not being respected when opening links.

##### Added
- Adds `appboyBridge.logClick(id)`, `appboyBridge.logClick()` and `appboyBridge.getUser().setCustomLocationAttribute(key, latitude, longitude)` to the javascript interface for HTML in-app messages.
- Adds Czech and Ukrainian language support for Braze UI elements.
- Adds the ability to unset the current user's email attribute by setting the `email` property of the current `ABKUser` instance to `nil` (e.g. `[Appboy sharedInstance].user.email = nil;`).
- Adds Dark Mode support to Push Stories.
- Adds the ability to set maximum width of Content Cards by using the `maxContentCardWidth` property of `ABKContentCardsTableViewController`.

## 3.21.3

##### Added
- Adds an option to disable automatic geofence requests.
  - You can do this in the plist by adding the `Appboy` dictionary to your Info.plist file. Inside the `Appboy` dictionary, add the `DisableAutomaticGeofenceRequests` boolean subentry and set the value to `YES`.
  - You can also disable automatic geofence requests at runtime by setting `ABKDisableAutomaticGeofenceRequestsKey` to `YES` in `appboyOptions`.
- Adds the method `requestGeofencesWithLongitude:latitude:` to `Appboy.h`. This method can be called whenever you explicitly want Braze to send a request for updated Geofences information. This call is rate limited to once per user session.

## 3.21.2

##### Fixed
- Fixes an issue in HTML in-app messages where, during display, the viewport would shift down if the keyboard was opened but not shift back up when the keyboard was closed.
- Fixes an issue introduced in 3.17.0 where the SDK would give precedence to the endpoint passed in `Info.plist` if given both an endpoint from the `Info.plist` and `appboyOptions`.

##### Added
- Adds the ability to set a custom `WKWebViewConfiguration` for HTML in-app messages. You can set it using the method `setCustomWKWebViewConfiguration` in `ABKInAppMessageUIDelegate`.

##### Changed
- Removes calls to deprecated APIs `statusBarOrientation` and `statusBarFrame`.
- Un-deprecates the following push utility methods: `isUninstallTrackingUserNotification:`, `isUninstallTrackingRemoteNotification:`, `isGeofencesSyncUserNotification:`, `isGeofencesSyncRemoteNotification:`, and `isPushStoryRemoteNotification:` from `ABKPushUtils`. These APIs were originally deprecated in 3.16.0.

## 3.21.1

##### Fixed
- Fixes an issue for Modal and Full in-app messages where the opacity value of the close X button was not being respected.

##### Changed
- `ABKContentCard.m` will now log a click event when `logContentCardClicked` is called and no URL field is populated.

##### Added
- Adds the ability to force the status bar to hide when a Full or HTML in-app message is being actively displayed. To opt in to this feature, set `ABKInAppMessageHideStatusBarKey` to `YES` in `appboyOptions`.

## 3.21.0

##### Breaking
- Requires XCode 11.

##### Fixed
- Fixes an issue in the animate-in behavior of HTML in-app messages that could cause a brief flicker before the message displayed on older devices and simulators.
- Fixes an issue with Slideup in-app messages where they would cover part of the status bar when animating from the top on non-notched devices.
- Fixes an issue introduced in 3.14.1 where boolean-typed event properties would be improperly cast to numbers.

##### Changed
- Updates the logging format for debug, warn, and error `ABKLogger` messages to now print their log level.

##### Added
- Adds support for the upcoming feature, in-app messages with Dark Mode support.
  - Dark Mode enabled messages must be created from the dashboard. Braze does not dynamically theme in-app messages for Dark Mode.
  - This feature is enabled by default for all new `ABKInAppMessage` instances. To prevent Braze from automatically applying a Dark Theme when the fields are available on Braze's servers, set the `enableDarkTheme` flag on `ABKInAppMessage` to `NO` in the `beforeInAppMessageDisplayed:` method of your `ABKInAppMessageControllerDelegate` delegate implementation.
- Adds the ability to reference the Braze iOS SDK API from Swift when using the `Appboy-tvOS-SDK` pod. Adding `import AppboyTVOSKit` to the top of your Swift file while using the `Appboy-tvOS-SDK` pod will give you equivalent behavior to adding `import Appboy_iOS_SDK` while using the `Appboy-iOS-SDK` pod.
- Adds the `populateContentCards:` method and the `cards` property to `ABKContentCardsTableViewController`'s public interface. By setting the `cards` property from within `populateContentCards:`, you may manipulate `ABKContentCard` field data and/or control which `ABKContentCard` instances are displayed from the context of a custom `ABKContentCardsTableViewController` subclass.

## 3.20.4

##### Fixed
- Fixed an issue with Content Cards where the header and description text fields would appear to be missing in Dark Mode.

##### Added
- Adds a `TEALIUM` SDK flavor option.

## 3.20.3

##### Added
- If Automatic Braze location collection is enabled, the SDK now submits a session start location request if location hasn't already been sent up for the session after any affirmative location permission prompt. This also applies to the new "Allow Once" option in iOS 13.

## 3.20.2

**Important** If you are on Braze iOS SDK 3.19.0 or below, we recommend upgrading to this version immediately to ensure uninterrupted collection of new push tokens as users upgrade to iOS 13.
- In `application:didRegisterForRemoteNotificationsWithDeviceToken:`, replace
```
[[Appboy sharedInstance] registerPushToken:
                [NSString stringWithFormat:@"%@", deviceToken]];
```
with
```
[[Appboy sharedInstance] registerDeviceToken:deviceToken];
```
- If you are on Braze iOS SDK 3.19.0 or below and unable to upgrade, you must ensure your `[Appboy registerPushToken]` implementation does not rely on `stringWithFormat` or `description` for parsing the `deviceToken` passed in from `application:didRegisterForRemoteNotificationsWithDeviceToken:`. Please reach out to your Customer Success Manager for more information.

- **Important** In Braze iOS SDK 3.19.0, we updated our HTML in-app message container from `UIWebview` to `WKWebView`, however, the initial releases have known issues displaying HTML in-app messages. If you are currently using 3.19.0, 3.20.0, or 3.20.1, you are strongly encouraged to upgrade if you make use of HTML in-app messages. Please see the following for more important information about the transition to `WKWebView`:
  -  If you are utilizing customization for HTML in-app messages (such as customizing `ABKInAppMessageHTMLFullViewController` or `ABKInAppMessageHTMLViewController`), we strongly recommend testing to ensure your in-app messages continue to display correctly and interactions function as intended.
  - The following javascript methods are now no-ops: `alert`, `confirm`, `prompt`.
  - Deep links without schemes are no longer supported. Ensure that your in-app message deep links contain schemes.

##### Fixed
- Fixes an issue introduced in 3.19.0 where HTML in-app messages would not register user clicks when the `.xib` failed to load.
- Fixes an issue introduced in 3.19.0 where HTML in-app messages with select special characters and an assets zip would cause display irregularities.

##### Changed
- Updates the `WKWebView` which displays HTML in-app messages with the following attributes:
  - `suppressesIncrementalRendering` is set to true
  - `mediaTypesRequiringUserActionForPlayback` is set to `WKAudiovisualMediaTypeAll`
- Updates the background color of the `WKWebView` which displays HTML in-app messages from `[[UIColor blackColor] colorWithAlphaComponent:.3]` to `[UIColor clearColor]`.

## 3.20.1

**Important** This release has known issues displaying HTML in-app messages. Do not upgrade to this version and upgrade to 3.20.2 and above instead. If you are using this version, you are strongly encouraged to upgrade to 3.20.2 or above if you make use of HTML in-app messages.

##### Fixed
- Fixes an issue introduced in 3.19.0 which changed the background of HTML in-app messages to a non-transparent color.
- Improves the robustness of push token collection code for iOS 13 introduced in 3.20.0.

## 3.20.0

**Important** This release has known issues displaying HTML in-app messages and a known issue with push token collection. Do not upgrade to this version and upgrade to 3.20.2 and above instead. If you are using this version, you are strongly encouraged to upgrade to 3.20.2 or above if you make use of HTML in-app messages.

##### Breaking
- Introduced a signature change for push token collection methods:
```
[[Appboy sharedInstance] registerPushToken:
                [NSString stringWithFormat:@"%@", deviceToken]];
```
with
```
[[Appboy sharedInstance] registerDeviceToken:deviceToken];
```

## 3.19.0

**Important** This release has known issues displaying HTML in-app messages. Do not upgrade to this version and upgrade to 3.20.2 and above instead. If you are using this version, you are strongly encouraged to upgrade to 3.20.2 or above if you make use of HTML in-app messages.

##### Breaking
- Replaces `UIWebView` with `WKWebView` for HTML in-app messages.
  -  If you are utilizing customization for HTML in-app messages (such as customizing `ABKInAppMessageHTMLFullViewController` or `ABKInAppMessageHTMLViewController`), you must test to ensure your in-app messages continue to display correctly and interactions function as intended.
  - The following javascript methods are now no-ops: `alert`, `confirm`, `prompt`.
  - Deep links without schemes are no longer supported. Please ensure that your in-app message deep links contain schemes.

## 3.18.0

##### Breaking
- Automatic Braze location collection is now disabled by default. If you choose to use our location collection, you must explicitly enable location collection.
  - You can do this in the plist by adding the `Appboy` dictionary to your Info.plist file. Inside the `Appboy` dictionary, add the `EnableAutomaticLocationCollection` boolean subentry and set the value to `YES`.
  - You can also enable location at runtime by setting `ABKEnableAutomaticLocationCollectionKey` to `YES` in `appboyOptions`.
- Removes the Feedback feature from the SDK. The `Feedback` subspec and all Feedback methods on the SDK, including `[[Appboy sharedInstance] submitFeedback]` and `[[Appboy sharedInstance] logFeedbackDisplayed]`, are removed.

##### Changed
- Improves support for in-app messages on “notched” devices (for example, iPhone X, Pixel 3XL). Full-screen messages now expand to fill the entire screen of any phone, while covering the status bar.

##### Added
- Adds the ability to enable Braze Geofences without enabling Braze location collection. You can set this in the plist by adding the `Appboy` dictionary to your Info.plist file. Inside the `Appboy` dictionary, add the `EnableGeofences` boolean subentry and set the value to `YES` to enable Braze Geofences. You can also enable geofences at runtime by setting `ABKEnableGeofencesKey` to `YES` in `appboyOptions`.
  - If this key is not set, it will default to the status of automatic location collection (see breaking change above).
  - Note that Braze Geofences will continue to work on existing integrations if location collection is enabled and this new configuration is not present. This new configuration is intended for integrations that want Braze Geofences, but not location collection enabled as well.

## 3.17.0

##### Breaking
- Removes `ABKAppboyEndpointDelegate`.
  - You can now set the endpoint at runtime by setting the value of `ABKEndpointKey` in `appboyOptions` to your custom endpoint (ex. `sdk.api.braze.eu`) at initialization.

## 3.16.0

- **Important:** If you are using `ABKAppboyEndpointDelegate`, you will need to replace `dev.appboy.com` with `sdk.iad-01.braze.com` in the `getApiEndpoint` method.

##### Breaking
- Removes the methods: `allowRequestWhenInUseLocationPermission` and `allowRequestAlwaysPermission` from `ABKLocationManager`.
  - To request when in use location permission, use the following code:
  ```
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  [locationManager requestWhenInUseAuthorization];
  ```
  - To request always location permission, use the following code:
  ```
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  [locationManager requestAlwaysAuthorization];
  ```
  - The preprocessor macro `ABK_DISABLE_LOCATION_SERVICES` is no longer needed.
  - __Important:__ Configuring geofences to request always location permissions remotely from the Braze dashboard is no longer supported. If you are using Geofences, you will need to ensure that your app requests always location permission from your users manually.
- `ABKAutomaticRequestProcessingExceptForDataFlush` is deprecated. Users using `ABKAutomaticRequestProcessingExceptForDataFlush` should switch to `ABKManualRequestProcessing`, as the new behavior of `ABKManualRequestProcessing` is identical to the previous behavior of `ABKAutomaticRequestProcessingExceptForDataFlush`

##### Changed
- Deprecates the push utility methods: `isUninstallTrackingUserNotification:`, `isUninstallTrackingRemoteNotification:`, `isGeofencesSyncUserNotification:`, `isGeofencesSyncRemoteNotification:`, and `isPushStoryRemoteNotification:` from `ABKPushUtils`. Please use the function `isAppboyInternalRemoteNotification:`.
- Minor changes to the logic of `ABKManualRequestProcessing`. The original `ABKManualRequestProcessing` had specific exceptions and behaved more like `ABKAutomaticRequestProcessingExceptForDataFlush` in practice. As a result, the two policies have been merged into `ABKManualRequestProcessing`. Note that the new definition of `ABKManualRequestProcessing` is that periodic automatic data flushes are disabled. Other requests important to basic Braze functionality will still occur.

## 3.15.0

- **Important:** If you are using `ABKAppboyEndpointDelegate`, you will need to replace `dev.appboy.com` with `sdk.iad-01.braze.com` in the `getApiEndpoint` method.

##### Breaking
- Adds support for SDWebImage version 5.0.
  - Note that upgrading to SDWebImage 5.0 also removed the FLAnimatedImage transitive dependency from the SDK.

## 3.14.1

- **Important:** If you are using `ABKAppboyEndpointDelegate`, you will need to replace `dev.appboy.com` with `sdk.iad-01.braze.com` in the `getApiEndpoint` method.

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

- **Important:** If you are using `ABKAppboyEndpointDelegate` and plan to upgrade to 3.14.1, you will need to replace `dev.appboy.com` with `sdk.iad-01.braze.com` in the `getApiEndpoint` method.

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
- Adds support for the `arm64e` architecture when building with Cocoapods. Requires Xcode 10.1.

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

##### Breaking
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
 - Stops collecting user's Twitter data automatically. You can pass a user's Twitter information to Braze by initialzing a ABKTwitterUser object with the twitter data, and setting it to `[Appboy sharedInstance].user.twitterUser`. For more information, please refer to `ABKUser.h` and `ABKTwitterUser.h`.
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
 - Stops collecting user's Facebook data automatically. You can pass a user's Facebook information to Braze by initializing a ABKFacebookUser object with the facebook data, and set it to `[Appboy sharedInstance].user.facebookUser`. For more information, please refer to `ABKUser.h` and `ABKFacebookUser.h`.

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
* The Braze SDK for iOS now has two versions, one for use with apps which incorporate the official Facebook SDK and one for those which do not. In November of 2013, the App Store Validation Process started generating warnings about the usage of isOpen and setActiveSession in the Braze SDK. These selectors were being sent to instances of classes in the Facebook SDK and are generally able to be used without generating warnings. However because of the way that the classes were initialized in Braze (a result of building a single Braze binary to fully support apps with and without the Facebook SDK), the App Store Validation Process started generating warnings the Facebook SDK methods share a name with private selectors elsewhere in iOS. Although none of our customers have been denied App Store approval yet, to protect against potential validation policy changes by Apple, Braze now provides two versions of its SDK, neither of which generate warnings. Going forward, the appboy-ios-sdk repository will provide both versions of the SDK in the folders 'AppboySDK' (as before) and 'AppboySDKWithoutFacebookSupport'. The 'AppboySDKWithoutFacebookSupport' does not require the host app to include the Facebook SDK, but as a result does not include all of the Braze features for Facebook data fetching. More information is available here within the [Braze documentation](https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/).
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
