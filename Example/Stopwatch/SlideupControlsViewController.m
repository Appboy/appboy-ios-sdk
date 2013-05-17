//
//  SlideupControlsViewController.m
//
//  Copyright (c) 2013 appboy. All rights reserved.
//

#import "SlideupControlsViewController.h"

@interface SlideupControlsViewController () {
  int _slideupMode;
}
@end

@implementation SlideupControlsViewController
//
//- (void) loadView {
//  NSArray *nibArray;
//  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//    (nibArray = [[NSBundle mainBundle] loadNibNamed:@"SlideupControlsViewController_iPad" owner:self options:nil]);
//  }
//  else {
//    (nibArray = [[NSBundle mainBundle] loadNibNamed:@"SlideupControlsViewController" owner:self options:nil]);
//  }
//  if (nibArray) {
//    self.view = [nibArray objectAtIndex:0];
//  }
//  else {
//    NSLog(@"Could not load nib");
//  }
//}
//
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
    [Appboy sharedInstance].slideupDelegate = self;
    self.modeButton.enabled = YES;
    self.displayNextAvailableSlideupButton.enabled = YES;
  }
  else {
    self.modeButton.enabled = NO;
    self.displayNextAvailableSlideupButton.enabled = NO;
    [Appboy sharedInstance].slideupDelegate = nil;
  }
}

// This is the callback method which lets us specify how to handle each slideup.  It's called
// every time a slideup arrives.  See Appboy.h for details on the slideup queuing mechanism.
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
  [[Appboy sharedInstance] displayNextAvailableSlideup];
}

// This delegate method is notified if the slideup is tapped.  You can use this to initiate an action
// in response to the tap.  Note that when the delegate is *not* set, a tap on a slideup brings up
// a news feed;  when the delegate is set, the response to the tap is up to you.
- (void) slideupWasTapped {
  NSLog(@"Slideup tapped!", nil);
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
  [Appboy sharedInstance].slideupDelegate = nil;
  [super viewDidDisappear:animated];
}

- (void) viewDidUnload {
  [Appboy sharedInstance].slideupDelegate = nil;
  [self setModeButton:nil];

  [self setDelegateButton:nil];
    [self setDisplayNextAvailableSlideupButton:nil];
  [super viewDidUnload];
}
@end
