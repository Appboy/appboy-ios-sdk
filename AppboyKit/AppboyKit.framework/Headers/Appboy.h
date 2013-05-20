//
//  Appboy.h
//  AppboySDK
//
//  Copyright (c) 2013 Appboy. All rights reserved.

/*!
  \mainpage
  This site contains technical documentation for the %Appboy iOS SDK. Click on the "Classes" link above to
  view the %Appboy public interface classes and start integrating the SDK into your app!
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ABKUser.h"

#ifndef APPBOY_SDK_VERSION
#define APPBOY_SDK_VERSION @"2.0"
#endif

@protocol ABKSlideupControllerDelegate;

@interface Appboy : NSObject

/* ------------------------------------------------------------------------------------------------------
 * Notifications
 */

/*!
 * When the news feed is updated, Appboy will post a notification through the NSNotificationCenter.
 * The name of the notification is the string constant referred to by ABKFeedUpdatedNotification. There
 * is no userInfo associated with the notification.
 *
 * To listen for this notification, you would register an object as an observer of the notification
 * using something like:
 *
 * <pre>
 *   [[NSNotificationCenter defaultCenter] addObserver:self
 *                                            selector:@selector(feedUpdatedNotificationReceived:)
 *                                                name:ABKFeedUpdatedNotification
 *                                              object:nil];
 * </pre>
 *
 * where "feedUpdatedNotificationReceived:" is your callback method for handling the notification:
 *
 * <pre>
 *   - (void) feedUpdatedNotificationReceived:(NSNotification *)notification {
 *     < Do something in response to the notification >
 *   }
 * <pre>
 */
extern NSString *const ABKFeedUpdatedNotification;

/* ------------------------------------------------------------------------------------------------------
 * Properties
 */

/*!
 * Disable Appboy for future sessions and prevent any network activity on the current session.
 */
@property (nonatomic, assign) BOOL enabled;


/*!
 * The current app user. 
 * See ABKUser.h and changeUser:userId below.
 */
@property (nonatomic, retain) ABKUser *user;

/*!
 * Appboy UI elements can be themed using the NUI framework. See https://github.com/tombenner/nui and the Appboy docs.
 * To enable NUI, take the following steps:
 *
 * - Get NUI from https://github.com/tombenner/nui. Follow the NUI Installation instructions from
 *   https://github.com/tombenner/nui.
 *
 * - Create a style sheet called NUIStyle.nss.
 * 
 * - set the property below to YES.
 *
 * If useNUITheming is NO, NUI is ignored completely whether or not it's integrated into your app.  Note that
 * you can theme your app and Appboy differently -- Appboy uses NUI independently of your app's use of NUI.
 *
 * NUI requires automatic referencing counting. Therefore, if you theme your app using NUI, you will leak memory
 * unless you have ARC enabled. Appboy will soon be releasing a fork of NUI that has the proper release/retain.
 */
@property (nonatomic, assign) BOOL useNUITheming;

/*!
 * Setting the slideupDelegate allows your app to control how, when, and if slideups are displayed.
 * Your app should adopt ABKSlideupControllerDelegate.  See below.
 */
@property (nonatomic, assign) id <ABKSlideupControllerDelegate> slideupDelegate;

/*!
 * The total number of currently active cards displayed in any feed view. Cards are
 * counted only once even if they appear in multiple feed views.
 */
@property (readonly, nonatomic, assign) int cardCount;

/*!
 * unreadCardCount is the number of currently active cards which have not been viewed.
 * A "view" happens when a card becomes visible in the feed view.  This differentiates
 * between cards which are off-screen in the scrolling view, and those which
 * are on-screen; when a card scrolls onto the screen, it's counted as viewed.
 *
 * Cards are counted as viewed only once -- if a card scrolls off the screen and
 * back on, it's not re-counted.
 *
 * Cards are counted only once even if they appear in multiple feed views or across multiple devices.
 */
@property (readonly, nonatomic, assign) int unreadCardCount;


/* ------------------------------------------------------------------------------------------------------
 * Methods
 */

/*!
 * Get the Appboy singleton.
 */
+ (Appboy *) sharedInstance;

/*!
 * @param apiKey The app's API key
 * @param inApplication The current app
 * @param withLaunchOptions The options NSDictionary that you get from application:didFinishLaunchingWithOptions
 * @discussion Starts up Appboy and tells it that your app is done launching; you should call this
 * method in your App Delegate application:didFinishLaunchingWithOptions method. Your apiKey comes from
 * the appboy.com dashboard where you registered your app.
 */
+ (void) startWithApiKey:(NSString *)apiKey
           inApplication:(UIApplication *)application
       withLaunchOptions:(NSDictionary *)launchOptions;

/*!
 * @param options The NSDictionary you get from application:didFinishLaunchingWithOptions or 
 * application:didReceiveRemoteNotification in your App Delegate.
 * @discussion
 * Test a push notification to see if it came Appboy's servers.
 */
- (BOOL) pushNotificationWasSentFromAppboy:(NSDictionary *)options;

/*!
 * @param token The device's push token.
 * @discussion This method posts a token to Appboy's servers to associate the token with the current device.
 */
- (void) registerPushToken:(NSString *)token;

/*!
 * @param application The app's UIApplication object
 * @param notification An NSDictionary passed in from the didReceiveRemoteNotification call
 * @discussion This method forwards remote notifications to Appboy. Call it from the application:didReceiveRemoteNotification
 * method of your App Delegate.
 */
- (void) registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification;

/*!
* @param userId The new user's ID (from the host application).
* @discussion
* This method changes the user's ID.
*
* When you first start using Appboy on a device, the user is considered "anonymous". You can use this method to
* optionally identify a user with a unique ID, which enables the following:
*
*   - If the same user is identified on another device, their user profile, usage history and event history will
*     be shared across devices.
*
*   - If your app is used by multiple people, you can assign each of them a unique identifier to track them
*     separately. Only the most recent user on a particular device will receive push notifications and in-app
*     messages.
*
*   - If you identify a user which has never been identified on another device, the entire history of that user as
*     an "anonymous" user on this device will be preserved and associated with the newly identified user.
*
*   - However, if you identify a user which *has* been identified on another device, the previous anonymous
*     history of the user on this device will not be added to the already existing profile for that user.
*
*   - Note that switching from one identified user to another is a relatively costly operation. When you request the
*     user switch, the current session for the previous user is automatically closed and a new session is started.
*     Appboy will also automatically make a data refresh request to get the news feed, slideup and other information
*     for the new user. Note that following a call to changeUser, any events which fire are guaranteed to be for the
*     new user -- if a delayed or otherwise later server request response provides a new
*     feedback response, message feed or slideup for the old user, you will not be notified. Appboy will try to send
*     outstanding data to the server but if that fails, Appboy will not attempt to re-flush the old user's data until
*     the next time that user logs in, instead preferring to quickly free up any resources being used by the old
*     user's operations.
*
*  Note: Once you identify a user, you cannot go back to the "anonymous" profile. The transition from anonymous
*  to identified tracking only happens once because the initial anonymous user receives special treatment
*  to allow for preservation of their history. We recommend against changing the user id just because your app
*  has entered a "logged out" state because it separates this device from the user profile and thus you will be
*  unable to target the previously logged out user with re-engagement campaigns. If you anticipate multiple
*  users on the same device, but only want to target one of them when your app is in a logged out state, we recommend
*  separately keeping track of the user ID you want to target while logged out and switching back to
*  that user ID as part of your app's logout process.
*/
- (void) changeUser:(NSString *)userId;

/*!
 * @param eventName The name of the event to log.
 * @discussion Adds an app specific event to event tracking log that's lazily pushed up to the server. Think of
 *   events like counters. That is, each time you log an event, we'll update a counter for that user. Events should be
 *   fairly broad like "beat level 1" or "watched video" instead of something more specific like "watched Katy
 *   Perry's Last Friday Night" so you can create more broad user segments for targeting.
 *
 * <pre>
 * [[Appboy sharedInstance] logCustomEvent:@"clicked_button"];
 * </pre>
 */
- (void) logCustomEvent:(NSString *)eventName;

/*!
 * @param productId A String indicating the product that was purchased.
 * @param price The price of the purchased item in cents.
 * @discussion Adds an in-app purchase to event tracking log that's lazily pushed up to the server
 *
 * <pre>
 * [[Appboy sharedInstance] logPurchase:@"powerups" priceInCents:99];
 * </pre>
 */
- (void) logPurchase:(NSString *)productId priceInCents:(NSUInteger)price;

/*!
* Values representing the Social Networks recognized by the SDK.
*/
typedef enum {
  ABKSocialNetworkFacebook = 1 << 0,
  ABKSocialNetworkTwitter = 1 << 1
} ABKSocialNetwork;

/*!
* @param socialNetwork An ABKSocialNetwork indicating the network that you wish to access.
* @discussion Records that the current user shared something to social network. This is added to the event tracking log
*   that's lazily pushed up to the server.
*/
- (void) logSocialShare:(ABKSocialNetwork)socialNetwork;

/*!
* @param socialNetworks An ABKSocialNetwork indicating the network that you wish to access.
* @discussion Use this method to prompt the user for permission to use social network data (you don't need to use it
* if permission has has been given at another point in your app -- Appboy is already collecting data).
*
* After permission is given, Appboy starts collecting any social network data available on the device (e.g. name, e-mail, etc.)
* and reporting it to the server.
*
* We generally advise that you don't call this method on startup, as it will immediately prompt your users for
* Twitter access.
*
* Notes:
*   For ABKSocialNetworkTwitter:
*   This only works for iOS5 and higher. In older versions, this method is a no-op.
*
*   For ABKSocialNetworkFacebook:
*   This requires your Facebook App ID, which you enter in your app's plist under the key "FacebookAppID".
*   Also, you must have configured a Facebook app with your bundle ID. For more help, see "Create a Facebook App" at
*   https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
*   Calls to this method without a defined FacebookAppID will NSLog an error and do nothing.
*
*   It is highly recommended that you also install the Facebook iOS SDK in your app. If you include the Facebook SDK
*   in your app, this method will work for all iOS versions and provide a high-quality integration experience for the
*   end user. If you do not include the Facebook SDK, this method call will only work on iOS6 or higher.
*/
- (void) promptUserForAccessToSocialNetwork:(ABKSocialNetwork)socialNetwork;

/*!
 * If there are slideups available in the slideup queue, attempt to display one.  This would normally be called sometime
 * after your shouldDisplaySlideup delegate indicated that slideups should be queued. See below for
 * details of queuing and displaying slideups.
 */
- (void) displayNextAvailableSlideup;

@end


/* ------------------------------------------------------------------------------------------------------
 * Protocols
 */

/*!
 * Return values for shouldDisplaySlideup
 *   ABKSlideupShouldShowImmediately - Display arriving slideups immediately, bypassing slideups which may be queued.
 *                                     If the slideup cannot be displayed, it is queued.
 *   ABKSlideupShouldIgnore - Completely discard arriving slideups.
 *   ABKSlideupShouldQueue - Queue arriving slideups for later display
 *
 * Slideup queuing:
 *
 * Arriving slideups are queued when they can't be displayed for one of these reasons:
 * - Another slideup is visible
 * - The keyboard is up
 * - A feed view is being displayed as the result of a prior slideup being tapped
 * - If the shouldDisplaySlideup delegate method returned ABKSlideupShouldQueue
 *
 * Slideups are potentially dequeued and displayed when:
 * - Another slideup arrives
 * - The application comes to the foreground after being backgrounded
 * - A slideup tap-initiated feed view closes
 * - displayNextAvailableSlideup is called
 *
 * If one of these events occurs and the slideup can't be displayed, it remains in the queue.
 *
 * Note that if you unset the slideupDelegate after some slideups have been queued, the accumulated queued slideups
 * will be displayed according to the above scheme.
 */
typedef enum {
  ABKSlideupShouldShowImmediately,
  ABKSlideupShouldIgnore,
  ABKSlideupShouldQueue
} ABKSlideupShouldDisplaySlideupReturnType;

/*!
 * The slideupDelegate has two uses:
 *
 * First, when a slideup has been received from the server, shouldDisplaySlideup is called.  The host can
 * decide if the slideup should be shown immediately, queued, or ignored (see above).
 *
 * Second, when a slideup is tapped, the default action is to open an ABKFeedViewControllerModalContext.
 * If slideupDelegate is set, however, the ABKFeedViewControllerModalContext is not opened;
 * instead, a message is sent to the slideupDelegate which can be used to trigger some other action.
 */
@protocol ABKSlideupControllerDelegate <NSObject>
@optional

/*!
 * @param message The text of the slideup's message.
 * @discussion Sent when a slideup has arrived from the server. 
 */
- (ABKSlideupShouldDisplaySlideupReturnType) shouldDisplaySlideup:(NSString *)message;

/*!
 * Called when the Appboy Slideup is tapped by the user.
 */
- (void) slideupWasTapped;
@end
