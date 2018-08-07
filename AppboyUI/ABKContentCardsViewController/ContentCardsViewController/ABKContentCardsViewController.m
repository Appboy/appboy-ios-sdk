#import "ABKContentCardsViewController.h"

@implementation ABKContentCardsViewController

- (instancetype)init {
  UIStoryboard *st = [UIStoryboard storyboardWithName:@"ABKContentCardsStoryboard"
                                               bundle:[NSBundle bundleForClass:[ABKContentCardsViewController class]]];
  ABKContentCardsViewController *nf = [st instantiateViewControllerWithIdentifier:@"ABKContentCardsViewController"];
  self = nf;
  self.contentCardsViewController = self.viewControllers[0];
  [self addDoneButton];
  return self;
}

- (void)addDoneButton {
  UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(dismissContentCardsViewController:)];
  [self.contentCardsViewController.navigationItem setRightBarButtonItem:closeBarButton];
}

- (IBAction)dismissContentCardsViewController:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
