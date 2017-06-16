#import <UIKit/UIKit.h>


/*!
 * Appboy Public API: ABKInAppMessageWindowController
 *
 * ABKInAppMessageWindowController is the view controller responsible for housing and displaying
 * ABKInAppMessageViewControllers and performing actions after the in-app message is clicked. Instances 
 * of ABKInAppMessageWindowController are deallocated after the in-app message is dismissed.
 */
@interface ABKInAppMessageWindowController : UIViewController <UIGestureRecognizerDelegate>

@end
