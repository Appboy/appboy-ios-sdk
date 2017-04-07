
/*
 * ABKInAppMessageViewController is the class for the inAppMessage view controller.
 *  * In order to create a custom view controller you must:
 *  *  * Create a subclass of ABKInAppMessageViewController
 *  *  * The view of the subclass instance must be an instance of ABKInAppMessageView or optionally a subclass thereof.
 *
 *  * The custom inAppMessage view controller must handle and account for:
 *  *  * In-app message text of varying lengths.
 *  *  * Different possible layouts and orientations for possible devices
 *  *  *  * e.g. iPhone [Portrait & Landscape] as well as iPad [Portrait & Landscape].
 */

#import <UIKit/UIKit.h>

@class ABKInAppMessage;
@class ABKLabel;

/*
 * Appboy Public API: ABKInAppMessageViewController
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageViewController : UIViewController

@property (strong) ABKInAppMessage *inAppMessage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconLabelView;
@property (weak, nonatomic) IBOutlet ABKLabel *inAppMessageMessageLabel;

/*
 * The initWithInAppMessage method may be used to pass the inAppMessage property to any custom view controller that you create.
 */
- (instancetype)initWithInAppMessage:(ABKInAppMessage *)inAppMessage;

/*!
 * @param animated If YES, the inAppMessage will animate off the screen. If NO, the inAppMessage will disappear immediately without an animation.
 *
 * @discussion The void method hideInAppMessage may be called in order to dismiss the inAppMessage. Animation of the dismissal is controlled with the animated parameter.
 */
- (void)hideInAppMessage:(BOOL)animated;

/*
 *  The following two methods are used during slideup display/hide animation, and are required to implement by subclasses.
 *  When an in-app message is going to be displayed on the screen, Appboy will call moveInAppMessageViewOffScreen:
 *  before the animation, and then moveInAppMessageViewOnScreen: after the animation.
 *  When an in-app message is going to be removed or dismissed, moveInAppMessageViewOffScreen: will be called, too.
 */

/*
 * @param inAppMessageWindowFrame the frame of the in-app message full-screen window, which is the super view of the in-app message
 *        view controller's view.
 *
 * @discussion When an in-app message view is going to be displayed on the screen, or removed from the screen, you can use
 * this method to control the in-app message view's animation by setting the OFF-screen position and status of the in-app message view,
 * e.g. move the in-app message view out of the bound of the screen, or set the alpha of the view to 0.
 * Your view controller should override this method. The default implementation of this method does nothing.
 */
- (void)moveInAppMessageViewOffScreen:(CGRect)inAppMessageWindowFrame;

/*
 * @param inAppMessageWindowFrame the frame of the in-app message full-screen window, which is the super view of the in-app message
 *        view controller's view.
 *
 * @discussion When an in-app message view is going to be displayed on the screen, you can use this method to control
 * the in-app message view's animation by setting the ON-screen position and status of the in-app message view,
 * e.g. move the in-app message view in the center of the screen, or set the alpha of the view to 1.
 * Your view controller should override this method. The default implementation of this method does nothing.
 */
- (void)moveInAppMessageViewOnScreen:(CGRect)inAppMessageWindowFrame;

@end
NS_ASSUME_NONNULL_END
