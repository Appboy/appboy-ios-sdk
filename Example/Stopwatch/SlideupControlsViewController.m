#import "SlideupControlsViewController.h"
#import "Crittercism.h"

@implementation SlideupControlsViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  [Appboy sharedInstance].slideupDelegate = self;
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    // In iOS 7, views are automatically extended to fit the size of the screen. Therefore, views may end up under
    // the navigation bar, which makes some buttons invisible or unclickable. In order to prevent this behaviour, we set
    // the Extended Layout mode to UIRectEdgeNone.
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

/*!
 * This is the callback method which lets us specify how to handle each slideup.  It's called
 * every time a slideup arrives.  See Appboy.h for details on the slideup queuing mechanism.
 *
 * Return values for shouldDisplaySlideup
 *   Immediate - A slideup that gets displayed immediately AFTER the user opens the app,
 *               bypassing slideups which may be queued. If the slideup cannot be displayed, it will be queued.
 *   Ignore - Completely discard arriving slideups.
 *   Queue - Queue arriving slideups for later display.
 *
 * Slideup queuing:
 *
 * Arriving slideups are queued when they can't be displayed for one of these reasons:
 * - Another slideup is visible
 * - The keyboard is up
 * - A feed view is being displayed as the result of a prior slideup being tapped
 * - If the shouldDisplaySlideup delegate method returned ABKSlideupShouldQueue
 *
 * Slideups are potentially dequeued and displayed when:
 * - Another slideup arrives
 * - The application comes to the foreground after being backgrounded
 * - A slideup tap-initiated feed view closes
 * - displayNextAvailableSlideup is called
 *
 * If one of these events occurs and the slideup can't be displayed, it remains in the queue.
 *
 * Note that if you unset the slideupDelegate after some slideups have been queued, the accumulated queued slideups
 * will be displayed according to the above scheme.
 */
- (ABKSlideupShouldDisplaySlideupReturnType) shouldDisplaySlideup:(ABKSlideup *)slideup {
  NSLog(@"Received slideup with message: %@", slideup.message);
  slideup.hideChevron = YES;
  
  switch (self.segmentedControlForSlideupMode.selectedSegmentIndex) {
    case 0:
      return ABKSlideupShouldShowImmediately;
      break;
      
    case 1:
      return ABKSlideupShouldQueue;
      break;
      
    case 2:
      return ABKSlideupShouldIgnore;
      break;
      
    default:
      return ABKSlideupShouldShowImmediately;
      break;
  }
}

// If we've been returning ABKSlideupShouldQueue and slideups have arrived, they'll be queued.  Here, take
// one off the queue and show it.
- (IBAction) displayNextAvailableSlideupPressed:(id)sender {
  [Crittercism leaveBreadcrumb:@"display next available slideup"];
  [[Appboy sharedInstance] displayNextAvailableSlideup];
}

// This delegate method is notified if the slideup is tapped.  You can use this to initiate an action
// in response to the tap.  Note that when the delegate is *not* set, a tap on a slideup brings up
// a news feed;  when the delegate is set, the response to the tap is up to you.
- (void) slideupWasTapped:(ABKSlideup *)slideup {
  NSLog(@"Slideup tapped!");
}

- (void) dealloc {
  [_segmentedControlForSlideupMode release];
  [_displayNextAvailableSlideupButton release];
  [super dealloc];
}

- (void) viewDidUnload {
  [Crittercism leaveBreadcrumb:@"slideup delegate is nil now"];
  [Appboy sharedInstance].slideupDelegate = nil;
  [self setSegmentedControlForSlideupMode:nil];
  [self setDisplayNextAvailableSlideupButton:nil];
  [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
