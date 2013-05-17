//
//  TestingViewController.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "TestingViewController.h"
#import "SlideupControlsViewController.h"

@implementation TestingViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.enableAppboySwitch.on = [Appboy sharedInstance].enabled;
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // Refresh these every time we come to the testing screen
  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Cards: %d", [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:@"Total cards: %d", [Appboy sharedInstance].cardCount];
}

- (IBAction) enableAppboySwitchChanged:(id)sender {
  [Appboy sharedInstance].enabled = self.enableAppboySwitch.on;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void) dealloc {
  [_enableAppboySwitch release];
  [super dealloc];
}

- (void) viewDidUnload {
  [self setEnableAppboySwitch:nil];
  [super viewDidUnload];
}
@end
