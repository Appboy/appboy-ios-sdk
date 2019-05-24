#import <Foundation/Foundation.h>
#import "FeedAndFeedbackUIViewController.h"
#import "AppboyFeedback.h"
#import "UIViewController+Keyboard.h"
#import "ABKNewsFeedTableViewController.h"
#import "ABKNewsFeedViewController.h"
#import "AlertControllerUtils.h"
#import "ABKContentCardsViewController.h"

@interface FeedAndFeedbackViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

- (void)updateScrollViewContentSize;

@end

@implementation FeedAndFeedbackViewController

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
                               [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll],
                               [[Appboy sharedInstance].feedController cardCountForCategories:ABKCardCategoryAll]];
  
  // Update the application icon badge count to reflect the number of unread news feed cards
  [UIApplication sharedApplication].applicationIconBadgeNumber =
    [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll];
  [self.view setNeedsDisplay];
}

- (void)contentCardsUpdated:(NSNotification *)notification {
  self.unreadContentCardLabel.text = [NSString stringWithFormat:@"Unread Content Cards: %ld / %ld",
                                      [Appboy sharedInstance].contentCardsController.unviewedContentCardCount,
                                      [Appboy sharedInstance].contentCardsController.contentCardCount];
  [self.view setNeedsDisplay];
}

#pragma mark - News and Feedback Button
// Example of Braze in one action: a button that opens the News Feed page, on which there is a Feedback button

- (void)openFeedbackFromNavigationFeed:(id)sender {
  // Navigation context
  ABKNavigationFeedbackViewController *navFeedback = [[ABKNavigationFeedbackViewController alloc] init];
  [self.newsAndFeedbackNavigationController pushViewController:navFeedback animated:YES];
}

- (IBAction)newsAndFeedbackButtonTapped:(id)sender {
  [self presentViewController:self.newsAndFeedbackNavigationController animated:YES completion:nil];
}

- (void)dismissNewsAndFeedbackModalView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
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
  ABKNewsFeedTableViewController *newsFeed = (ABKNewsFeedTableViewController *)self.navigationController.topViewController;
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
  [self.navigationController presentViewController:contentCardsVC animated:YES completion:nil];
}

- (IBAction)navigationContentCardsButtonTapped:(id)sender {
  ABKContentCardsTableViewController *contentCards = [ABKContentCardsTableViewController getNavigationContentCardsViewController];
  contentCards.disableUnreadIndicator = !self.unReadIndicatorSwitch.on;
  contentCards.navigationItem.title = @"Stopwatch Navigation Cards";
  [self.navigationController pushViewController:contentCards animated:YES];
}

# pragma mark - Feedback

- (IBAction)submitInstantFeedback:(id)sender {
  ABKFeedback* feedback = [[ABKFeedback alloc] initWithFeedbackMessage:@"Submitting feedback"
                                                                email:@"test@mail.com"
                                                                isBug:NO];
  [[Appboy sharedInstance] submitFeedback:feedback withCompletionHandler:^(ABKFeedbackSentResult feedbackSentResult) {
    NSString *feedbackAlertMessage = nil;
    if (feedbackSentResult != ABKFeedbackSentSuccessfully) {
      feedbackAlertMessage = NSLocalizedString(@"Appboy.Stopwatch.feedback.fail", nil);
    } else {
      feedbackAlertMessage = NSLocalizedString(@"Feedback submitted", nil);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [AlertControllerUtils presentTemporaryAlertWithTitle:nil
                                                     message:feedbackAlertMessage
                                                presentingVC:self];
    });
  }];
}

// An example modal feedback view controller
- (IBAction)modalFeedbackButtonTapped:(id)sender {
  ABKModalFeedbackViewController *modalFeedback = [[ABKModalFeedbackViewController alloc] init];
  [self presentViewController:modalFeedback animated:YES completion:nil];
}

#pragma mark - Transition

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  // updating content size when interface orientation changes
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {} completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    [self updateScrollViewContentSize];
  }];
}

@end
