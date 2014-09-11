#import <Foundation/Foundation.h>
#import "ABKSlideup.h"
#import "ABKSlideupViewController.h"

/*!
 * Possible values for slideup handling after a slideup is offered to an ABKSlideupControllerDelegate
 *   ABKDisplaySlideupNow - The slideup will be displayed immediately.
 *   ABKDisplaySlideupLater - The slideup will be not be displayed and will be placed back onto the top of the stack.
 *   ABKDiscardSlideup - The slideup will be discarded and will not be displayed.
 *
 * The following conditions can cause a slideup to be offered to the delegate defined by the delegate property on
 * [Appboy sharedInstance].slideupController:
 * - A slideup is received from the Appboy server.
 * - A slideup is waiting to display when an UIApplicationDidBecomeActiveNotification event occurs.
 * - A slideup is added by ABKSlideupController method addSlideup:.
 *
 * You can choose to manually display any slideups that are waiting locally to be displayed by calling:
 * [[Appboy sharedInstance].slideupController displayNextSlideupWithDelegate:<your delegate>].
 */
typedef NS_ENUM(NSInteger, ABKSlideupDisplayChoice) {
  ABKDisplaySlideupNow,
  ABKDisplaySlideupLater,
  ABKDiscardSlideup
};

/*!
 * The slideup delegate allows you to control the display and behavior of the Appboy slideup. For more detailed
 * information on slideup behavior, including when and how the delegate is used, see the documentation for the
 * ABKSlideupDisplayChoice enum above for more detailed information.
 */
@protocol ABKSlideupControllerDelegate <NSObject>
@optional

/*!
 * @param slideup The slideup object being offered to the delegate method.
 *
 * This delegate gets called when a new slideup is received from the Appboy server and controls whether or not you're
 * going to use custom handling for the slideup.
 *
 * If the delegate method returns YES, Appboy will not take any more actions on the provided slideup and it becomes the
 * responsibility of the host app to deliver the slideup to the user and report any impressions or slideup clicks.
 * See ABKSlideup.h for more information.
 *
 * Conversely, if the delegate method returns NO, Appboy will handle the slideup normally: the slideup will be put on
 * top of the slideup stack and be offered to the beforeSlideupDisplayed: delegate method if no other slideup is
 * currently on the screen.
 */
- (BOOL) onSlideupReceived:(ABKSlideup *)slideup;

/*!
 * @param slideup The slideup object being offered to the delegate method.
 * @param keyboardIsUp This boolean indicates whether or not the keyboard is currently being displayed when this
 * delegate fires.
 * @return ABKSlideupDisplayChoice for details refer to the documentation regarding the ENUM ABKSlideupDisplayChoice
 * above.
 *
 * This delegate method defines whether the slideup will be displayed now, displayed later, or discarded.
 *
 * The default behavior is that the slideup will be displayed unless the keyboard is currently active on the screen.
 * However, if there are other situations where you would not want the slideup to appear (such as during a full screen
 * game or on a loading screen), you can use this delegate to delay or discard pending slideup messages.
 */
- (ABKSlideupDisplayChoice) beforeSlideupDisplayed:(ABKSlideup *)slideup withKeyboardIsUp:(BOOL)keyboardIsUp;

/*!
 * @param slideup The slideup object being offered to the delegate.
 *
 * This delegate method allows host applications to customize the look of a slideup while maintaining the same user
 * experience and impression/click tracking as the default Appboy slideup. It allows developers to pass incoming slideups
 * to custom view controllers which they have created.
 *
 * The custom view controller is responsible for handling any responsive UI layout use-cases. e.g. device orientations,
 * or varied message lengths.
 *
 * By default, Appboy will stretch/shrink the slideup view's width to fix the screen's width, and slide it up onto the
 * screen. If you wish to have margins between the slideup and the edge of the screen, those must be incorporated into
 * the custom view controller itself.
 *
 * Even with a custom view, by inheriting from ABKSlideupViewController, the slideup will automatically animate and
 * dismiss according to the parameters of the provided ABKSlideup object. See ABKSlideup.h for more information.
 *
 * NOTE: The returned view controller should be a ABKSlideupViewController or preferably, a subclass of
 * ABKSlideupViewController. The view of the returned view controller should be an instance of ABKSlideupView or its
 * subclass.
 */
- (ABKSlideupViewController *) slideupViewControllerWithSlideup:(ABKSlideup *)slideup;

/*!
 * @param slideup The slideup object being offered to the delegate.
 *
 * This delegate method is fired whenever the user manually dismisses the slideup (via a swipe), or if the slideup
 * times out and expires. Use this method to perform any custom logic that should execute after the slideup has been
 * dismissed.
 */
- (void) onSlideupDismissed:(ABKSlideup *)slideup;

/*!
 * @param slideup The slideup object being offered to the delegate.
 * @return Boolean Value which controls whether or not Appboy will execute the click action. Returning YES will prevent
 *         Appboy from performing the click action. Returning NO will cause Appboy to execute the action defined in the
 *         slideup's slideupClickActionType property after this delegate method is called.
 *
 * This delegate method is fired whenever the user clicks on the slideup. See ABKSlideup.h for more information.
 */
- (BOOL) onSlideupClicked:(ABKSlideup *)slideup;

@end
