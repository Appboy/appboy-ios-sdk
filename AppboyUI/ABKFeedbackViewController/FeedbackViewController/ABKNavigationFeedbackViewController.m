#import "ABKNavigationFeedbackViewController.h"
#import "AppboyKit.h"
#import "ABKUIUtils.h"

// This constraint is for re-sizing the page with keyboard display.
static NSString *const FeedbackBottomConstraintID = @"FeedbackBottomConstraint";

@implementation ABKNavigationFeedbackViewController

- (void)setupViews {
  self.title = [self localizedAppboyFeedbackString:@"Appboy.feedback.modal-context.title"];
  UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]  initWithTitle:[self localizedAppboyFeedbackString:@"Appboy.feedback.send-button.title"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(sendButtonTapped:)];
  
  [self.navigationItem setRightBarButtonItem:sendButton];
  
  // Don't display the feedback view underneath the navigation bar.
  self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)loadView {
  [[NSBundle bundleForClass:[ABKNavigationFeedbackViewController class]] loadNibNamed:@"ABKNavigationFeedbackViewController"
                                                                                owner:self
                                                                              options:nil];
}

- (void)feedbackSent:(ABKFeedbackSentResult)feedbackSentResult {
  if (feedbackSentResult == ABKFeedbackSentSuccessfully) {
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    // Display an alert view for no connection
    [self displayAlertViewWithTitle:[self localizedAppboyFeedbackString:@"Appboy.feedback.no-connection.title"]
                            message:[self localizedAppboyFeedbackString:@"Appboy.feedback.no-connection.message"]];
  }
}

@end
