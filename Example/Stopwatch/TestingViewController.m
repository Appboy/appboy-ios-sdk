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

  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Cards: %d", [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:@"Total Cards: %d", [Appboy sharedInstance].cardCount];

  // The ABKFeedUpdatedNotification is posted whenever the news feed changes.  We'll listen to it
  // so we know when to update the card count display.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(feedUpdated:)
                                               name:ABKFeedUpdatedNotification
                                             object:nil];

  [[Appboy sharedInstance].user setCustomAttributeWithKey:@"rating score" andIntegerValue:10];
}

- (void) feedUpdated:(NSNotification *)notification {
  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Cards: %d", [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:@"Total Cards: %d", [Appboy sharedInstance].cardCount];
  [self.view setNeedsDisplay];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // Refresh these every time we come to the testing screen
}


- (IBAction)ratingStepperChanged:(UIStepper *)sender {
  if ([self.ratedScoreLabel.text integerValue] > sender.value) {
    [[Appboy sharedInstance].user incrementCustomUserAttribute:@"rating score" by:-1];
  } else if ([self.ratedScoreLabel.text integerValue] < sender.value) {
    [[Appboy sharedInstance].user incrementCustomUserAttribute:@"rating score"];
  }
  self.ratedScoreLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_enableAppboySwitch release];
  [_ratedScoreLabel release];
  [super dealloc];
}

- (void) viewDidUnload {
  [self setEnableAppboySwitch:nil];
  [self setRatedScoreLabel:nil];
  [super viewDidUnload];
}
@end
