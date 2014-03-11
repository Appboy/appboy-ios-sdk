#import "TestingViewController.h"
#import "SlideupTestViewController.h"
#import "AppboyKit.h"

@implementation TestingViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  self.unreadCardLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.unread-card.message", nil), [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.total-card.message", nil), [Appboy sharedInstance].cardCount];
  self.versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.appboy-version.message", nil), APPBOY_SDK_VERSION];

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
  self.unreadCardLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.unread-card.message", nil), [Appboy sharedInstance].unreadCardCount];
  self.totalCardsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.total-card.message", nil), [Appboy sharedInstance].cardCount];
  [self.view setNeedsDisplay];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_versionLabel release];
  [super dealloc];
}

- (void) viewDidUnload {
  [self setVersionLabel:nil];
  [super viewDidUnload];
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
