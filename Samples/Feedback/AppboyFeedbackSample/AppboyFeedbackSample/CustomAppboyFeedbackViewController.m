#import "CustomAppboyFeedbackViewController.h"

@implementation CustomAppboyFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.topItem.title = @"Custom Feedback";
}

- (ABKFeedback *)appboyFeedbackFromMessage:(NSString *)message
                                     email:(NSString *)email
                                     isBug:(BOOL)isBug {
  NSString *updatedMessage = [message stringByAppendingString:@" from Braze"];
  return [super appboyFeedbackFromMessage:updatedMessage email:email isBug:isBug];
  
}

- (void)feedbackSent:(ABKFeedbackSentResult)feedbackSentResult {
  [super feedbackSent:feedbackSentResult];
  if (feedbackSentResult == ABKFeedbackSentSuccessfully) {
    [self displayAlertViewWithTitle:@"Thank you!" message:@"We value your feedback!"];
  }
}

@end
