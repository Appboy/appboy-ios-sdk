#import <Foundation/Foundation.h>
#import "FeedAndFeedbackUIViewController.h"
#import "ABKNavigationFeedbackViewController.h"
#import "ABKModalFeedbackViewController.h"

@implementation FeedAndFeedbackViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set number of unread and total news feed cards
  [self feedUpdated:nil];
  
  // The ABKFeedUpdatedNotification is posted whenever the news feed changes.  We'll listen to it
  // so we know when to update the card count display.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(feedUpdated:)
                                               name:ABKFeedUpdatedNotification
                                             object:nil];
  
  // Prepare News and Feedback UIButton, plus related properties and functions
  ABKFeedViewControllerNavigationContext *feedViewController = [[ABKFeedViewControllerNavigationContext alloc] init];
  self.newsAndFeedbackNavigationController = [[UINavigationController alloc] initWithRootViewController:feedViewController];
  self.newsAndFeedbackNavigationController.delegate = self;
  self.newsAndFeedbackNavigationController.navigationBar.tintColor = [UIColor colorWithRed:0.16 green:0.5 blue:0.73 alpha:1.0];
  self.newsAndFeedbackNavigationController.navigationBar.barStyle = UIBarStyleBlack;
  UIBarButtonItem *feedbackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.feedback", nil)
                                                                            style:UIBarButtonItemStylePlain target:self action:@selector(openFeedbackFromNavigationFeed:)];
  feedViewController.navigationItem.rightBarButtonItem = feedbackBarButtonItem;
  feedViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Appboy.Stopwatch.initial-view.cancel", nil)
                                                                                         style:UIBarButtonItemStylePlain
                                                                                        target:self
                                                                                        action:@selector(dismissNewsAndFeedbackModalView:)];
}

#pragma mark News Feed Card Count

- (void)feedUpdated:(NSNotification *)notification {
  self.unreadCardLabel.text = [NSString stringWithFormat:@"Unread Feed Cards: %ld / %ld", [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll], [[Appboy sharedInstance].feedController cardCountForCategories:ABKCardCategoryAll]];
  
  // Update the application icon badge count to reflect the number of unread news feed cards
  [UIApplication sharedApplication].applicationIconBadgeNumber = [[Appboy sharedInstance].feedController unreadCardCountForCategories:ABKCardCategoryAll];
  [self.view setNeedsDisplay];
}

#pragma mark News and Feedback Button
// Example of Appboy in one action: a button that opens the News Feed page, on which there is a Feedback button

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

#pragma mark Categoried News

- (IBAction)displayCategoriedNews:(id)sender {
  ABKFeedViewControllerNavigationContext *newsFeed = [[ABKFeedViewControllerNavigationContext alloc] init];
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

#pragma mark Modal Contexts

// An example modal news feed view controller
- (IBAction)modalNewsFeedButtonTapped:(id)sender {
  ABKFeedViewControllerModalContext *modalFeed = [[ABKFeedViewControllerModalContext alloc] init];
  modalFeed.navigationBarTitle = @"News And Updates";
  
  // Setting the delegate will notify us when the "Done" button is tapped
  modalFeed.closeButtonDelegate = self;
  [self presentViewController:modalFeed animated:YES completion:nil];
}

- (void)feedViewControllerModalContextCloseTapped:(ABKFeedViewControllerModalContext *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

// An example modal feedback view controller
- (IBAction)modalFeedbackButtonTapped:(id)sender {
  ABKModalFeedbackViewController *modalFeedback = [[ABKModalFeedbackViewController alloc] init];
  [self presentViewController:modalFeedback animated:YES completion:nil];
}

# pragma mark Feedback

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
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                          message:feedbackAlertMessage
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"Appboy.Stopwatch.alert.cancel-button.title", nil)
                                                otherButtonTitles:nil];
      [alertView show];
      alertView = nil;
    });
  }];
}

@end
