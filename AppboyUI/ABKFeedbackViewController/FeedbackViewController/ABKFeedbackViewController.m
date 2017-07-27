#import "ABKNavigationFeedbackViewController.h"
#import "ABKUIUtils.h"

// This constraint is for re-sizing the page with keyboard display.
static NSString *const FeedbackBottomConstraintID = @"FeedbackBottomConstraint";

@implementation ABKFeedbackViewController

#pragma mark - Feedback View UI Initialization

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification object:nil];
  [self setupViews];
  
  // Set the buttons and email text field's placeholder text with localized string.
  self.messageLabel.text = [self localizedAppboyFeedbackString:@"Appboy.feedback.label.message"];
  self.reportIssueLabel.text = [self localizedAppboyFeedbackString:@"Appboy.feedback.label.report-issue"];
  self.emailTextField.placeholder = [self localizedAppboyFeedbackString:@"Appboy.feedback.email-text-field-place-hold"];
}

- (void)setupViews {
  NSLog(@"Subclasses should override this method.");
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.feedbackTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[Appboy sharedInstance] logFeedbackDisplayed];
}

#pragma mark - Button Actions

- (IBAction)issueButtonTapped:(UIButton *)sender {
  self.issueButton.selected = !self.issueButton.selected;
}

- (IBAction)sendButtonTapped:(UIBarButtonItem *)sender {
  ABKFeedback *feedback = [self appboyFeedbackFromMessage:self.feedbackTextView.text
                                                    email:self.emailTextField.text
                                                    isBug:self.issueButton.selected];
  switch ([feedback feedbackValidation]) {
    case ABKInvalidEmailAddressFeedback: {
      [self displayAlertViewWithTitle:[self localizedAppboyFeedbackString:@"Appboy.feedback.alert.invalid-email.title"]
                              message:[self localizedAppboyFeedbackString:@"Appboy.feedback.alert.invalid-email.message"]];
    }
      break;
    case ABKEmptyFeedbackMessageFeedback: {
      [self displayAlertViewWithTitle:[self localizedAppboyFeedbackString:@"Appboy.feedback.alert.empty-feedback.title"]
                              message:[self localizedAppboyFeedbackString:@"Appboy.feedback.alert.empty-feedback.message"]];
    }
      break;
      
    case ABKValidFeedback:
       // Dismiss keyboard
      if ([self.feedbackTextView isFirstResponder]) {
        [self.feedbackTextView resignFirstResponder];
      } else if ([self.emailTextField isFirstResponder]) {
        [self.emailTextField resignFirstResponder];
      }
       // Show spinner view
      [self shouldHideSpinner:NO];
      // Submit feedback
      [[Appboy sharedInstance] submitFeedback:feedback withCompletionHandler:^(ABKFeedbackSentResult feedbackSentResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self shouldHideSpinner:YES];
          [self feedbackSent:feedbackSentResult];
        });
      }];
      break;
  }
}

- (ABKFeedback *)appboyFeedbackFromMessage:(NSString *)message
                                     email:(NSString *)email
                                     isBug:(BOOL)isBug {
  __autoreleasing ABKFeedback *feedback = [[ABKFeedback alloc] init];
  feedback.email = email;
  feedback.isBug = isBug;
  feedback.message = message;
  return feedback;
}

- (void)feedbackSent:(ABKFeedbackSentResult)feedbackSentResult {}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
  return YES;
}

#pragma mark - Keyboard Notification Listener

- (void)keyboardWillShow:(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo;
  NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  
  __block CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  keyboardRect = [self.view convertRect:keyboardRect toView:nil];
  __block CGPoint bottomPoint = CGPointMake(0, self.view.frame.size.height);
  bottomPoint = [self.view convertPoint:bottomPoint toView:nil];
  
  [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve << 16 animations:^{
    for (NSLayoutConstraint *constraint in self.view.constraints) {
      if ([constraint.identifier isEqualToString:FeedbackBottomConstraintID]) {
        // Here we are caculating the distance between the bottom of the feedback view and the bottom
        // of the screen. In some cases, e.g. within a tab bar, the bottom of the feedback view and
        // the screen do not align.
        double bottomDistance = [UIScreen mainScreen].bounds.size.height - bottomPoint.y;
        constraint.constant = keyboardRect.size.height - bottomDistance;
        [self.view layoutIfNeeded];
        break;
      }
    }
  } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo;
  NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  
  [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
    for (NSLayoutConstraint *constraint in self.view.constraints) {
      if ([constraint.identifier isEqualToString:FeedbackBottomConstraintID]) {
        constraint.constant = 0.0;
        break;
      }
    }
  } completion:nil];
}

#pragma mark - Spinner View Control

// After a user clicks "Send" to send feedback, add a full screen spinner view to avoid further change
// during the process.
- (void)shouldHideSpinner:(BOOL)hideSpinner {
  self.spinnerView.hidden = hideSpinner;
  for (UIBarButtonItem *barButtonItem in self.navigationItem.leftBarButtonItems) {
    barButtonItem.enabled = hideSpinner;
  }
  for (UIBarButtonItem *barButtonItem in self.navigationItem.rightBarButtonItems) {
    barButtonItem.enabled = hideSpinner;
  }
}

#pragma mark - Localization

- (NSString *)localizedAppboyFeedbackString:(NSString *)key {
  return [ABKUIUtils getLocalizedString:key
                         inAppboyBundle:[NSBundle bundleForClass:[ABKNavigationFeedbackViewController class]]
                                  table:@"AppboyFeedbackLocalizable"];
}

- (void)displayAlertViewWithTitle:(NSString *)title message:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:[self localizedAppboyFeedbackString:@"Appboy.alert.ok-button.title"]
                                        otherButtonTitles:nil, nil];
  [alert show];
  alert = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  // This delegate method will get called when the user clicks the send button on the keyboard. When the email text field
  // isn't empty, we should call the send feedback action, which is also the send button action; otherwise we should
  // return no.
  if (!textField.text || textField.text.length == 0) {
    return NO;
  } else {
    [self sendButtonTapped:nil];
    return YES;
  }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  // When the spinner view is displaying, the user shouldn't be able to change the feedback content.
  return self.spinnerView.hidden;
}

#pragma mark - dealloc

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
