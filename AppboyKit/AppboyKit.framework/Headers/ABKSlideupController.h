#import <Foundation/Foundation.h>
#import "ABKSlideup.h"
#import "ABKSlideupControllerDelegate.h"

/* Note: This class is not thread safe and all class methods should be called from the main thread.*/
@interface ABKSlideupController : NSObject

/*!
 * Setting the delegate allows your app to control how, when, and if slideups are displayed.
 * Your app can set the delegate to override the default behavior of the ABKSlideupController. See
 * ABKSlideupControllerDelegate.h for more information.
 */
@property (nonatomic, retain) id <ABKSlideupControllerDelegate> delegate;

/*!
 * supportedOrientationMasks allows you to change which orientation masks the slideup (in-app message) supports.
 * Slideups (in-app messages) will normally support the orientations specified in the app settings, but the method
 * supportedInterfaceOrientations may optionally override that. The value of supportedOrientationMasks will be returned
 * in supportedInterfaceOrientations in the slideup view controller.
 *
 * The default value of supportedOrientationMasks is UIInterfaceOrientationMaskAll. This property only works in iOS 6 and later.
 *
 */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMasks;

/*!
 * supportedOrientations allows you to change which orientation the slideup (in-app message) supports.
 * Slideups (in-app messages) will normally support the orientations specified in the app settings, but method
 * preferredInterfaceOrientationForPresentation may optionally override that. The value of supportedOrientations will be
 * returned in preferredInterfaceOrientationForPresentation in slideup view controller.
 *
 * The default value of supportedOrientations includes all orientations: UIInterfaceOrientationPortrait,
 * UIInterfaceOrientationLandscapeRight, UIInterfaceOrientationLandscapeLeft and UIInterfaceOrientationPortraitUpsideDown.
 * This property only works in iOS 6 and later.
 */
@property (nonatomic, assign) UIInterfaceOrientation supportedOrientations;

/*!
 * @param delegate The slideup delegate that implements the ABKSlideupControllerDelegate methods. If the delegate is
 * nil, it acts as one which always returns ABKDisplaySlideupNow and doesn't implement all other delegate methods.
 *
 * @discussion This method grabs the next slideup from the slideup stack, if there is one, and displays it with
 * the provided delegate. The delegate must return a ABKSlideupDisplayChoice that defines how the slideup will be
 * handled. Please refer to the ABKSlideupDisplayChoice enum documentation for more detailed information.
 *
 * If there are no slideups available this returns immediately having taken no action.
 */
- (void) displayNextSlideupWithDelegate:(id<ABKSlideupControllerDelegate>)delegate;

/*!
 * @return The number of slideups that are locally waiting to be displayed.
 *
 * @discussion Use this method to check how many slideups are waiting to be displayed and call
 * displayNextSlideupWithDelegate: at to display it. If a slideup is currently being displayed, it will not be included
 * in the count.
 *
 * Note: Returning ABKDisplaySlideupLater in the beforeSlideupDisplayed: delegate method will put the slideup back onto
 * the stack and this will be reflected in slideupsRemainingOnStack.
 */
- (NSInteger) slideupsRemainingOnStack;

/*!
 * @param newSlideup A new slideup that will be added into the top of the stack of slideups that haven't been displayed yet.
 *
 * @discussion This method allows you to display a custom slideup. It adds the slideup object to the top of the slideup stack
 * and tries to display immediately.
 *
 * Note: Clicks and impressions of slideups added by this method will not be collected by Appboy and will not be
 * reflected on the dashboard.
 */
- (void) addSlideup:(ABKSlideup *)newSlideup;

/*!
 * @param animated If YES, the slideup will slide off the screen. If NO, the slideup will disappear immediately without
 * an animation.
 *
 * @discussion If there is a slideup currently being displayed, calling this method will hide it. The animated parameter
 * controls whether or not the slideup will be animated away. This method does nothing if no slideup is currently being
 * displayed.
 *
 * Note: This will not fire the onSlideupDismissed: delegate method.
 */
- (void) hideCurrentSlideup:(BOOL)animated;
@end
