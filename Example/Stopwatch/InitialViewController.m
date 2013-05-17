//
//  InitialViewController.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@property (retain, nonatomic) Clock *clock;
@property (assign, nonatomic) BOOL contactUsPopoverDisplayed;
@property (retain, nonatomic) UIPopoverController *contactUsPopoverController;
@property (assign, nonatomic) BOOL latestNewsPopoverDisplayed;
@property (retain, nonatomic) UIPopoverController *latestNewsPopoverController;
@end

@implementation InitialViewController

- (void) viewDidLoad {
  [super viewDidLoad];

  [self.startButton setTitle:@"Start" forState:UIControlStateNormal];

  self.clock = [[[Clock alloc] init] autorelease];
  self.clock.delegate = self;
  [self.clock reset];

  self.contactUsPopoverDisplayed = NO;
  self.latestNewsPopoverDisplayed = NO;

  // On iPad, add some buttons to the navigation bar
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

    // Make a button for sharing to Facebook
    UIImage *facebookImage = [UIImage imageNamed:@"facebook-icon.png"];
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton.bounds = CGRectMake(0, 0, 30, 30);
    [facebookButton addTarget:self action:@selector(facebookButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [facebookButton setImage:facebookImage forState:UIControlStateNormal];
    UIBarButtonItem *facebookBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:facebookButton];

    // Make a button for sharing to Twitter
    UIImage *twitterImage = [UIImage imageNamed:@"twitter-icon.png"];
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterButton.bounds = CGRectMake(0, 0, 30, 30);
    [twitterButton addTarget:self action:@selector(twitterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setImage:twitterImage forState:UIControlStateNormal];
    UIBarButtonItem *twitterBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:twitterButton];

    // App purchase button
    UIBarButtonItem *purchaseBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upgrade" style:UIBarButtonItemStyleBordered target:self action:@selector(purchaseButtonTapped)];

    // Add to navigation bar
    self.navigationItem.rightBarButtonItems = @[self.contactUsButton, facebookBarButtonItem, twitterBarButtonItem, purchaseBarButtonItem];

    [facebookBarButtonItem release];
    [twitterBarButtonItem release];
    [purchaseBarButtonItem release];
  }
}

// Record simulated share to Facebook or Twitter
- (void) facebookButtonTapped {
  [[Appboy sharedInstance] logSocialShare:ABKSocialNetworkFacebook];
  UIAlertView *uiAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for sharing Stopwatch to Facebook!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
  [uiAlertView show];
  [uiAlertView release];
}

- (void) twitterButtonTapped {
  [[Appboy sharedInstance] logSocialShare:ABKSocialNetworkTwitter];
  UIAlertView *uiAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for sharing Stopwatch to Twitter!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
  [uiAlertView show];
  [uiAlertView release];
}

// Record simulated in-app purchase
- (void) purchaseButtonTapped {
  [[Appboy sharedInstance] logPurchase:@"stopwatch_pro" priceInCents:99];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thanks for buying Stopwatch Pro!"
                                                      message:nil delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
  [alertView release];
}

// iPad only.  Examples of how to use the feed and feedback view controllers in a popover context.

// Present a feedbackViewController in a popover
- (IBAction) contactUsButtonTapped:(id)sender {

  // Need to prevent the popover from opening more than once in response to multiple taps --
  // if the popover is already displayed, ignore subsequent taps on the contactUsButton.
  if (!self.contactUsPopoverDisplayed) {
    ABKFeedbackViewControllerPopoverContext *feedbackViewControllerPopoverContext =
        [[[ABKFeedbackViewControllerPopoverContext alloc] init] autorelease];
    feedbackViewControllerPopoverContext.delegate = self;

    self.contactUsPopoverController =
        [[[UIPopoverController alloc] initWithContentViewController:feedbackViewControllerPopoverContext] autorelease];
    [self.contactUsPopoverController presentPopoverFromBarButtonItem:self.contactUsButton
                                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                                            animated:YES];
    self.contactUsPopoverDisplayed = YES;
  }
}

// These two methods are required -- this is how we know when to close the popover.  Note that tapping outside
// the feedback popover will *not* close it.  This is by design:  we don't want the user to accidentally tap outside
// and close the popover if there's text in the feedback form.
- (void) feedbackViewControllerPopoverContextCancelTapped:(ABKFeedbackViewControllerPopoverContext *)sender {
  [self.contactUsPopoverController dismissPopoverAnimated:YES];
  self.contactUsPopoverDisplayed = NO;
}

// Let the user know the feedback was sent successfully, and then close the feedback form.
- (void) feedbackViewControllerPopoverContextFeedbackSent:(ABKFeedbackViewControllerPopoverContext *)sender {
  UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                       message:@"Thanks for sharing your thoughts on Stopwatch."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil] autorelease];
  [alertView show];

  [self.contactUsPopoverController dismissPopoverAnimated:YES];
  self.contactUsPopoverDisplayed = NO;
}

// Present a feedViewController in a popover
- (IBAction) latestNewsButtonTapped:(id)sender {

  // Prevent the popover from opening more than once in response to multiple taps.
  if (!self.latestNewsPopoverDisplayed) {
    ABKFeedViewControllerPopoverContext *feedViewControllerPopoverContext =
        [[[ABKFeedViewControllerPopoverContext alloc] init] autorelease];
    feedViewControllerPopoverContext.closeButtonDelegate = self;

    self.latestNewsPopoverController =
        [[[UIPopoverController alloc] initWithContentViewController:feedViewControllerPopoverContext] autorelease];
    [self.latestNewsPopoverController presentPopoverFromBarButtonItem:self.latestNewsButton
                                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                                             animated:YES];

    // Need to use this delegate to handle the case where a tap outside the popover closes it.
    self.latestNewsPopoverController.delegate = self;
    self.latestNewsPopoverDisplayed = YES;
  }
}

// This delegate is called when "close" is tapped on the popover.  Close it.
- (void) feedViewControllerPopoverContextCloseTapped:(ABKFeedViewControllerPopoverContext *)sender {
  [self.latestNewsPopoverController dismissPopoverAnimated:YES];
  self.latestNewsPopoverDisplayed = NO;
}

// Unlike the feedback popover, tapping outside the feed popover will close it.  We need
// to know about this to set self.latestPopoverDisplayed correctly
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  if ([popoverController isEqual:self.latestNewsPopoverController]) {
    self.latestNewsPopoverDisplayed = NO;
  }
}

- (void) viewDidUnload {
  [self setStartButton:nil];
  [self setTimeLabel:nil];
  [self setContactUsButton:nil];
  [self setContactUsButton:nil];
  [self setLatestNewsButton:nil];
  [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
}

- (IBAction) resetButtonTapped:(id)sender {
  [self.clock reset];
}

- (IBAction) startButtonTapped:(id)sender {
  if (!self.clock.clockRunning) {

    // Let's keep track of how many times the user has started the stopwatch;  let's send this data to Appboy.
    // This will give us an idea of how much or little someone is using this app.
    [[Appboy sharedInstance] logCustomEvent:@"stopwatch_started"];

    [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.clock start];
  }
  else {
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.clock stop];
  }
}

- (void) timeStringUpdated:(NSString *)timeString {
  self.timeLabel.text = timeString;
}

- (void) dealloc {
  [_contactUsButton release];
  [_latestNewsButton release];
  [super dealloc];
}
@end
