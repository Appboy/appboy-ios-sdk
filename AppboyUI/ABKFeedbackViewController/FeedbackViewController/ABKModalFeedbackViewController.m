#import "ABKModalFeedbackViewController.h"
#import "AppboyKit.h"

@implementation ABKModalFeedbackViewController

- (void)setupViews {
  // Set the localized title for buttons and title on the navigation bar.
  self.navigationBar.topItem.title =[super localizedAppboyFeedbackString:@"Appboy.feedback.modal-context.title"];
  self.cancelBarButton.title = [super localizedAppboyFeedbackString:@"Appboy.feedback.cancel-button.title"];
  self.sendBarButton.title = [super localizedAppboyFeedbackString:@"Appboy.feedback.send-button.title"];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)loadView {
  [[NSBundle bundleForClass:[ABKModalFeedbackViewController class]] loadNibNamed:@"ABKModalFeedbackViewController"
                                                                         owner:self
                                                                       options:nil];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)feedbackSent:(ABKFeedbackSentResult)feedbackSentResult {
  if (feedbackSentResult == ABKFeedbackSentSuccessfully) {
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    // Display an alert view for no connection
    [self displayAlertViewWithTitle:[self localizedAppboyFeedbackString:@"Appboy.feedback.no-connection.title"]
                            message:[self localizedAppboyFeedbackString:@"Appboy.feedback.no-connection.message"]];
  }
}

@end
