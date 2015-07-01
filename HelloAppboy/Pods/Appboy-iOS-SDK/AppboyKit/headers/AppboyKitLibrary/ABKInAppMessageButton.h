#import "ABKInAppMessage.h"

/*
 * Appboy Public API: ABKInAppMessageButton
 */
@interface ABKInAppMessageButton : UIButton

/*!
 * This property defines the button title text in UIControlStateNormal. Setting this property will also change the button
 * title text.
 */
@property (nonatomic, copy) NSString *buttonText;

/*!
 * This property defines the button's background color.
 */
@property (nonatomic, retain) UIColor *buttonBackgroundColor;

/*!
 * This property defines the button's title color in UIControlStateNormal. Setting this property will also change the
 * button title color.
 */
@property (nonatomic, retain) UIColor *buttonTextColor;

/*!
 * This property defines the action that will be performed when the button is clicked.
 * See the ABKInAppMessageClickActionType enum documentation in ABKInAppMessage.h offers additional details.
 */
@property (nonatomic, assign, readonly) ABKInAppMessageClickActionType buttonClickActionType;

/*!
 * When the button's buttonClickActionType is ABKInAppMessageRedirectToURI, clicking on the button will redirect to the uri
 * defined in this property.
 *
 * This property can be a HTTP URI or a protocol URI.
 */
@property (nonatomic, copy, readonly) NSURL *buttonClickedURI;

/*!
 * This property defines the button's ID. Button's ID is used to track user's clicking action and used for corresponding
 * data analytics.
 */
@property (nonatomic, assign, readonly) NSInteger buttonID;

/*!
 * This method will set the buttonClickActionType property.
 *
 * When clickActionType is ABKInAppMessageRedirectToURI, the parameter uri cannot be nil, and the value will be passed to
 * buttonClickedURI. When clickActionType is ABKInAppMessageDisplayNewsFeed or ABKInAppMessageNoneClickAction, the
 * parameter uri will be ignored, and property uri  will be set to nil.
 */
- (void) setButtonClickAction:(ABKInAppMessageClickActionType)clickActionType withURI:(NSURL *)uri;

@end
