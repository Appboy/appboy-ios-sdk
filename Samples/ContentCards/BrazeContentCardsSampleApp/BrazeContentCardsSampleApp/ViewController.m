#import "ViewController.h"
#import "AppboyContentCards.h"

@interface ViewController () <ABKContentCardsTableViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *userId = [Appboy sharedInstance].user.userID;
  if (userId != nil) {
    self.userTextField.text = userId;
  }
}

- (IBAction)displayModalContentCards:(id)sender {
  ABKContentCardsViewController *contentCards = [[ABKContentCardsViewController alloc] init];
  contentCards.contentCardsViewController.delegate = self;
  contentCards.contentCardsViewController.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  contentCards.contentCardsViewController.navigationItem.title = @"Modal Cards";
  [self presentViewController:contentCards animated:YES completion:nil];
}

- (IBAction)displayNavigationContentCards:(id)sender {
  ABKContentCardsTableViewController *contentCards = [ABKContentCardsTableViewController getNavigationContentCardsViewController];
  contentCards.delegate = self;
  contentCards.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  contentCards.navigationItem.title = @"Navigation Cards";
  [self.navigationController pushViewController:contentCards animated:YES];
}

// Currently unavailable
- (IBAction)displayCustomContentCards:(id)sender {
  NSLog(@"Custom Feed currently unavailable");
}

- (IBAction)changeUser:(id)sender {
  if (self.userTextField.text.length > 0) {
    NSString *userID = self.userTextField.text;
    [[Appboy sharedInstance] changeUser:userID];
  }
}

#pragma mark - ABKContentCardsTableViewControllerDelegate

- (BOOL)contentCardTableViewController:(ABKContentCardsTableViewController *)viewController
                 shouldHandleCardClick:(NSURL *)url {
  NSLog(@"%@", NSStringFromSelector(_cmd));
  return YES;
}

- (void)contentCardTableViewController:(ABKContentCardsTableViewController *)viewController
                    didHandleCardClick:(NSURL *)url {
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
