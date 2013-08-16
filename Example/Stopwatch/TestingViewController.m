#import "TestingViewController.h"
#import "SlideupControlsViewController.h"
#import "AppboyKit.h"

@implementation TestingViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  NSString *flushMode = nil;
  ABKRequestProcessingPolicy requestPolicy = [Appboy sharedInstance].requestProcessingPolicy;
  switch (requestPolicy) {
    case ABKAutomaticRequestProcessing:
      flushMode = @"ABKAutomaticRequestProcessing";
      break;
      
    case ABKAutomaticRequestProcessingExceptForDataFlush:
      flushMode = @"ABKAutomaticRequestProcessingExceptForDataFlush";
      break;
      
    case ABKManualRequestProcessing:
      flushMode = @"ABKManualRequestProcessing";
      break;
      
    default:
      break;
  }
  self.flushModeButton.titleLabel.text = flushMode;
  [self.flushModeButton setNeedsDisplay];

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

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_enableAppboySwitch release];
  [_ratedScoreLabel release];
  [_flushModeButton release];
  [super dealloc];
}

- (void) viewDidUnload {
  [self setEnableAppboySwitch:nil];
  [self setRatedScoreLabel:nil];
  [self setFlushModeButton:nil];
  [super viewDidUnload];
}
- (IBAction) FlushAppboyData:(id)sender {
  NSLog(@"FlushAppboyData:");
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
}

- (IBAction) changeAppboyFlushMode:(id)sender {
  NSLog(@"changeAppboyFlushMode:");
  switch ([Appboy sharedInstance].requestProcessingPolicy) {
    case ABKAutomaticRequestProcessing:
      [Appboy sharedInstance].requestProcessingPolicy = ABKAutomaticRequestProcessingExceptForDataFlush;
      self.flushModeButton.titleLabel.text = @"ABKAutomaticRequestProcessingExceptForDataFlush";
      break;
      
    case ABKAutomaticRequestProcessingExceptForDataFlush:
      [Appboy sharedInstance].requestProcessingPolicy = ABKManualRequestProcessing;
      self.flushModeButton.titleLabel.text = @"ABKManualRequestProcessing";
      break;
      
    case ABKManualRequestProcessing:
      [Appboy sharedInstance].requestProcessingPolicy = ABKAutomaticRequestProcessing;
      self.flushModeButton.titleLabel.text = @"ABKAutomaticRequestProcessing";
      break;
      
    default:
      break;
  }
  [self.flushModeButton setNeedsDisplay];
}

- (IBAction) flushAndShutDownAppboy:(id)sender {
  [[Appboy sharedInstance] flushDataAndProcessRequestQueue];
  [[Appboy sharedInstance] shutdownServerCommunication];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
