#import "ViewController.h"
#import "AppboyContentCards.h"
#import "CustomContentCardsTableViewController.h"

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
  contentCards.contentCardsViewController.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  contentCards.contentCardsViewController.navigationItem.title = @"Modal Cards";
  [self presentViewController:contentCards animated:YES completion:nil];
}

- (IBAction)displayNavigationContentCards:(id)sender {
  ABKContentCardsTableViewController *contentCards = [ABKContentCardsTableViewController getNavigationContentCardsViewController];
  contentCards.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  contentCards.navigationItem.title = @"Navigation Cards";
  [self.navigationController pushViewController:contentCards animated:YES];
}

- (IBAction)displayCustomContentCards:(id)sender {
  CustomContentCardsTableViewController *customContentCards = [[CustomContentCardsTableViewController alloc] init];
  customContentCards.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  [self.navigationController pushViewController:customContentCards animated:YES];
}
- (IBAction)changeUser:(id)sender {
  if (self.userTextField.text.length > 0) {
    NSString *userID = self.userTextField.text;
    [[Appboy sharedInstance] changeUser:userID];
  }
}

@end
