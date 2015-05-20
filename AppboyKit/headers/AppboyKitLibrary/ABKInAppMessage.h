#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * The ABKInAppMessageClickActionType defines the action that will be performed when the in-app message is clicked.
 *
 *   ABKInAppMessageDisplayNewsFeed - This is the default behavior. It will open a modal view of Appboy news feed.
 *
 *   ABKInAppMessageRedirectToURI - The in-app message will try to redirect to the uri defined by the uri property. Only when the uri
 *    is an HTTP URL, a modal web view will be displayed. If the uri is a protocol uri, the in-app message will redirect to the
 *    protocol uri.
 *
 *   ABKInAppMessageNoneClickAction - The in-app message will do nothing but dismiss itself.
 */
typedef NS_ENUM(NSInteger, ABKInAppMessageClickActionType) {
  ABKInAppMessageDisplayNewsFeed,
  ABKInAppMessageRedirectToURI,
  ABKInAppMessageNoneClickAction
};

/*!
 * The ABKInAppMessageDismissType defines how the in-app message can be dismissed.
 *
 *   ABKInAppMessageDismissAutomatically - This is the default behavior for ABKInAppMessageSlideup.
 *     It will dismiss after the length of time defined by the duration property. 
 *     ABKInAppMessageSlideup of this type can also be dismissed by swiping.
 *
 *   ABKInAppMessageDismissManually - This is the default behavior for ABKInAppMessageImmersive. The
 *     in-app message will stay on the screen indefinitely unless dismissed by swiping or a click on
 *     the close button.
 */
typedef NS_ENUM(NSInteger, ABKInAppMessageDismissType) {
  ABKInAppMessageDismissAutomatically,
  ABKInAppMessageDismissManually
};

/*
 * Appboy Public API: ABKInAppMessage
 */
@interface ABKInAppMessage : NSObject

/*!
 * This property defines the message displayed within the in-app message.
 */
@property (nonatomic, copy) NSString *message;

/*!
 * This property carries extra data in the form of an NSDictionary which can be sent down via the Appboy Dashboard.
 * You may want to design and implement a custom handler to access this data depending on your use-case.
 */
@property (nonatomic, retain) NSDictionary *extras;

/*!
 * This property defines the number of seconds before the in-app message is automatically dismissed.
 */
@property (nonatomic, assign) NSTimeInterval duration;

/*!
 * This property defines the action that will be performed when the in-app message is clicked.
 * See the ABKInAppMessageClickActionType enum documentation above offers additional details.
 */
@property (nonatomic, assign, readonly) ABKInAppMessageClickActionType inAppMessageClickActionType;

/*!
 * When the in-app message's inAppMessageClickActionType is ABKInAppMessageRedirectToURI, clicking on the in-app message will redirect to the uri defined
 * in this property.
 *
 * This property can be a HTTP URI or a protocol URI.
 */
@property (nonatomic, copy, readonly) NSURL *uri;

/*!
 * inAppMessageDismissType defines the dismissal behavior of the in-app message.
 * See the above documentation for ABKInAppMessageDismissType for additional details.
 */
@property (nonatomic, assign) ABKInAppMessageDismissType inAppMessageDismissType;

/*!
 * backgroundColor defines the background color of the in-app message. The default background color is black with 0.9 alpha for
 * ABKInAppMessageSlideup, and white with 1.0 alpha for ABKInAppMessageModal and ABKInAppMessageFull.
 */
@property (nonatomic, retain) UIColor *backgroundColor;

/*!
 * textColor defines the message text color of the in-app message. The default text color is black.
 */
@property (nonatomic, retain) UIColor *textColor;

/*!
 * icon defines the font awesome unicode string of the Appboy icon.
 * You can choose to display one of the Appboy icons from Appboy dashboard. When you do so, this property will have the
 * unicode string of font awesome.
 */
@property (nonatomic, retain) NSString *icon;

/*!
 * iconColor defines the font color of icon property.
 * The default font color is white.
 */
@property (nonatomic, retain) UIColor *iconColor;

/*!
 * iconBackgroundColor defines the background color of icon property.
 *  * The default background color's RGB values are R:0 G:115 B:213.
 */
@property (nonatomic, retain) UIColor *iconBackgroundColor;

/*!
 * imageURI defines the URI of the image icon on in-app message.
 * When there is a iconImage defined, the iconImage will be used and the value of property icon will 
 * be ignored.
 */
@property (nonatomic, copy) NSURL *imageURI;

/*!
 * If you're handling in-app messages completely on your own (returning YES from onInAppMessageReceived), you should still report
 * impressions and clicks on the in-app message back to Appboy with these methods so that your campaign reporting features
 * still work in the dashboard.
 *
 * Note: Each in-app message can log at most one impression and at most one click.
 */
- (void) logInAppMessageImpression;
- (void) logInAppMessageClicked;

/*!
 * This method will set the inAppMessageClickActionType property.
 *
 * When clickActionType is ABKInAppMessageRedirectToURI, the parameter uri cannot be nil. When clickActionType is
 * ABKInAppMessageDisplayNewsFeed or ABKInAppMessageNoneClickAction, the parameter uri will be ignored, and property uri
 * will be set to nil.
 */
- (void) setInAppMessageClickAction:(ABKInAppMessageClickActionType)clickActionType withURI:(NSURL *)uri;

/*!
 * Serializes the in-app message to binary data for use by wrappers such as Appboy's Unity SDK for iOS.
 */
- (NSData *) serializeToData;

@end
