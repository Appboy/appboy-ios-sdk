#import "ABKInAppMessage.h"

@class ABKInAppMessageButton;

/*
 * Appboy Public API: ABKInAppMessageImmersive
 */
@interface ABKInAppMessageImmersive : ABKInAppMessage

/*!
 * header defines the header text of the in-app message.
 * The header will only be displayed in one line on the default Appboy in-app messages. If the header is more than one
 * line, it will be truncated at the end.
 */
@property (nonatomic, copy) NSString *header;

/*!
 * headerTextColor defines the header text color, when there is a header string in the in-app message. The default text color
 * is black.
 */
@property (nonatomic, retain) UIColor *headerTextColor;

/*!
 * closeButtonColor defines the close button color of the in-app message.
 * When this property is nil, the close button's default color is black.
 */
@property (nonatomic, retain) UIColor *closeButtonColor;

/*!
 * buttons defines the buttons of the in-app message.
 * Each button must be an instance of ABKInAppMessageButton.
 * When there are more than two buttons in the array, only the first two buttons will be displayed in the in-app message.
 * For more information and setting of ABKInAppMessageButton, please see the documentation in ABKInAppMessageButton.h for additional details.
 */
@property (nonatomic, retain, readonly) NSArray *buttons;

/*!
 * @param buttonID The clicked button's button ID for the in-app message. This number can't be negative.
 * If you're handling in-app messages completely on your own (returning YES from onInAppMessageReceived), you should still report
 * clicks on the in-app message button back to Appboy with this method so that your campaign reporting features
 * still work in the dashboard.
 *
 * Note: Each in-app message can log at most one button click.
 */
- (void) logInAppMessageClickedWithButtonID:(NSInteger)buttonID;

/*!
 * @param buttonArray The button array for the in-app message. This array should NOT be nil nor empty. Every object in the array
 * must be an instance of ABKInAppMessageButton.
 *
 * This method will set the in-app message buttons.
 */
- (void) setInAppMessageButtons:(NSArray *)buttonArray;
@end
