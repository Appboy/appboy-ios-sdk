#import <UIKit/UIKit.h>
#import "AppboyKit.h"

@interface ABKFeedbackViewController : UIViewController <UITextFieldDelegate>

/*!
 * The UITextView for feedback input.
 */
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

/*!
 * The UIButton for the user to specify if they are providing general feedback or reporting an issue.
 */
@property (weak, nonatomic) IBOutlet UIButton *issueButton;

/*!
 * The UILabel which indicates the feedback area.
 */
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/*!
 * The UILabel for issue report.
 */
@property (weak, nonatomic) IBOutlet UILabel *reportIssueLabel;

/*!
 * The UITextField for email input.
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*!
 * A full size view with a spinner. After the user submits the feedback, the view will show up and block
 * user interaction with the feedback view to avoid modification. The view will disappear after the
 * attempt to send feedback completes.
 */
@property (weak, nonatomic) IBOutlet UIView *spinnerView;

/*!
 * @discussion The touch up inside action for the issue button. The default behavior is to change the
 * select state of the button.
 *
 * For customization, please use a subclass or category to override this method.
 */
- (IBAction)issueButtonTapped:(UIButton *)sender;

/*!
 * @discussion The touch up inside action for the send button. The default behavior is to check the 
 * validation of the feedback object, show the spinner view, and send the feedback through the Appboy SDK.
 *
 * For customization, please use a subclass or category to override this method.
 */
- (IBAction)sendButtonTapped:(UIBarButtonItem *)sender;

/*!
 * @discussion This method is for customizing the feedback object from user inputs. It replaces the
 * old feedbackViewControllerBeforeFeedbackSent delegate method.
 *
 * To do customization on the feedback object, you can override this method in a subclass.
 */
- (ABKFeedback *)appboyFeedbackFromMessage:(NSString *)message
                                     email:(NSString *)email
                                     isBug:(BOOL)isBug;

/*!
 * @discussion This method is for custom handling after feedback is sent. It replaces the old
 * feedbackViewControllerFeedbackSent delegate method.
 *
 * To do custom handling after feedback is sent, you can override this method in a subclass.
 */
- (void)feedbackSent:(ABKFeedbackSentResult)feedbackSentResult;

/*!
 * @discussion This method returns the localized string from AppboyFeedbackLocalizable.strings file.
 * You can easily override the localized string by adding the keys and the translations to your own
 * Localizable.strings file.
 *
 * To do custom handling with the Appboy localized string, you can override this method in a
 * subclass.
 */
- (NSString *)localizedAppboyFeedbackString:(NSString *)key;

/*!
 * @discussion This method displays an alert view with the given title and message. The button title
 * is localized within the AppboyFeedbackLocalizable.strings file.
 */
- (void)displayAlertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
