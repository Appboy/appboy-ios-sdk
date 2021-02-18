#import "ViewController.h"
#import "AppboyNewsFeed.h"

@implementation ViewController

- (IBAction)displayModalNewsFeed:(id)sender {
  ABKNewsFeedViewController *newsFeed = [[ABKNewsFeedViewController alloc] init];
  newsFeed.newsFeed.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  [self presentViewController:newsFeed animated:YES completion:nil];
}

- (IBAction)displayNavigationNewsFeed:(id)sender {
  ABKNewsFeedTableViewController *newsFeed = [[ABKNewsFeedTableViewController alloc] init];
  newsFeed.disableUnreadIndicator = !self.unreadIndicatorSwitch.on;
  [self.navigationController pushViewController:newsFeed animated:YES];
}

@end
