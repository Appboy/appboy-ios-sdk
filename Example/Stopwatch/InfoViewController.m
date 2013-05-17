//
//  InfoViewController.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

// Open up a modal feedbackViewController when the button is tapped.
- (IBAction) talkToUsButtonTapped:(id)sender {
  ABKFeedbackViewControllerModalContext *feedbackViewController =
      [[[ABKFeedbackViewControllerModalContext alloc] init] autorelease];

  // We want to be notified when either "Cancel" or "Send" is tapped.
  feedbackViewController.delegate = self;
  [self presentViewController:feedbackViewController animated:YES completion:nil];
}

// User hit "Cancel." No feedback has been sent.  Note that if we had not set the ABKFeedbackViewControllerModalContext's
// delegate, we wouldn't need this method -- it would close itself.  In this case, however, we want to know
// that the feedback has been sent;  so, we must implement both delegate methods.
- (void) feedbackViewControllerModalContextCancelTapped:(ABKFeedbackViewControllerModalContext *)sender {
  [self dismissModalViewControllerAnimated:YES];
}

// Feedback was sent successfully
- (void) feedbackViewControllerModalContextFeedbackSent:(ABKFeedbackViewControllerModalContext *)sender {

  // Alert the user; it's good to know for sure that the feedback was sent!
  UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                       message:@"Thanks for sharing your thoughts on Stopwatch."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil] autorelease];

  [alertView show];
}

// Dismiss feedback form after the OK button is tapped on the alert. 
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  NSLog(@"alertViewCancel");
  [self dismissModalViewControllerAnimated:YES];
}

// In the storyboard, a news feed opens via a push segue from the "Stopwatch News" button to the
// ABKFeedViewControllerNavigationContext.

// Set the feed's title during the segue.  In the context of a navigation controller, you need to
// set the title directly on the controller's navigationItem.title property.  In the modal and
// popover contexts, you can use the navigationBarTitle property.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"feedViewControllerNavigationContextSegue"]) {
    ABKFeedViewControllerNavigationContext *feedViewControllerNavigationContext =
        (ABKFeedViewControllerNavigationContext *) segue.destinationViewController;
    feedViewControllerNavigationContext.navigationItem.title = @"News";
  }
}

// Tell Appboy something was shared on Facebook
- (void) facebookButtonTapped:(id)sender {
  [[Appboy sharedInstance] logSocialShare:ABKSocialNetworkFacebook];
  UIAlertView *uiAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for sharing Stopwatch to Facebook!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
  [uiAlertView show];
  [uiAlertView release];
}

// Tell Appboy something was shared on Twitter
- (void) twitterButtonTapped:(id)sender {
  [[Appboy sharedInstance] logSocialShare:ABKSocialNetworkTwitter];
  UIAlertView *uiAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for sharing Stopwatch to Twitter!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
  [uiAlertView show];
  [uiAlertView release];
}

// Record a simulated in-app purchase
- (IBAction) buyStopwatchProTapped:(id)sender {
  [[Appboy sharedInstance] logPurchase:@"stopwatch_pro" priceInCents:99];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thanks for buying Stopwatch Pro!"
                                                      message:nil delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
  [alertView release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void) dealloc {
  [super dealloc];
}

- (void) viewDidUnload {
  [super viewDidUnload];
}
@end
