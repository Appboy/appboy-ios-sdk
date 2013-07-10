//
//  SlideupControlsViewController.m
//
//  Copyright (c) 2013 appboy. All rights reserved.
//

#import "SlideupControlsViewController.h"
#import "Crittercism.h"

@interface SlideupControlsViewController () {
  int _slideupMode;
}
@end

@implementation SlideupControlsViewController

- (void) viewDidLoad {
  [super viewDidLoad];

  _slideupMode = self.modeButton.selectedSegmentIndex;
  [self delegateButtonSwitched:self];

  // Delegate will be off by default
  self.delegateButton.on = NO;
  self.modeButton.enabled = NO;
  self.displayNextAvailableSlideupButton.enabled = NO;
}

// Use the slideupDelegate to control when slideups will appear, be queued, or be ignored.  If the delegate
// is not set, slideups will appear as they arrive.
- (IBAction) delegateButtonSwitched:(id)sender {
  if (self.delegateButton.on) {
    [Crittercism leaveBreadcrumb:@"slideup delegate is slideup controls view controller"];
    [Appboy sharedInstance].slideupDelegate = self;
    self.modeButton.enabled = YES;
    self.displayNextAvailableSlideupButton.enabled = YES;
  }
  else {
    self.modeButton.enabled = NO;
    self.displayNextAvailableSlideupButton.enabled = NO;
    [Crittercism leaveBreadcrumb:@"slideup delegate is nil now"];
    [Appboy sharedInstance].slideupDelegate = nil;
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
- (ABKSlideupShouldDisplaySlideupReturnType) shouldDisplaySlideup:(NSString *)message {
  if (_slideupMode == 0) {
    return ABKSlideupShouldShowImmediately;
  }
  else if (_slideupMode == 1) {
    return ABKSlideupShouldQueue;
  }
  else if (_slideupMode == 2) {
    return ABKSlideupShouldIgnore;
  }
  return ABKSlideupShouldShowImmediately;
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
- (void) slideupWasTapped {
  NSLog(@"Slideup tapped!");
}

- (IBAction) modeButtonChanged:(UISegmentedControl *)sender {
  _slideupMode = sender.selectedSegmentIndex;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void) dealloc {
  [_modeButton release];

  [_delegateButton release];
    [_displayNextAvailableSlideupButton release];
  [super dealloc];
}

- (void) viewDidDisappear:(BOOL)animated {
  [Crittercism leaveBreadcrumb:@"slideup delegate is nil now"];
  [Appboy sharedInstance].slideupDelegate = nil;
  [super viewDidDisappear:animated];
}

- (void) viewDidUnload {
  [Crittercism leaveBreadcrumb:@"slideup delegate is nil now"];
  [Appboy sharedInstance].slideupDelegate = nil;
  [self setModeButton:nil];

  [self setDelegateButton:nil];
    [self setDisplayNextAvailableSlideupButton:nil];
  [super viewDidUnload];
}
@end
