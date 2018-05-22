#import "ABKNewsFeedViewController.h"
#import "ABKNewsFeedTableViewController.h"

@implementation ABKNewsFeedViewController

- (instancetype)init {
  UIStoryboard *st = [UIStoryboard storyboardWithName:@"ABKNewsFeedCardStoryboard"
                                               bundle:[NSBundle bundleForClass:[ABKNewsFeedViewController class]]];
  ABKNewsFeedViewController *nf = [st instantiateViewControllerWithIdentifier:@"ABKNewsFeedViewController"];
  self = nf;
  _newsFeed = self.viewControllers[0];
  [self addDoneButton];
  
  return self;
}

- (void)addDoneButton {
  UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(dismissNewsFeed:)];
  [self.newsFeed.navigationItem setRightBarButtonItem:closeBarButton];
}

- (IBAction)dismissNewsFeed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
