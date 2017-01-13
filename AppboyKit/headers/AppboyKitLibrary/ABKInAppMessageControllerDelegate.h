#import <Foundation/Foundation.h>
#import "ABKInAppMessage.h"
#import "ABKInAppMessageViewController.h"

@class ABKInAppMessageButton;
@class ABKInAppMessageImmersive;
@class ABKInAppMessageHTML;

NS_ASSUME_NONNULL_BEGIN
/*!
 * Possible values for in-app message handling after a in-app message is offered to an ABKInAppMessageControllerDelegate
 *   ABKDisplayInAppMessageNow - The in-app message will be displayed immediately.
 *   ABKDisplayInAppMessageLater - The in-app message will be not be displayed and will be placed back onto the top of the stack.
 *   ABKDiscardInAppMessage - The in-app message will be discarded and will not be displayed.
 *
 * The following conditions can cause a in-app message to be offered to the delegate defined by the delegate property on
 * [Appboy sharedInstance].inAppMessageController:
 * - A in-app message is received from the Appboy server.
 * - A in-app message is waiting to display when an UIApplicationDidBecomeActiveNotification event occurs.
 * - A in-app message is added by ABKInAppMessageController method addInAppMessage:.
 *
 * You can choose to manually display any in-app messages that are waiting locally to be displayed by calling:
 * [[Appboy sharedInstance].inAppMessageController displayNextInAppMessageWithDelegate:<your delegate>].
 */
typedef NS_ENUM(NSInteger, ABKInAppMessageDisplayChoice) {
  ABKDisplayInAppMessageNow,
  ABKDisplayInAppMessageLater,
  ABKDiscardInAppMessage
};

/*!
 * The in-app message delegate allows you to control the display and behavior of the Appboy in-app message. For more detailed
 * information on in-app message behavior, including when and how the delegate is used, see the documentation for the
 * ABKInAppMessageDisplayChoice enum above for more detailed information.
 */

/*
 * Appboy Public API: ABKInAppMessageControllerDelegate
 */
@protocol ABKInAppMessageControllerDelegate <NSObject>

@optional

/*!
 * @param inAppMessage The in-app message object being offered to the delegate method. It can be an
 * instance of class ABKInAppMessageSlideup, ABKInAppMessageModal or ABKInAppMessageFull.
 *
 * This delegate gets called when a new in-app message is received from the Appboy server and controls whether or not you're
 * going to use custom handling for the in-app message.
 *
 * If the delegate method returns YES, Appboy will not take any more actions on the provided in-app message and it becomes the
 * responsibility of the host app to deliver the in-app message to the user and report any impressions or in-app message clicks.
 * See ABKInAppMessage.h for more information.
 *
 * Conversely, if the delegate method returns NO, Appboy will handle the in-app message normally: the
 * in-app message will be put on top of the in-app message stack and be offered to the
 * beforeInAppMessageDisplayed:withKeyboardIsUp: delegate method if no other in-app message is 
 * currently on the screen.
 */
- (BOOL)onInAppMessageReceived:(ABKInAppMessage *)inAppMessage __deprecated;

/*!
 * @param inAppMessage The in-app message object being offered to the delegate method.
 * @param keyboardIsUp This boolean indicates whether or not the keyboard is currently being displayed when this
 * delegate fires.
 * @return ABKInAppMessageDisplayChoice for details refer to the documentation regarding the ENUM ABKInAppMessageDisplayChoice
 * above.
 *
 * This delegate method defines whether the in-app message will be displayed now, displayed later, or discarded.
 *
 * The default behavior is that the in-app message will be displayed unless the keyboard is currently active on the screen.
 * However, if there are other situations where you would not want the in-app message to appear (such as during a full screen
 * game or on a loading screen), you can use this delegate to delay or discard pending in-app message messages.
 */
- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage withKeyboardIsUp:(BOOL)keyboardIsUp;

/*!
 * @param inAppMessage The in-app message object being offered to the delegate.
 *
 * This delegate method allows host applications to customize the look of an in-app message while
 * maintaining the same user experience and impression/click tracking as the default Appboy in-app
 * message. It allows developers to pass incoming in-app messages to custom view controllers which 
 * they have created.
 *
 * The custom view controller is responsible for handling any responsive UI layout use-cases. e.g. device orientations,
 * or varied message lengths.
 *
 * Even with a custom view, by inheriting from ABKInAppMessageViewController, the in-app message will automatically animate and
 * dismiss according to the parameters of the provided ABKInAppMessage object. See ABKInAppMessage.h for more information.
 *
 * By default, Appboy will add following functions/changes to the custom view controller, and animate
 * the in-app message on and off the screen, based on the class of the given in-app message:
 *   * ABKInAppMessageSlideup:
 *      * stretch/shrink the in-app message view's width to fix the screen's width. If you wish to
 *        have margins between the in-app message and the edge of the screen, those must be incorporated 
 *        into the custom view controller itself.
 *      * add the impression and click tracking for the in-app message
 *      * when user clicks on the in-app message, call the onInAppMessageClicked:, and handle the click
 *        behavior correspond to the in-app message's inAppMessageClickActionType property.
 *      * add a pan gesture to the in-app message so user can swipe it away.
 *   * ABKInAppMessageModal:
 *      * make the in-app message clickable when there is no button(s) on it.
 *      * put the in-app message in the center of the screen, and add a full screen background layer.
 *   * ABKInAppMessageFull:
 *      * make the in-app message clickable when there is no button(s) on it.
 *      * stretch/shrink the in-app message view to fix the whole screen.
 *
 * NOTE: The returned view controller should be a ABKInAppMessageViewController or preferably, a subclass of
 * ABKInAppMessageViewController. The view of the returned view controller should be an instance of ABKInAppMessageView or its
 * subclass.
 */
- (ABKInAppMessageViewController *)inAppMessageViewControllerWithInAppMessage:(ABKInAppMessage *)inAppMessage;

/*!
 * @param inAppMessage The in-app message object being offered to the delegate.
 *
 * This delegate method is fired when:
 *   * the user manually dismisses the in-app message (via a swipe).
 *   * the in-app message times out and expires.
 *   * the close button on a modal in-app message or a full in-app message is clicked.
 * Use this method to perform any custom logic that should execute after the in-app message has been
 * dismissed.
 */
- (void)onInAppMessageDismissed:(ABKInAppMessage *)inAppMessage;

/*!
 * @param inAppMessage The in-app message object being offered to the delegate.
 * @return Boolean Value which controls whether or not Appboy will execute the click action. Returning YES will prevent
 *         Appboy from performing the click action. Returning NO will cause Appboy to execute the action defined in the
 *         in-app message's inAppMessageClickActionType property after this delegate method is called.
 *
 * This delegate method is fired when the user clicks on a slideup in-app message, or a modal/full
 * in-app message without button(s) on it. See ABKInAppMessage.h for more information.
 */
- (BOOL)onInAppMessageClicked:(ABKInAppMessage *)inAppMessage;

/*!
 * @param inAppMessage The in-app message object being offered to the delegate.
 * @param button The clicked button being offered to the delegate.
 * @return Boolean Value which controls whether or not Appboy will execute the click action. Returning YES will prevent
 *         Appboy from performing the click action. Returning NO will cause Appboy to execute the action defined in the
 *         button's inAppMessageClickActionType property after this delegate method is called.
 *
 * This delegate method is fired whenever the user clicks a button on the in-app message. See 
 * ABKInAppMessageBlock.h for more information.
 */
- (BOOL)onInAppMessageButtonClicked:(ABKInAppMessageImmersive *)inAppMessage button:(ABKInAppMessageButton *)button;

/*!
 * @param inAppMessage The in-app message object being offered to the delegate.
 * @param clickedURL The URL that is clicked by user.
 * @param buttonId The buttonId within the clicked link being offered to the delegate.
 * @return Boolean Value which controls whether or not Appboy will execute the click action. Returning YES will prevent
 *         Appboy from performing the click action. Returning NO will cause Appboy to follow the link.
 *
 * This delegate method is fired whenever the user clicks a link on the HTML in-app message. See
 * ABKInAppMessageHTML.h for more information.
 */
- (BOOL)onInAppMessageHTMLButtonClicked:(ABKInAppMessageHTML *)inAppMessage clickedURL:(nullable NSURL *)clickedURL buttonID:(NSString *)buttonId;

@end
NS_ASSUME_NONNULL_END
