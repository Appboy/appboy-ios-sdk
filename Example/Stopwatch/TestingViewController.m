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
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    // In iOS 7, views are automatically extended to fit the size of the screen. Therefore, views may end up under
    // the navigation bar, which makes some buttons invisible or unclickable. In order to prevent this behaviour, we set
    // the Extended Layout mode to UIRectEdgeNone.
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }

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

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_flushModeButton release];
  [super dealloc];
}

- (void) viewDidUnload {
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

- (IBAction) increaseCouponClaimed:(id)sender {
  [[Appboy sharedInstance].user incrementCustomUserAttribute:@"the number of claimed coupon"];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
