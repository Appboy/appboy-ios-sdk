#import "SlideupTestViewController.h"
#import "Crittercism.h"
#import "CustomSlideupViewController.h"

@implementation SlideupTestViewController

/*
 * For further details regarding slideup delegate methods and stacking mechanisms, please see
 * ABKSlideupContollerDelegate.h and ABKSlideupController.h
 */

#pragma mark Appboy Slideup Delegate methods

// This delegate method is called every time a new slideup is received from the Appboy server.
// Implementing this method is OPTIONAL. The default behavior is equivalent to a return of NO from this method. In other
// words, Appboy will handle the slideup display automatically if this delegate method is not implemented.
- (BOOL) onSlideupReceived:(ABKSlideup *)slideup {
  //Return NO when you want Appboy to handle the slideup display.
  return NO;
}

/*!
 * This callback method allows you to specify if each slideup should be displayed. It is called just before each slideup
 * is displayed.
 *
 * Return values for beforeSlideupDisplayed:withKeyboardIsUp:
 *   ABKDisplaySlideupNow - The slideup gets displayed immediately.
 *   ABKDisplaySlideupLater - Put this slideup back to stack for later display.
 *   ABKDiscardSlideup - Completely discard the slideup.
 *
 * Slideup queuing:
 *
 * Arriving slideups are stacked when they can't be displayed for one of these reasons:
 * - Another slideup is visible
 * - If the beforeSlideupDisplayed:withKeyboardIsUp: delegate method HAS NOT been implemented and keyboard is being
 *   displayed currently.
 * - If the beforeSlideupDisplayed:withKeyboardIsUp: delegate method returned ABKDisplaySlideupLater
 *
 * Slideups are potentially removed from the slideup stack and displayed when:
 * - Another slideup arrives and onSlideupReceived: DOES NOT return YES.
 * - The application comes to the foreground after being backgrounded
 * - displayNextSlideupWithDelegate is called
 *
 * If one of these events occurs and the slideup can't be displayed, it remains in the stack.
 *
 * Note that if you unset the slideupDelegate after some slideups have been stacked, the accumulated stacked slideups
 * will be displayed according to the above scheme.
 */
- (ABKSlideupDisplayChoice) beforeSlideupDisplayed:(ABKSlideup *)slideup
                                  withKeyboardIsUp:(BOOL)keyboardIsUp {
  NSLog(@"Received slideup with message: %@", slideup.message);
  slideup.hideChevron = YES;

  // Set up the slideup's anchor and dismiss type based on slideupAnchorButton and slideupDismissTypeButton's  content.
  if (self.slideupAnchorSegmentedControl.selectedSegmentIndex == 0) {
    slideup.slideupAnchor = ABKSlideupFromBottom;
  } else {
    slideup.slideupAnchor = ABKSlideupFromTop;
  }
  // We want to display the slideup from the top if there is a keyboard being displayed on the screen.
  if (keyboardIsUp) {
    slideup.slideupAnchor = ABKSlideupFromTop;
  }

  if (self.slideupDismissTypeSegmentedControl.selectedSegmentIndex == 0) {
    slideup.slideupDismissType = ABKSlideupDismissAutomatically;
  } else {
    slideup.slideupDismissType = ABKSlideupDismissBySwipe;
  }

  // /Check if the delegate is called by a click on the "Display Next Available slideup" button.
  if (self.shouldDisplaySlideup && self.segmentedControlForSlideupMode.selectedSegmentIndex == 1) {
    // If the slideup mode is ABKDisplaySlideupLater and the user has clicked the "Display Next Available Slideup"
    // button, this will display the next available slideup.
    return ABKDisplaySlideupNow;
  } else {
    switch (self.segmentedControlForSlideupMode.selectedSegmentIndex) {
      case 0:
        return ABKDisplaySlideupNow;

      case 1:
        return ABKDisplaySlideupLater;

      case 2:
        return ABKDiscardSlideup;

      default:
        return ABKDisplaySlideupNow;
    }
  }
}

// This delegate method asks if there is any custom slideup view controller that developers want to pass in. The returned
// view controller should be a subclass of ABKSlideupViewController. Alternatively, it can also be an instance of
// ABKSlideupViewController. Also, the view of the returned view controller should be an instance of ABKSlideupView or
// its subclass.
- (ABKSlideupViewController *) slideupViewControllerWithSlideup:(ABKSlideup *)slideup {
  CustomSlideupViewController *customSlideup = [[[CustomSlideupViewController alloc] initWithSlideup:slideup] autorelease];
  return customSlideup;
}

// This delegate method is notified if the slideup is tapped.  You can use this to initiate an action
// in response to the tap.  Note that when the delegate returns NO, Appboy SDK will perform the action sent down from
// the Appboy Server after the delegate method is executed. If it returns YES, the response to the tap is up to you.
- (BOOL) onSlideupClicked:(ABKSlideup *)slideup {
  NSLog(@"Slideup tapped!");
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch", nil)
                                                      message:NSLocalizedString(@"Appboy.Stowpatch.slideup-test.slideup-is-tap", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  [alertView release];
  [slideup setSlideupClickActionToNone];
  // Returning YES here to prevent Appboy from performing the click action.
  return YES;
}

#pragma mark Stopwatch view controller methods

- (void) viewDidLoad {
  [super viewDidLoad];

  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    // In iOS 7, views are automatically extended to fit the size of the screen. Therefore, views may end up under
    // the navigation bar, which makes some buttons invisible or unclickable. In order to prevent this behaviour, we set
    // the Extended Layout mode to UIRectEdgeNone.
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // Here we set self as the slideup controller delegate to enable slideup customization on this page.
  [Appboy sharedInstance].slideupController.delegate = self;
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [Appboy sharedInstance].slideupController.delegate = nil;
}
// If we've been returning ABKDisplaySlideupLater and slideups have arrived, they'll be put in the stack.  Here, take
// one off the stack and display it.
- (IBAction) displayNextAvailableSlideupPressed:(id)sender {
  [Crittercism leaveBreadcrumb:@"display next available slideup"];

  self.shouldDisplaySlideup = YES;
  [[Appboy sharedInstance].slideupController displayNextSlideupWithDelegate:self];
  self.shouldDisplaySlideup = NO;
}

- (void) dealloc {
  [_segmentedControlForSlideupMode release];
  [_displayNextAvailableSlideupButton release];
    [_slideupAnchorSegmentedControl release];
    [_slideupDismissTypeSegmentedControl release];
  [super dealloc];
}

- (void) viewDidUnload {
  [Crittercism leaveBreadcrumb:@"slideup delegate is nil now"];
  [self setSegmentedControlForSlideupMode:nil];
  [self setDisplayNextAvailableSlideupButton:nil];
    [self setSlideupAnchorSegmentedControl:nil];
    [self setSlideupDismissTypeSegmentedControl:nil];
  [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)createAndDisplayACustomSlideup:(id)sender {
  [Crittercism leaveBreadcrumb:@"create and display a custom slideup"];
  
  ABKSlideup *customSlideup = [[ABKSlideup alloc] init];
  customSlideup.message = NSLocalizedString(@"Appboy.Stowpatch.slideup-test.custom-slideup-message", nil);
  customSlideup.duration = 2.5;
  self.shouldDisplaySlideup = YES;
  [[Appboy sharedInstance].slideupController addSlideup:customSlideup];
  self.shouldDisplaySlideup = NO;
  [customSlideup release];
}

- (IBAction)dismissCurrentSlideup:(id)sender {
  [[Appboy sharedInstance].slideupController hideCurrentSlideup:YES];
}

@end
