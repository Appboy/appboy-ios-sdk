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

#ifndef APPBOY_SDK_VERSION
#define APPBOY_SDK_VERSION @"2.9.2"
#endif

@class ABKSlideupController;
@class ABKFeedController;
@class ABKUser;
@class ABKSlideup;
@class ABKSlideupViewController;
@protocol ABKSlideupControllerDelegate;

@interface Appboy : NSObject

/* ------------------------------------------------------------------------------------------------------
 * Initialization
 */

/*!
 * Get the Appboy singleton.
 */
+ (Appboy *) sharedInstance;

/*!
 * @param apiKey The app's API key
 * @param inApplication The current app
 * @param withLaunchOptions The options NSDictionary that you get from application:didFinishLaunchingWithOptions
 *
 * @discussion Starts up Appboy and tells it that your app is done launching. You should call this
 * method in your App Delegate application:didFinishLaunchingWithOptions method before calling makeKeyAndVisible,
 * accessing [Appboy sharedInstance] or otherwise rendering Appboy view controllers. Your apiKey comes from
 * the appboy.com dashboard where you registered your app.
 */
+ (void) startWithApiKey:(NSString *)apiKey
           inApplication:(UIApplication *)application
       withLaunchOptions:(NSDictionary *)launchOptions;

/*!
 * @param apiKey The app's API key
 * @param inApplication The current app
 * @param withLaunchOptions The options NSDictionary that you get from application:didFinishLaunchingWithOptions
 * @param appboyOptions An optional NSDictionary with startup configuration values for Appboy. This currently supports
 * ABKRequestProcessingPolicyOptionKey, ABKSocialAccountAcquisitionPolicyOptionKey and ABKFlushIntervalOptionKey. See below
 * for more information.
 *
 * @discussion Starts up Appboy and tells it that your app is done launching. You should call this
 * method in your App Delegate application:didFinishLaunchingWithOptions method before calling makeKeyAndVisible,
 * accessing [Appboy sharedInstance] or otherwise rendering Appboy view controllers. Your apiKey comes from
 * the appboy.com dashboard where you registered your app.
 */
+ (void) startWithApiKey:(NSString *)apiKey
           inApplication:(UIApplication *)application
       withLaunchOptions:(NSDictionary *)launchOptions
       withAppboyOptions:(NSDictionary *)appboyOptions;

/* ------------------------------------------------------------------------------------------------------
 * Keys for Appboy startup options
 */

/*!
* If you want to set the request policy at app startup time (useful for avoiding any automatic data requests made by
* Appboy at startup if you're looking to have full manual control). You can include one of the
* ABKRequestProcessingPolicy enum values as the value for the ABKRequestProcessingPolicyOptionKey in the appboyOptions
* dictionary.
*/
extern NSString *const ABKRequestProcessingPolicyOptionKey;

/*!
* If you want to set the social account acquisition policy at app startup time (useful for avoiding automatic
* social account data requests made by Appboy at startup). You can include one of the ABKSocialAccountAcquisitionPolicy
* enum values as the value for the ABKSocialAccountAcquisitionPolicyOptionKey in the appboyOptions dictionary.
*/
extern NSString *const ABKSocialAccountAcquisitionPolicyOptionKey;

/*!
 * Sets the data flush interval (in seconds). This only has an effect when the request processing mode is set to
 * ABKAutomaticRequestProcessing (which is the default). Values are converted into NSTimeIntervals and must be greater
 * than 1.0.
 */
extern NSString *const ABKFlushIntervalOptionKey;

/*!
 * This key can be set to YES or NO and will configure whether Appboy will automatically collect location (if the user permits).
 * If set to YES,location will not be recorded for the user unless integrating apps manually call setUserLastKnownLocation on
 * ABKUser (i.e. you must manually set the location, Appboy will not).  If it is set to NO or omitted, Appboy will collect
 * location if authorized.
 */
extern NSString *const ABKDisableAutomaticLocationCollectionKey;


/* ------------------------------------------------------------------------------------------------------
 * Enums
 */

/*!
* Possible values for the SDK's request processing policies:
*   ABKAutomaticRequestProcessing (default) - All server communication is handled automatically. This includes flushing
*        analytics data to the server, updating the feed, requesting new slideups and posting feedback. Appboy's
*        communication policy is to perform immediate server requests when user facing data is required (new slideups,
*        feed refreshes, etc.), and to otherwise perform periodic flushes of new analytics data every few seconds.
*        The interval between periodic flushes can be set explicitly using the ABKFlushInterval startup option.
*   ABKAutomaticRequestProcessingExceptForDataFlush - The same as ABKAutomaticRequestProcessing, except that updates to
*        custom attributes and triggering of custom events will not automatically flush to the server. Instead, you
*        must call flushDataAndProcessRequestQueue when you want to synchronize newly updated user data with Appboy.
*   ABKManualRequestProcessing - Appboy will automatically add appropriate network requests (feed updates, user
*        attribute flushes, feedback posts, etc.) to its network queue, but doesn't process
*        network requests except when feedback requests are made via a FeedbackViewController, or a feed request is made
*        via a FeedViewController. The latter typically occurs when a ABKFeedViewController is loaded and displayed on
*        the screen, for example, in response to a user click.
*        You can direct Appboy to perform an immediate data flush as well as process any other
*        requests on its queue by calling <pre>[[Appboy sharedInstance] flushDataAndProcessRequestQueue];</pre>
*        This mode is only recommended for advanced use cases. If you're merely trying to
*        control the background flush behavior, consider using ABKAutomaticRequestProcessing
*        with a custom flush interval or ABKAutomaticRequestProcessingExceptForDataFlush.
*
* Regardless of policy, Appboy will intelligently combine requests on the queue to minimize the total number of
* requests and their combined payload.
*/
typedef NS_ENUM(NSInteger, ABKRequestProcessingPolicy) {
  ABKAutomaticRequestProcessing,
  ABKAutomaticRequestProcessingExceptForDataFlush,
  ABKManualRequestProcessing
};

/*!
* Possible values for the SDK's social account acquisition policies:
*   ABKAutomaticSocialAccountAcquisition (default) - At app startup and after you've set a social account identifier
*       on the user object, Appboy will automatically attempt to fetch Twitter and Facebook social account data
*       for the user and flush it to the server. In all cases, Appboy's automatic data acquisition will ensure that the
*       user is not prompted or that the UI of your application is otherwise affected. For this reason, when Appboy
*       tries to perform the data acquisition, your app must have already been granted the relevant permissions to
*       obtain social account data. If you've specified the twitterAccountIdentifier, Appboy will only attempt to grab
*       data for that twitter account. If you haven't specified it, Appboy will grab data for the first Twitter account
*       returned by the system. An upcoming release will enable identifier targeting for Facebook as well.
*
*       Note: If you have not integrated the Facebook SDK into your app, there is no way to grab Facebook data without
*       prompting the user, so you must call <pre>[[Appboy sharedInstance] promptUserForAccessToSocialNetwork:ABKSocialNetworkFacebook];</pre>
*       and allow the user to be prompted. If you have integrated the Facebook SDK, you must ensure that the user has
*       allowed read permissions. If permission is granted, Appboy will collect the user's basic public profile info
*       "user_about_me" "email" "user_hometown" "user_birthday" and, if permission is granted, "user_likes".
*   ABKAutomaticSocialAccountAcquisitionWithIdentifierOnly - Appboy will only attempt to obtain social account information when
*       an identifier is set on the user for the corresponding social network. Note: This currently only works for
*       Twitter accounts. An upcoming release will enable identifier targeting for Facebook as well.
*   ABKManualSocialAccountAcquisition - Appboy will NOT try to acquire social account data. You must call
*       <pre>[[Appboy sharedInstance] promptUserForAccessToSocialNetwork:(ABKSocialNetwork)];</pre>
*/
typedef NS_ENUM(NSInteger, ABKSocialAccountAcquisitionPolicy) {
  ABKAutomaticSocialAccountAcquisition,
  ABKAutomaticSocialAccountAcquisitionWithIdentifierOnly,
  ABKManualSocialAccountAcquisition
};

/*!
* Values representing the Social Networks recognized by the SDK.
*/
typedef NS_OPTIONS(NSUInteger, ABKSocialNetwork) {
  ABKSocialNetworkFacebook = 1 << 0,
  ABKSocialNetworkTwitter = 1 << 1
};

/* ------------------------------------------------------------------------------------------------------
 * Properties
 */

@property (nonatomic, retain, readonly) ABKFeedController *feedController;

/*!
 * The current slideup manager.
 * See ABKSlideupController.h.
 */
@property (nonatomic, retain, readonly) ABKSlideupController *slideupController;

/*!
 * The current app user. 
 * See ABKUser.h and changeUser:userId below.
 */
@property (nonatomic, retain, readonly) ABKUser *user;

/*!
 * Appboy UI elements can be themed using the NUI framework. See https://github.com/tombenner/nui and the Appboy docs.
 * To enable NUI, take the following steps:
 *
 * - If your app uses ARC: Get NUI from https://github.com/tombenner/nui
 *
 * - If your app does not use ARC: Get NUI from https://github.com/Appboy/nui which is our fork of NUI that manages its
 *   own memory
 *
 * - Follow the instructions in either repo above to integrate NUI
 *
 * - Create a style sheet called NUIStyle.nss
 * 
 * - Set the property below to YES
 *
 * If useNUITheming is NO, NUI is ignored completely whether or not it's integrated into your app.  Note that
 * you can theme your app and Appboy differently -- Appboy uses NUI independently of your app's use of NUI.
 */
@property (nonatomic, assign) BOOL useNUITheming;

/*!
 * The total number of currently active cards displayed in any feed view. Cards are
 * counted only once even if they appear in multiple feed views.
 * @deprecated This property is now deprecated and will be removed in the future. Please use 
 * [[Appboy sharedInstance].feedController cardCountForCategories:ABKCardCategoryAll] instead.
 */
@property (readonly, nonatomic, assign) NSInteger cardCount __deprecated;

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
 *
 * @deprecated This property is now deprecated and will be removed in the future. Please use
 * [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll] instead.
 */
@property (readonly, nonatomic, assign) NSInteger unreadCardCount __deprecated;

/*!
* The policy regarding processing of network requests by the SDK. See the enumeration values for more information on
* possible options. This value can be set at runtime, or can be injected in at startup via the appboyOptions dictionary.
*
* Any time the request processing policy is set to manual, any scheduled flush of the queue is canceled, but if the
* request queue was already processing, the current queue will finish processing. If you need to cancel in flight
* requests, you need to call <pre>[[Appboy sharedInstance] shutdownServerCommunication]</pre>.
*
* Setting the request policy does not automatically cause a flush to occur, it just allows for a flush to be scheduled
* the next time an eligible request is enqueued. To force an immediate flush after changing the request processing
* policy, invoke <pre>[[Appboy sharedInstance] flushDataAndProcessRequestQueue]</pre>.
*/
@property (nonatomic, assign) ABKRequestProcessingPolicy requestProcessingPolicy;


/* ------------------------------------------------------------------------------------------------------
 * Methods
 */


/*!
 * Enqueues a data flush request for the current user and immediately starts processing the network queue. Note that if
 * the queue already contains another request for the current user, that the new data flush request
 * will be merged into the already existing request and only one will execute for that user.
 *
 * If you're using ABKManualRequestProcessing, you need to call this after each network related activity in your app.
 * This includes:
 * * Retrieving an updated feed and slideup after a new session is opened or the user is changed. Appboy will
 * automatically add the request for new data to the network queue, you just need to give it permission to execute
 * that request.
 * * Flushing updated user data (custom events, custom attributes, as well as automatically collected data).
 * * Flushing automatic analytics events such as starting and ending sessions.
 *
 * If you're using ABKAutomaticRequestProcessingExceptForDataFlush, you only need to call this when you want to force
 * an immediate flush of updated user data.
 */
- (void) flushDataAndProcessRequestQueue;

/*!
 * Stops all in flight server communication and enables manual request processing control to ensure that no automatic
 * network activity occurs. You should usually only call shutdownServerCommunication if the OS is forcing you to stop
 * background tasks upon exit of your application. To continue normal operation after calling this, you will need to
 * explicitly set the request processing mode back to your desired state.
 */
- (void) shutdownServerCommunication;

/*!
 * @param options The NSDictionary you get from application:didFinishLaunchingWithOptions or 
 * application:didReceiveRemoteNotification in your App Delegate.
 *
 * @discussion
 * Test a push notification to see if it came Appboy's servers.
 */
- (BOOL) pushNotificationWasSentFromAppboy:(NSDictionary *)options;

/*!
 * @param token The device's push token.
 *
 * @discussion This method posts a token to Appboy's servers to associate the token with the current device.
 */
- (void) registerPushToken:(NSString *)token;

/*!
 * @param application The app's UIApplication object
 * @param notification An NSDictionary passed in from the didReceiveRemoteNotification call
 *
 * @discussion This method forwards remote notifications to Appboy. Call it from the application:didReceiveRemoteNotification
 * method of your App Delegate.
 */
- (void) registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification;

/*!
 * @param identifier The action identifier passed in from the handleActionWithIdentifier:forRemoteNotification:.
 * @param userInfo An NSDictionary passed in from the handleActionWithIdentifier:forRemoteNotification: call.
 *
 * @discussion This method forwards remote notifications and the custom action chosen by user to Appboy. Call it from
 * the application:handleActionWithIdentifier:forRemoteNotification: method of your App Delegate.
 */
- (void) getActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo;

/*!
* @param userID The new user's ID (from the host application).
*
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
*   - Note that switching from one an anonymous user to an identified user or from one identified user to another is
*     a relatively costly operation. When you request the
*     user switch, the current session for the previous user is automatically closed and a new session is started.
*     Appboy will also automatically make a data refresh request to get the news feed, slideup and other information
*     for the new user.
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
- (void) changeUser:(NSString *)userID;

/*!
 * @param eventName The name of the event to log.
 *
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
 * This method is equivalent to calling logPurchase:inCurrency:atPrice:withQuantity: with a quantity of 1.
 * Please see logPurchase:inCurrency:atPrice:withQuantity: for more information.
 *
 */
- (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price;

/*!
 * @param productIdentifier A String indicating the product that was purchased. Usually the product identifier in the
 * iTunes store.
 * @param currencyCode Currencies should be represented as an ISO 4217 currency code. Prices should
 * be sent in decimal format, with the same base units as are provided by the SKProduct class. Callers of this method
 * who have access to the NSLocale object for the purchase in question (which can be obtained from SKProduct listings
 * provided by StoreKit) can obtain the currency code by invoking:
 * <pre>[locale objectForKey:NSLocaleCurrencyCode]</pre>
 * Supported currency symbols include: USD, CAD, EUR, GBP, JPY, AUD, CHF, NOK, MXN, NZD, CNY, RUB, TRY, INR, IDR, ILS,
 * SAR, ZAR, AED, SEK, HKD, SPD, DKK, and TWD. Any other provided currency symbol will result in a logged warning and
 * no other action taken by the SDK.
 * @param price Prices should be reported as NSDecimalNumber objects. Base units are treated the same as with SKProduct
 * from StoreKit and depend on the currency. As an example, USD should be reported as Dollars.Cents, whereas JPY should
 * be reported as a whole number of Yen. All provided NSDecimalNumber values will have NSRoundPlain rounding applied
 * such that a maximum of two digits exist after their decimal point.
 * @param quantity An unsigned number to indicate the purchase quantity. This number must be greater than 0 but no larger than 100.
 *
 * @discussion Logs a purchase made in the application.
 *
 * Note: Appboy supports purchases in multiple currencies. Purchases that you report in a currency other than USD will
 * be shown in the dashboard in USD based on the exchange rate at the date they were reported.
 *
 */
- (void) logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity;

/*!
* @param socialNetwork An ABKSocialNetwork indicating the network that you wish to access.
*
* @discussion Records that the current user shared something to social network. This is added to the event tracking log
*   that's lazily pushed up to the server.
*/
- (void) logSocialShare:(ABKSocialNetwork)socialNetwork;

/*!
* @param socialNetworks An ABKSocialNetwork indicating the network that you wish to access.
*
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
 * @param replyToEmail The email address to send feedback replies to.
 * @param message The message input by the user. Must be non-null and non-empty.
 * @param isReportingABug Flag indicating whether or not the feedback describes a bug, or is merely a suggestion/question.
 * @return a boolean indicating whether or not the feedback item was successfully queued for delivery.
 *
 * @discussion Submits a piece of feedback to the Appboy feedback center so that it can be handled in the Appboy dashboard.
 * The request to submit feedback is made immediately, however, this method does not block and will return as soon as the
 * feedback request is placed on the network queue.
 *
 */
- (BOOL) submitFeedback:(NSString *)replyToEmail message:(NSString *)message isReportingABug:(BOOL)isReportingABug;

/*!
 * If you're displaying cards on your own instead of using ABKFeedViewController, you should still report impressions of
 * the news feed back to Appboy with this method so that your campaign reporting features still work in the dashboard.
 */
- (void) logFeedDisplayed;

/*!
 * If you're displaying feedback page on your own instead of using ABKFeedbackViewController, you should still report
 * impressions of the feedback page back to Appboy with this method so that your campaign reporting features still work
 * in the dashboard.
 */
- (void) logFeedbackDisplayed;

/*!
 * Enqueues a news feed request for the current user. Note that if the queue already contains another request for the
 * current user, that the new feed request will be merged into the already existing request and only one will execute
 * for that user.
 *
 * When the new cards for news feed return from Appboy server, the SDK will post an ABKFeedUpdatedNotification with an
 * ABKFeedUpdatedIsSuccessfulKey in the notification's userInfo dictionary to indicate if the news feed request is successful
 * or not. For more detail about the ABKFeedUpdatedNotification and the ABKFeedUpdatedIsSuccessfulKey, please check ABKFeedController.
 */
- (void) requestFeedRefresh;

/*!
 * Enqueues a slideup request for the current user. Note that if the queue already contains another request for the
 * current user, that the slideup request will be merged into the already existing request and only one will execute
 * for that user.
 */
- (void) requestSlideupRefresh;
@end
