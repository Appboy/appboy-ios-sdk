#import "TestingViewController.h"
#import "InAppMessageTestViewController.h"
#import <AppboyKit.h>

@implementation TestingViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  self.unreadCardLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.unread-card.message", nil), [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll]];
  self.totalCardsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.total-card.message", nil), [[Appboy sharedInstance].feedController cardCountForCategories:ABKCardCategoryAll]];
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
  self.unreadCardLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.unread-card.message", nil), [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll]];
  self.totalCardsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Appboy.Stopwatch.test-view.total-card.message", nil), [[Appboy sharedInstance].feedController cardCountForCategories:ABKCardCategoryAll]];
  [self.view setNeedsDisplay];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidUnload {
  [self setVersionLabel:nil];
  [self setUnReadIndicatorSwitch:nil];
  [super viewDidUnload];
}

- (IBAction) increaseCouponClaimed:(id)sender {
  [[Appboy sharedInstance].user incrementCustomUserAttribute:@"the number of claimed coupon"];
}

- (IBAction)displayCategoriedNews:(id)sender {
  ABKFeedViewControllerNavigationContext *newsFeed = [[ABKFeedViewControllerNavigationContext alloc] init];
  newsFeed.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  // Add Categories button
  UIBarButtonItem *categoriesButton = [[UIBarButtonItem alloc]
                                       initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.button.title", nil)
                                                      style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(displayCategoriesActionSheet)];
  [newsFeed.navigationItem setRightBarButtonItem:categoriesButton animated:NO];
  [self.navigationController pushViewController:newsFeed animated:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void) displayCategoriesActionSheet {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.title", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.cancel", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.All", nil),
                                                                    NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.Announcement", nil),
                                                                    NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.Advertising", nil),
                                                                    NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.Social", nil),
                                                                    NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.News", nil),
                                                                    NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.No-Category", nil), nil];

  [actionSheet showInView:self.navigationController.visibleViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  ABKFeedViewControllerNavigationContext *newsFeed = (ABKFeedViewControllerNavigationContext *)self.navigationController.topViewController;
  switch (buttonIndex) {
    case 0:
      [newsFeed setCategories:ABKCardCategoryAll];
      break;
      
    case 1:
      [newsFeed setCategories:ABKCardCategoryAnnouncements];
      break;
      
    case 2:
      [newsFeed setCategories:ABKCardCategoryAdvertising];
      break;
      
    case 3:
      [newsFeed setCategories:ABKCardCategorySocial];
      break;
      
    case 4:
      [newsFeed setCategories:ABKCardCategoryNews];
      break;
      
    case 5:
      [newsFeed setCategories:ABKCardCategoryNoCategory];
      break;
      
    default:
      break;
  }
}

@end
