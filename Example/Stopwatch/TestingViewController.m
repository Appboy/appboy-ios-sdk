//
//  TestingViewController.m
//
//  Copyright (c) 2013 Appboy. All rights reserved.
//

#import "TestingViewController.h"
#import "SlideupControlsViewController.h"
#import "AppboyKit.h"

@implementation TestingViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.enableAppboySwitch.on = [Appboy sharedInstance].enabled;
  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Cards: %d", [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:@"Total cards: %d", [Appboy sharedInstance].cardCount];

  // The ABKFeedUpdatedNotification is posted whenever the news feed changes.  We'll listen to it
  // so we know when to update the card count display.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(feedUpdated:)
                                               name:ABKFeedUpdatedNotification
                                             object:nil];
}

- (void) feedUpdated:(NSNotification *)notification {
  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Cards: %d", [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:@"Total cards: %d", [Appboy sharedInstance].cardCount];
  [self.view setNeedsDisplay];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // Refresh these every time we come to the testing screen
}

- (IBAction) enableAppboySwitchChanged:(id)sender {
  [Appboy sharedInstance].enabled = self.enableAppboySwitch.on;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_enableAppboySwitch release];
  [super dealloc];
}

- (void) viewDidUnload {
  [self setEnableAppboySwitch:nil];
  [super viewDidUnload];
}
@end
