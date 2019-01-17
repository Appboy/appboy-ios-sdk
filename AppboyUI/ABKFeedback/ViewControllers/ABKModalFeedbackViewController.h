#import "ABKFeedbackViewController.h"

@interface ABKModalFeedbackViewController : ABKFeedbackViewController

/*!
 * The navigation bar with the cancel and the send buttons.
 */
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

/*!
 * The cancel button on the navigation bar.
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;

/*!
 * The send button on the navigation bar.
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarButton;

/*!
 * @discussion The touch up inside action for the cancel button. The default behavior is to dismiss
 * the modal feedback view controller.
 *
 * For customization, please use a subclass or category to override this method.
 *
 */
- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender;

@end
