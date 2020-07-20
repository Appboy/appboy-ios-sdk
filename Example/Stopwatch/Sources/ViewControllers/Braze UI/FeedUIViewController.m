#import <Foundation/Foundation.h>
#import "FeedUIViewController.h"
#import "UIViewController+Keyboard.h"
#import "ABKNewsFeedTableViewController.h"
#import "ABKNewsFeedViewController.h"
#import "AlertControllerUtils.h"
#import "ABKContentCardsViewController.h"
#import "AppDelegate.h"
#import "ColorUtils.h"

@interface FeedUIViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

- (void)updateScrollViewContentSize;

@end

@implementation FeedUIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set number of unread and total news feed cards
  [self feedUpdated:nil];
  [self contentCardsUpdated:nil];
  
  // The ABKFeedUpdatedNotification is posted whenever the news feed changes.  We'll listen to it
  // so we know when to update the card count display.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(feedUpdated:)
                                               name:ABKFeedUpdatedNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentCardsUpdated:)
                                               name:ABKContentCardsProcessedNotification
                                             object:nil];

  [self addDismissGestureForView:self.scrollView];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateScrollViewContentSize];
}

#pragma mark - Scroll view settings

- (void)updateScrollViewContentSize {
  self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.contentViewHeightConstraint.constant);
}

#pragma mark - Notification updates

- (void)feedUpdated:(NSNotification *)notification {
  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Feed Cards: %ld / %ld",
                               (long)[[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll],
                               (long)[[Appboy sharedInstance].feedController cardCountForCategories:ABKCardCategoryAll]];
  
  // Update the application icon badge count to reflect the number of unread news feed cards
  [UIApplication sharedApplication].applicationIconBadgeNumber =
  [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll];
  [self.view setNeedsDisplay];
}

- (void)contentCardsUpdated:(NSNotification *)notification {
  self.unreadContentCardLabel.text = [NSString stringWithFormat:@"Unread Content Cards: %ld / %ld",
                                      (long)[Appboy sharedInstance].contentCardsController.unviewedContentCardCount,
                                      (long)[Appboy sharedInstance].contentCardsController.contentCardCount];
  [self.view setNeedsDisplay];
}

#pragma mark - Categoried News

- (IBAction)displayCategoriedNews:(id)sender {
  ABKNewsFeedTableViewController *newsFeed = [ABKNewsFeedTableViewController getNavigationFeedViewController];
  newsFeed.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  // Add Categories button
  UIBarButtonItem *categoriesButton = [[UIBarButtonItem alloc]
                                       initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.button.title", nil)
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(displayCategoriesActionSheet)];
  [newsFeed.navigationItem setRightBarButtonItem:categoriesButton animated:NO];
  [self.navigationController pushViewController:newsFeed animated:YES];
}

- (void)displayCategoriesActionSheet {
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.title", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  ABKNewsFeedTableViewController *feedTableViewController = (ABKNewsFeedTableViewController *)self.navigationController.topViewController;
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.Announcement", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:^{
      [feedTableViewController setCategories:ABKCardCategoryAnnouncements];
    }];
  }]];
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.Advertising", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:^{
      [feedTableViewController setCategories:ABKCardCategoryAdvertising];
    }];
  }]];
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.Social", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:^{
      [feedTableViewController setCategories:ABKCardCategorySocial];
    }];
  }]];
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.News", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:^{
      [feedTableViewController setCategories:ABKCardCategoryNews];
    }];
  }]];
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.test-view.categories.No-Category", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:^{
      [feedTableViewController setCategories:ABKCardCategoryNoCategory];
    }];
  }]];
  [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
  }]];

  [self presentViewController:actionSheet animated:YES completion:nil];
}

# pragma mark - Feed

// An example modal news feed view controller
- (IBAction)modalNewsFeedButtonTapped:(id)sender {
  ABKNewsFeedViewController *newsFeed = [[ABKNewsFeedViewController alloc] init];
  newsFeed.newsFeed.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  newsFeed.newsFeed.navigationItem.title = @"Stopwatch Modal Feed";
  [self.navigationController presentViewController:newsFeed animated:YES completion:nil];
}

- (IBAction)navigationNewsFeedButtonTapped:(id)sender {
  ABKNewsFeedTableViewController *newsFeed = [ABKNewsFeedTableViewController getNavigationFeedViewController];
  newsFeed.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  newsFeed.navigationItem.title = @"Stopwatch Navigation Feed";
  [self.navigationController pushViewController:newsFeed animated:YES];
}

# pragma mark - Content Cards

- (IBAction)modalContentCardsButtonTapped:(id)sender {
  ABKContentCardsViewController *contentCardsVC = [ABKContentCardsViewController new];
  contentCardsVC.contentCardsViewController.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  contentCardsVC.contentCardsViewController.navigationItem.title = @"Stopwatch Modal Cards";
  contentCardsVC.contentCardsViewController.maxContentCardWidth = 1024.0;
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  contentCardsVC.contentCardsViewController.enableDarkTheme = appDelegate.stopwatchEnableDarkTheme;
  [ColorUtils applyThemeToViewController:contentCardsVC];
  [self.navigationController presentViewController:contentCardsVC animated:YES completion:nil];
}

- (IBAction)navigationContentCardsButtonTapped:(id)sender {
  ABKContentCardsTableViewController *contentCards = [ABKContentCardsTableViewController getNavigationContentCardsViewController];
  contentCards.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  contentCards.navigationItem.title = @"Stopwatch Navigation Cards";
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  contentCards.enableDarkTheme = appDelegate.stopwatchEnableDarkTheme;
  [ColorUtils applyThemeToViewController:contentCards];
  [self.navigationController pushViewController:contentCards animated:YES];
}

#pragma mark - Transition

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  // updating content size when interface orientation changes
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {} completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    [self updateScrollViewContentSize];
  }];
}

@end
