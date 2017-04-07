//
//  Appboy.h
//  AppboySDK
//
//  Copyright (c) 2016 Appboy. All rights reserved.

/*!
  \mainpage
  This site contains technical documentation for the %Appboy iOS SDK. Click on the "Classes" link above to
  view the %Appboy public interface classes and start integrating the SDK into your app!
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#ifndef APPBOY_SDK_VERSION
#define APPBOY_SDK_VERSION @"2.29.0"
#endif

#if !TARGET_OS_TV
@class ABKInAppMessageController;
@class ABKInAppMessage;
@class ABKInAppMessageViewController;
#endif

@class ABKUser;
@class ABKFeedController;
@class ABKLocationManager;
@class ABKFeedback;
@protocol ABKInAppMessageControllerDelegate;
@protocol ABKIDFADelegate;
@protocol ABKAppboyEndpointDelegate;
@protocol ABKPushURIDelegate;
@protocol ABKURLDelegate;

NS_ASSUME_NONNULL_BEGIN
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
 * Sets the data flush interval (in seconds). This only has an effect when the request processing mode is set to
 * ABKAutomaticRequestProcessing (which is the default). Values are converted into NSTimeIntervals and must be greater
 * than 1.0.
 */
extern NSString *const ABKFlushIntervalOptionKey;

/*!
 * This key can be set to YES or NO and will configure whether Appboy will automatically collect location (if the user permits).
 * If set to YES, location will not be recorded for the user unless integrating apps manually call setUserLastKnownLocation on
 * ABKUser (i.e. you must manually set the location, Appboy will not).  If it is set to NO or omitted, Appboy will collect
 * location if authorized.
 */
extern NSString *const ABKDisableAutomaticLocationCollectionKey;

/*!
 * This key can be set to YES or NO and will configure whether Appboy will automatically collect significant change location
 * events.  If this key isn't set and the server doesn't provide a value, it will default to false.
 */
extern NSString *const ABKSignificantChangeCollectionEnabledOptionKey;

/*!
 * This key can be set to an integer value that represents the minimum distance in meters between location events logged to Appboy.
 * If this value is set and significant change location is enabled, this value will be used to filter locations that are received from the significant
 * change location provider.  The default and minimum value is 50.  Note that significant change location updates shouldn't occur if the user has
 * gone 50 meters or less.
 */
extern NSString *const ABKSignificantChangeCollectionDistanceFilterOptionKey;

/*!
 * This key can be set to an integer value that represents the minimum time in seconds between location events logged to Appboy.
 * If this value is set and significant change location is enabled, this value will be used to filter locations that are received from the significant
 * change location provider.  The default value is 3600 (1 hour); the minimum is 300 (5 minutes).
 */
extern NSString *const ABKSignificantChangeCollectionTimeFilterOptionKey;

/*!
 * This key can be set to an instance of a class that extends ABKIDFADelegate, which can be used to pass advertiser tracking information to to Appboy.
 */
extern NSString *const ABKIDFADelegateKey;

/*!
 * This key can be set to an instance of a class that conforms to the ABKAppboyEndpointDelegate protocol, which can be used to modify or substitute the API and Resource
 * (e.g. image) URIs used by the Appboy SDK.
 */
extern NSString *const ABKAppboyEndpointDelegateKey;

/*!
 * This key can be set to an instance of a class that conforms to the ABKPushURIDelegate protocol, which can be used to handle deep linking
 * in push in a custom way.
 */
extern NSString *const ABKPushURIDelegateKey __deprecated_msg("ABKPushURIDelegate is deprecated, please use the ABKURLDelegate protocol instead.");

/*!
 * This key can be set to an instance of a class that conforms to the ABKURLDelegate protocol, allowing it to handle URLs in a custom way.
 */
extern NSString *const ABKURLDelegateKey;

/*!
 * This key can be set to an instance of a class that conforms to the ABKInAppMessageControllerDelegate protocol, allowing it to handle in-app messages in a custom way.
 */
extern NSString *const ABKInAppMessageControllerDelegateKey;

/*!
 * Set the time interval for session time out (in seconds). This will affect the case when user has a session shorter than
 * the set time interval. In that case, the session won't be close even though the user closed the app, but will continue until
 * it times out. The value should be an integer bigger than 0.
 */
extern NSString *const ABKSessionTimeoutKey;

/*!
 * Set the minimum time interval in seconds between triggers. After a trigger happens, we will ignore any triggers until
 * the minimum time interval elapses. The default value is 30s.
 */
extern NSString *const ABKMinimumTriggerTimeIntervalKey;

/*!
 * Key to report the SDK flavor currently being used.  For internal use only.
 */
extern NSString *const ABKSDKFlavorKey;

/* ------------------------------------------------------------------------------------------------------
 * Enums
 */

/*!
 * Possible values for the SDK's request processing policies:
 *   ABKAutomaticRequestProcessing (default) - All server communication is handled automatically. This includes flushing
 *        analytics data to the server, updating the feed, requesting new in-app messages and posting feedback. Appboy's
 *        communication policy is to perform immediate server requests when user facing data is required (new in-app messages,
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
 * Internal enum used to report the SDK flavor being used.
 */
typedef NS_ENUM(NSInteger , ABKSDKFlavor) {
  UNITY = 1,
  REACT,
  CORDOVA,
  XAMARIN ,
  SEGMENT,
  MPARTICLE
};

/*!
 * Possible values for the result of submitting feedback:
 *   ABKInvalidFeedback - The passed-in feedback isn't valid. Please check the validity of the ABKFeedback
 *        object with instance method `feedbackValidation` before submitting it to Appboy.
 *   ABKNetworkIssue - The SDK failed to send the feedback due to network issue. 
 *   ABKFeedbackSentSuccessfully - The feedback is sent to Appboy server successfully.
 */
typedef NS_ENUM(NSInteger, ABKFeedbackSentResult) {
  ABKInvalidFeedback,
  ABKNetworkIssue,
  ABKFeedbackSentSuccessfully
};

/*
 * Appboy Public API: Appboy
 */
@interface Appboy : NSObject

/* ------------------------------------------------------------------------------------------------------
 * Initialization
 */

/*!
 * Get the Appboy singleton.  Returns nil if accessed before startWithApiKey: called.
 */
+ (nullable Appboy *)sharedInstance;

/*!
 * Get the Appboy singleton.  Throws an exception if accessed before startWithApiKey: is called.
 */
+ (nonnull Appboy *)unsafeInstance;

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
+ (void)startWithApiKey:(NSString *)apiKey
          inApplication:(UIApplication *)application
      withLaunchOptions:(nullable NSDictionary *)launchOptions;

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
+ (void)startWithApiKey:(NSString *)apiKey
          inApplication:(UIApplication *)application
      withLaunchOptions:(nullable NSDictionary *)launchOptions
      withAppboyOptions:(nullable NSDictionary *)appboyOptions;

/* ------------------------------------------------------------------------------------------------------
 * Properties
 */

/*!
 * The current app user.
 * See ABKUser.h and changeUser:userId below.
 */
@property (readonly) ABKUser *user;

@property (readonly) ABKFeedController *feedController;

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
@property ABKRequestProcessingPolicy requestProcessingPolicy;


/*!
 * A class conforming to the ABKAppboyEndpointDelegate protocol can be set to route Appboy API and Resource traffic in a custom way.
 * For example, one might proxy Appboy image downloads by having the getResourceEndpoint method return a proxy URI.
 */
@property (nonatomic, weak, nullable) id<ABKAppboyEndpointDelegate> appboyEndpointDelegate;

/*!
 * A class extending ABKIDFADelegate can be set to provide the IDFA to Appboy.
 */
@property (nonatomic, strong, nullable) id<ABKIDFADelegate> idfaDelegate;

#if !TARGET_OS_TV
/*!
 * The current in-app message manager.
 * See ABKInAppMessageController.h.
 */
@property (readonly) ABKInAppMessageController *inAppMessageController;

/*!
 * The Appboy location manager provides access to location related functionality in the Appboy SDK.
 * See ABKLocationManager.h.
 */
@property (nonatomic, readonly) ABKLocationManager *locationManager;

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
@property (nonatomic) BOOL useNUITheming;

/*!
 * A class conforming to the ABKPushURIDelegate protocol can be set to handle deep linking in push in a custom way.
 */
@property (nonatomic, weak, nullable) id<ABKPushURIDelegate> appboyPushURIDelegate __deprecated_msg("Use appboyURLDelegate instead.");

/*!
 * A class conforming to the ABKURLDelegate protocol can be set to handle URLs in a custom way.
 */
@property (nonatomic, weak, nullable) id<ABKURLDelegate> appboyUrlDelegate;

/*!
 * Property for internal reporting of SDK flavor.
 */
@property (nonatomic) ABKSDKFlavor sdkFlavor;
#endif

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
 * * Retrieving an updated feed and in-app message after a new session is opened or the user is changed. Appboy will
 * automatically add the request for new data to the network queue, you just need to give it permission to execute
 * that request.
 * * Flushing updated user data (custom events, custom attributes, as well as automatically collected data).
 * * Flushing automatic analytics events such as starting and ending sessions.
 *
 * If you're using ABKAutomaticRequestProcessingExceptForDataFlush, you only need to call this when you want to force
 * an immediate flush of updated user data.
 */
- (void)flushDataAndProcessRequestQueue;

/*!
 * Stops all in flight server communication and enables manual request processing control to ensure that no automatic
 * network activity occurs. You should usually only call shutdownServerCommunication if the OS is forcing you to stop
 * background tasks upon exit of your application. To continue normal operation after calling this, you will need to
 * explicitly set the request processing mode back to your desired state.
 */
- (void)shutdownServerCommunication;

/*!
* @param userId The new user's ID (from the host application).
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
*     Appboy will also automatically make a data refresh request to get the news feed, in-app message and other information
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
- (void)changeUser:(NSString *)userId;

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
- (void)logCustomEvent:(NSString *)eventName;

/*!
 * @param eventName The name of the event to log.
 * @param properties An <code>NSDictionary</code> of properties to associate with this purchase. Property keys are non-empty <code>NSString</code> objects with
 * <= 255 characters and no leading dollar signs.  Property values can be <code>NSNumber</code> booleans, integers, floats < 62 bits, <code>NSDate</code> objects or
 * <code>NSString</code> objects with <= 255 characters.
 *
 * @discussion Adds an app specific event to event tracking log that's lazily pushed up to the server. Think of
 *   events like counters. That is, each time you log an event, we'll update a counter for that user. Events should be
 *   fairly broad like "beat level 1" or "watched video" instead of something more specific like "watched Katy
 *   Perry's Last Friday Night" so you can create more broad user segments for targeting.
 *
 * <pre>
 * [[Appboy sharedInstance] logCustomEvent:@"clicked_button" properties:@{@"key1":@"val"}];
 * </pre>
 */
- (void)logCustomEvent:(NSString *)eventName withProperties:(nullable NSDictionary *)properties;

/*!
 * This method is equivalent to calling logPurchase:inCurrency:atPrice:withQuantity:andProperties: with a quantity of 1 and nil properties.
 * Please see logPurchase:inCurrency:atPrice:withQuantity:andProperties: for more information.
 *
 */
- (void)logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price;

/*!
 * This method is equivalent to calling logPurchase:inCurrency:atPrice:withQuantity:andProperties with a quantity of 1.
 * Please see logPurchase:inCurrency:atPrice:withQuantity:andProperties: for more information.
 *
 */
- (void)logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withProperties:(nullable NSDictionary *)properties;

/*!
 * This method is equivalent to calling logPurchase:inCurrency:atPrice:withQuantity:andProperties with nil properties.
 * Please see logPurchase:inCurrency:atPrice:withQuantity:andProperties: for more information.
 *
 */
- (void)logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity;

/*!
 * @param productIdentifier A String indicating the product that was purchased. Usually the product identifier in the
 * iTunes store.
 * @param currencyCode Currencies should be represented as an ISO 4217 currency code. Prices should
 * be sent in decimal format, with the same base units as are provided by the SKProduct class. Callers of this method
 * who have access to the NSLocale object for the purchase in question (which can be obtained from SKProduct listings
 * provided by StoreKit) can obtain the currency code by invoking:
 * <pre>[locale objectForKey:NSLocaleCurrencyCode]</pre>
 * Supported currency symbols include: AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BHD, BIF, 
 * BMD, BND, BOB, BRL, BSD, BTC, BTN, BWP, BYR, BZD, CAD, CDF, CHF, CLF, CLP, CNY, COP, CRC, CUC, CUP, CVE, CZK, DJF, 
 * DKK, DOP, DZD, EEK, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GGP, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, 
 * IDR, ILS, IMP, INR, IQD, IRR, ISK, JEP, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, 
 * LSL, LTL, LVL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRO, MTL, MUR, MVR, MWK, MXN, MYR, MZN, NAD, NGN, NIO, NOK, NPR, 
 * NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL, SOS, SRD, 
 * STD, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UAH, UGX, USD, UYU, UZS, VEF, VND, VUV, WST, XAF, XAG, 
 * XAU, XCD, XDR, XOF, XPD, XPF, XPT, YER, ZAR, ZMK, ZMW and ZWL. Any other provided currency symbol will result in a logged 
 * warning and no other action taken by the SDK.
 * @param price Prices should be reported as NSDecimalNumber objects. Base units are treated the same as with SKProduct
 * from StoreKit and depend on the currency. As an example, USD should be reported as Dollars.Cents, whereas JPY should
 * be reported as a whole number of Yen. All provided NSDecimalNumber values will have NSRoundPlain rounding applied
 * such that a maximum of two digits exist after their decimal point.
 * @param quantity An unsigned number to indicate the purchase quantity. This number must be greater than 0 but no larger than 100.
 * @param properties An <code>NSDictionary</code> of properties to associate with this purchase. Property keys are non-empty <code>NSString</code> objects with
 * <= 255 characters and no leading dollar signs.  Property values can be <code>NSNumber</code> integers, floats, booleans < 62 bits in length, <code>NSDate</code> objects or
 * <code>NSString</code> objects with <= 255 characters.
 *
 * @discussion Logs a purchase made in the application.
 *
 * Note: Appboy supports purchases in multiple currencies. Purchases that you report in a currency other than USD will
 * be shown in the dashboard in USD based on the exchange rate at the date they were reported.
 *
 */
- (void)logPurchase:(NSString *)productIdentifier inCurrency:(NSString *)currencyCode atPrice:(NSDecimalNumber *)price withQuantity:(NSUInteger)quantity andProperties:(nullable NSDictionary *)properties;

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
- (BOOL)submitFeedback:(NSString *)replyToEmail message:(NSString *)message isReportingABug:(BOOL)isReportingABug;

/*!
 * @param feedback The feedback object with feedback message, email, and is-bug flag.
 * @param completionHandler The block to execute when the feedback sending process is complete. An ABKFeedbackSentResult enum
 * will be passed to the block indicating if the feedback was sent successfully.
 *
 * @discussion Submits a piece of feedback to the Appboy feedback center so that it can be handled in the Appboy dashboard.
 * The request to submit feedback is made immediately. However, this method does not block and will return as soon as the
 * feedback request is placed on the network queue.
 *
 */
- (void)submitFeedback:(ABKFeedback *)feedback withCompletionHandler:(nullable void (^)(ABKFeedbackSentResult feedbackSentResult))completionHandler;

/*!
 * If you're displaying cards on your own instead of using ABKFeedViewController, you should still report impressions of
 * the news feed back to Appboy with this method so that your campaign reporting features still work in the dashboard.
 */
- (void)logFeedDisplayed;

/*!
 * If you're displaying feedback page on your own instead of using ABKFeedbackViewController, you should still report
 * impressions of the feedback page back to Appboy with this method so that your campaign reporting features still work
 * in the dashboard.
 */
- (void)logFeedbackDisplayed;

/*!
 * Enqueues a news feed request for the current user. Note that if the queue already contains another request for the
 * current user, that the new feed request will be merged into the already existing request and only one will execute
 * for that user.
 *
 * When the new cards for news feed return from Appboy server, the SDK will post an ABKFeedUpdatedNotification with an
 * ABKFeedUpdatedIsSuccessfulKey in the notification's userInfo dictionary to indicate if the news feed request is successful
 * or not. For more detail about the ABKFeedUpdatedNotification and the ABKFeedUpdatedIsSuccessfulKey, please check ABKFeedController.
 */
- (void)requestFeedRefresh;

#if !TARGET_OS_TV
/*!
 * Enqueues an in-app message request for the current user. Note that if the queue already contains another request for the
 * current user, that the in-app message request will be merged into the already existing request and only one will execute
 * for that user.
 */
- (void)requestInAppMessageRefresh;

/*!
 * @param response The response passed in from userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:.
 *
 * @discussion This method returns whether or not a UNNotification was sent from Appboy's servers.
 */
- (BOOL)userNotificationWasSentFromAppboy:(UNNotificationResponse *)response __deprecated_msg("Use [ABKPushUtils isAppboyUserNotification:] instead.");

/*!
 * @param options The NSDictionary you get from application:didFinishLaunchingWithOptions or
 * application:didReceiveRemoteNotification in your App Delegate.
 *
 * @discussion
 * Test a push notification to see if it came Appboy's servers.
 */
- (BOOL)pushNotificationWasSentFromAppboy:(NSDictionary *)options __deprecated_msg("Use [ABKPushUtils isAppboyRemoteNotification:] instead.");

/*!
 * @param token The device's push token.
 *
 * @discussion This method posts a token to Appboy's servers to associate the token with the current device.
 */
- (void)registerPushToken:(NSString *)token;

/*!
 * @param application The app's UIApplication object
 * @param notification An NSDictionary passed in from the didReceiveRemoteNotification call
 *
 * @discussion This method forwards remote notifications to Appboy. Call it from the application:didReceiveRemoteNotification
 * method of your App Delegate.
 */
- (void)registerApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification NS_DEPRECATED_IOS(3_0, 10_0, "`registerApplication:didReceiveRemoteNotification:` is deprecated in iOS 10, please use `registerApplication:didReceiveRemoteNotification:fetchCompletionHandler:` instead.");

/*!
 * @param application The app's UIApplication object
 * @param notification An NSDictionary passed in from the didReceiveRemoteNotification:fetchCompletionHandler: call
 * @param completionHandler A block passed in from the didReceiveRemoteNotification:fetchCompletionHandler: call
 *
 * @discussion This method forwards remote notifications to Appboy. If the completionHandler is passed in when
 * the method is called, Appboy will call the completionHandler. However, if the completionHandler is not passed in,
 * it is the host app's responsibility to call the completionHandler.
 * Call it from the application:didReceiveRemoteNotification:fetchCompletionHandler: method of your App Delegate.
 */
- (void)registerApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)notification
     fetchCompletionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler;

/*!
 * @param identifier The action identifier passed in from the handleActionWithIdentifier:forRemoteNotification:.
 * @param userInfo An NSDictionary passed in from the handleActionWithIdentifier:forRemoteNotification: call.
 * @param completionHandler A block passed in from the didReceiveRemoteNotification:fetchCompletionHandler: call
 *
 * @discussion This method forwards remote notifications and the custom action chosen by user to Appboy. Call it from
 * the application:handleActionWithIdentifier:forRemoteNotification: method of your App Delegate.
 */
- (void)getActionWithIdentifier:(NSString *)identifier
          forRemoteNotification:(NSDictionary *)userInfo
              completionHandler:(nullable void (^)())completionHandler NS_DEPRECATED_IOS(8_0, 10_0,"`getActionWithIdentifier:forRemoteNotification:completionHandler:` is deprecated in iOS 10, please use `userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:` instead.");

/*!
 * @param center The app's current UNUserNotificationCenter object
 * @param response The UNNotificationResponse object passed in from the didReceiveNotificationResponse:withCompletionHandler: call
 * @param completionHandler A block passed in from the didReceiveNotificationResponse:withCompletionHandler: call. Appboy will call
 * it at the end of the method if one is passed in. If you prefer to handle the completionHandler youself, please pass nil to Appboy.
 *
 * @discussion This method forwards the response of the notification to Appboy after user interacted with the notification.
 * Call it from the userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: method of your App Delegate.
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
      withCompletionHandler:(nullable void (^)())completionHandler;

/*!
 * @param pushAuthGranted The boolean value passed in from completionHandler in UNUserNotificationCenter's 
 * requestAuthorizationWithOptions:completionHandler: method, which indicates if the push authorization
 * was granted or not.
 *
 * @discussion This method forwards the push authorization result to Appboy after the user interacts with
 * the notification prompt.
 * Call it from the UNUserNotificationCenter's requestAuthorizationWithOptions:completionHandler: method 
 * when you prompt users to enable push.
 */
- (void)pushAuthorizationFromUserNotificationCenter:(BOOL)pushAuthGranted;

#endif

@end
NS_ASSUME_NONNULL_END
