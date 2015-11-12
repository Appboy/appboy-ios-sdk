#import "InitialViewController.h"
#import "ABKLocationManager.h"

@interface InitialViewController ()
@property Clock *clock;
@property UIPopoverController *contactUsPopoverController;
@property UIPopoverController *latestNewsPopoverController;
@property UIPopoverController *newsAndFeedbackPopoverController;
@property CLLocationManager *locationManager;
@end

@implementation InitialViewController

- (void) viewDidLoad {
  [super viewDidLoad];


  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeUpdated:) name:TimeUpdatedNotification object:nil];
  self.clock = [[Clock alloc] init];
  [self.clock reset];

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.splitViewController.delegate = self;
    
    // As Apple docs say 'you do not add subviews to a navigation bar directly', we have to programmatically
    // add the button items
    self.navigationItem.rightBarButtonItems = @[self.UpgradeButton, self.contactUsButton];
    self.navigationItem.leftBarButtonItems = @[self.latestNewsButton, self.newsAndFeedbackButton];
  }

  // prepare the newsAndFeedback bar button item and related properties and functions
  ABKFeedViewControllerNavigationContext *feedViewController = [[ABKFeedViewControllerNavigationContext alloc] init];
  self.newsAndFeedbackNavigationController = [[UINavigationController alloc] initWithRootViewController:feedViewController];
  self.newsAndFeedbackNavigationController.delegate = self;
  self.newsAndFeedbackNavigationController.navigationBar.tintColor = [UIColor colorWithRed:0.16 green:0.5 blue:0.73 alpha:1.0];
  self.newsAndFeedbackNavigationController.navigationBar.barStyle = UIBarStyleBlack;
  UIBarButtonItem *feedbackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.feedback", nil)
                                                                              style:UIBarButtonItemStyleBordered target:self action:@selector(openFeedbackFromNavigationFeed:)];
  feedViewController.navigationItem.rightBarButtonItem = feedbackBarButtonItem;

  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(requestLocationAuthorization)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveFirstNewsFeedToWatch)
                                               name:ABKFeedUpdatedNotification
                                             object:nil];
}

// This method will find the first card with title and text body from Appboy SDK, and save the card's
// title and text body in the shared container so the Stopwatch watch app can pull out and display the
// data.
- (void) saveFirstNewsFeedToWatch {
  if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.appboy.stopwatch"];
    for (ABKCard *card in [[Appboy sharedInstance].feedController getCardsInCategories:ABKCardCategoryAll]) {
      if ([card isKindOfClass:[ABKCaptionedImageCard class]] || [card isKindOfClass:[ABKTextAnnouncementCard class]] ||
          [card isKindOfClass:[ABKClassicCard class]]) {
        [defaults setObject:@{@"news-title" : [(ABKTextAnnouncementCard *)card title], @"news-body" : [(ABKTextAnnouncementCard *)card cardDescription]} forKey:@"AppboyFirstNews"];
        [defaults synchronize];
        break;
      }
    }
    defaults = nil;
  }
}

- (void)requestLocationAuthorization {
  [[Appboy sharedInstance].locationManager allowRequestAlwaysPermission];
}

// newsAndFeedback Section
//
// Examples of how to put Appboy in one action: a button that open feed page, on which there is a feedback button
// function of the feedback button in the newsAndFeedback bar button item
- (void) openFeedbackFromNavigationFeed:(id)sender {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    ABKFeedbackViewControllerPopoverContext *popoverFeedback = [[ABKFeedbackViewControllerPopoverContext alloc] init];
    [self.newsAndFeedbackNavigationController pushViewController:popoverFeedback animated:YES];
  } else {
    ABKFeedbackViewControllerNavigationContext *navFeedback = [[ABKFeedbackViewControllerNavigationContext alloc] init];
    [self.newsAndFeedbackNavigationController pushViewController:navFeedback animated:YES];
  }
}

- (IBAction) newsAndFeedbackButtonTapped:(id)sender {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    if (self.newsAndFeedbackPopoverController == nil) {
      self.newsAndFeedbackPopoverController =
          [[UIPopoverController alloc] initWithContentViewController:self.newsAndFeedbackNavigationController];
    }
    // we don't want to have two popover opened at the same time, both displaying news feed page
    if (self.latestNewsPopoverController) {
      [self.latestNewsPopoverController dismissPopoverAnimated:YES];
      self.latestNewsPopoverController = nil;
    }
    [self.newsAndFeedbackPopoverController presentPopoverFromBarButtonItem:self.newsAndFeedbackButton
                                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                                            animated:YES];
  }
  else {
    // add a cancel button on feed page for modal view
    UIViewController *rootViewController = [[self.newsAndFeedbackNavigationController viewControllers] objectAtIndex:0];
    rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.cancel", nil)
                                                                                           style:UIBarButtonItemStyleBordered
                                                                                          target:self
                                                                                           action:@selector(dismissNewsAndFeedbackModalView:)];
    [self presentViewController:self.newsAndFeedbackNavigationController animated:YES completion:nil];
  }
}

- (void) dismissNewsAndFeedbackModalView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
  UIViewController *rootViewController = [[self.newsAndFeedbackNavigationController viewControllers] objectAtIndex:0];
  rootViewController.navigationItem.leftBarButtonItem = nil;
}

// iPad Section
//
// Examples of how to use the feed and feedback view controllers in a popover context.
// Present a feedbackViewController in a popover
- (IBAction) contactUsButtonTappediPad:(id)sender {

  if (self.contactUsPopoverController == nil) {
    ABKFeedbackViewControllerPopoverContext *feedbackViewControllerPopoverContext =
        [[ABKFeedbackViewControllerPopoverContext alloc] init];
    feedbackViewControllerPopoverContext.delegate = self;
    
    // To make the feedback form look nicer, we recommend setting the popover content size manually
    // instead of using default popover size, which is too long for a feedback form
    feedbackViewControllerPopoverContext.contentSizeForViewInPopover = CGSizeMake(320, 300);
    self.contactUsPopoverController =
        [[UIPopoverController alloc] initWithContentViewController:feedbackViewControllerPopoverContext];

  }
  [self.contactUsPopoverController presentPopoverFromBarButtonItem:self.contactUsButton
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
}

// Present a feedViewController in a popover
- (IBAction) latestNewsButtonTappediPad:(id)sender {

  // Prevent the popover from opening more than once in response to multiple taps.
  if (self.latestNewsPopoverController == nil) {
    ABKFeedViewControllerPopoverContext *feedViewControllerPopoverContext =
        [[ABKFeedViewControllerPopoverContext alloc] init];
    feedViewControllerPopoverContext.navigationBar.barStyle = UIBarStyleBlack;
    feedViewControllerPopoverContext.closeButtonDelegate = self;
    self.latestNewsPopoverController =
        [[UIPopoverController alloc] initWithContentViewController:feedViewControllerPopoverContext];
  }
  
  // avoid displaying two news feed popovers on the screen at the same time
  if (self.newsAndFeedbackPopoverController) {
    [self.newsAndFeedbackPopoverController dismissPopoverAnimated:YES];
    self.newsAndFeedbackPopoverController = nil;
  }
  
  [self.latestNewsPopoverController presentPopoverFromBarButtonItem:self.latestNewsButton
                                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                                           animated:YES];
}

// iPhone Section
//
// An example of how to use a modal feedback view controller

// Open up a modal feedbackViewController when the button is tapped.
- (IBAction)contactUsButtonTappediPhone:(id)sender {
  ABKFeedbackViewControllerModalContext *feedbackViewController =
      [[ABKFeedbackViewControllerModalContext alloc] init];

  // We want to be notified when either "Cancel" or "Send" is tapped.
  feedbackViewController.feedbackDelegate = self;
  [self presentViewController:feedbackViewController animated:YES completion:nil];
}

// Handle the storyboard buttons by forwarding to the programmatic methods above.
- (IBAction) purchaseButtonTapped:(id)sender {
  [Crittercism leaveBreadcrumb:@"Appboy: logPurchase"];
  [[Appboy sharedInstance] logPurchase:@"stopwatch_pro" inCurrency:@"USD" atPrice:[[NSDecimalNumber alloc] initWithString:@"0.99"]];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.upgrade.thank-message", nil)
                                                      message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  alertView = nil;
}

- (IBAction) twitterButtonTapped:(id)sender {
  // Request twitter account data
  ACAccountStore *store = [[ACAccountStore alloc] init];
  ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  if ([store respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)]) {
    [store requestAccessToAccountsWithType:twitterAccountType options:nil completion:nil];
    
    // Display the iOS Twitter share panel on iOS 6 and later
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
      SLComposeViewController *tweetSheet = [SLComposeViewController
                                             composeViewControllerForServiceType:SLServiceTypeTwitter];
      [tweetSheet setInitialText:NSLocalizedString(@"Appboy.Stopwatch.initial-view.twitter-share.message", nil)];
      [self presentViewController:tweetSheet animated:YES completion:nil];
      
      tweetSheet.completionHandler = ^(SLComposeViewControllerResult res) {
        if (res == SLComposeViewControllerResultDone) {
          [self userDidShareOnTwitter];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
      };
    }
  }
}

- (void) userDidShareOnTwitter {
  UIAlertView *uiAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Appboy.Stopwatch.initial-view.twitter-share.thank-message", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                              otherButtonTitles:nil];
  [uiAlertView show];
  uiAlertView = nil;
}

#pragma Appboy feedback popover delegate methods

// These two methods are required -- this is how we know when to close the popover.  Note that tapping outside
// the feedback popover will *not* close it.  This is by design:  we don't want the user to accidentally tap outside
// and close the popover if there's text in the feedback form.
- (void) feedbackViewControllerPopoverContextCancelTapped:(ABKFeedbackViewControllerPopoverContext *)sender {
  [Crittercism leaveBreadcrumb:@"Appboy: feedback popover canceled"];
  [self.contactUsPopoverController dismissPopoverAnimated:YES];
}

// Let the user know the feedback was sent successfully, and then close the feedback form.
- (void) feedbackViewControllerPopoverContextFeedbackSent:(ABKFeedbackViewControllerPopoverContext *)sender {
  [Crittercism leaveBreadcrumb:@"Appboy: popover feedback sent"];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.feedback.thank-title", nil)
                                                       message:NSLocalizedString(@"Appboy.Stopwatch.initial-view.feedback.thank-message", nil)
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                             otherButtonTitles:nil];
  [alertView show];
  alertView = nil;

  [self.contactUsPopoverController dismissPopoverAnimated:YES];
}

#pragma Appboy feed popover delegate method
// This delegate is called when "close" is tapped on the popover.  Close it.
- (void) feedViewControllerPopoverContextCloseTapped:(ABKFeedViewControllerPopoverContext *)sender {
  [Crittercism leaveBreadcrumb:@"Appboy: feed view gets closed"];
  [self.latestNewsPopoverController dismissPopoverAnimated:YES];
}

#pragma Appboy feedback modal delegate method
// Feedback was sent successfully
- (void) feedbackViewControllerModalContextFeedbackSent:(ABKFeedbackViewControllerModalContext *)sender {
  [Crittercism leaveBreadcrumb:@"Appboy: modal feedback sent"];
  
  // Alert the user; it's good to know for sure that the feedback was sent!
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.feedback.thank-title", nil)
                                                       message:NSLocalizedString(@"Appboy.Stopwatch.initial-view.feedback.thank-message", nil)
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                             otherButtonTitles:nil];

  [alertView show];
  alertView = nil;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) feedbackViewControllerBeforeFeedbackSent:(NSString *)message {
  return [message stringByAppendingString:@": from Stopwatch"];
}

#pragma split view controller delegate methods
// Use the split view controller delegate methods to hide/display the news button on navigation bar
// when the app is in landscape/portrait orientation. 
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
  [self.navigationItem setLeftBarButtonItems:@[self.latestNewsButton, self.newsAndFeedbackButton] animated:YES];
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  [self.navigationItem setLeftBarButtonItems:@[self.newsAndFeedbackButton] animated:YES];
  if ([self.latestNewsPopoverController isPopoverVisible]) {
    [self.latestNewsPopoverController dismissPopoverAnimated:YES];
  }
}

// The stopwatch
- (IBAction) resetButtonTapped:(id)sender {
  [self.clock reset];
}

- (IBAction) startButtonTapped:(id)sender {
  if (!self.clock.clockRunning) {

    // Let's keep track of how many times the user has started the stopwatch;  let's send this data to Appboy.
    // This will give us an idea of how much or little someone is using this app.
    [Crittercism leaveBreadcrumb:@"Appboy: logCustomEvent"];
    [[Appboy sharedInstance] logCustomEvent:@"stopwatch_started"];

    [self.startButton setTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.start-button.stop", nil) forState:UIControlStateNormal];
    [self.clock start];
  }
  else {
    [self.startButton setTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.start-button.start", nil) forState:UIControlStateNormal];
    [self.clock stop];
  }
}

- (void) timeUpdated:(NSNotification *)notification {
  self.timeLabel.text = [self.clock timeString];
}

#pragma navigation controller delegate method
// use navigation controller delegate method to control the frame size of popover when feedback view
// controller is displayed
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(
    UIViewController *)viewController animated:(BOOL)animated {
  if ([viewController isKindOfClass:[ABKFeedbackViewControllerNavigationContext class]]) {
    [UIView animateWithDuration:0.5 animations:^{
      viewController.contentSizeForViewInPopover = CGSizeMake(320, 300);
    }];
  }
}

- (void) viewDidUnload {
  [self setStartButton:nil];
  [self setTimeLabel:nil];
  [self setContactUsButton:nil];
  [self setLatestNewsButton:nil];
  [self setUpgradeButton:nil];
  [self setTwitterButton:nil];
  [self setNewsAndFeedbackButton:nil];
  [self setNewsAndFeedbackNavigationController:nil];
  [super viewDidUnload];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
  }
}
@end
