#import "CustomSlideupViewController.h"
#import <AppboyKit.h>

static CGFloat const slideupBottomPadding = 10.0f;

@implementation CustomSlideupViewController

- (void) viewDidLoad {
  [super viewDidLoad];

  self.slideupMessageLabel.text = self.slideup.message;

  // Displays the key/value pair if sent by the server.
  if (self.slideup.extras != nil && self.slideup.extras.count > 0) {
    for (NSString *key in [self.slideup.extras allKeys]) {
      NSString *value = [self.slideup.extras objectForKey:key];
      self.slideupMessageLabel.text = [self.slideupMessageLabel.text stringByAppendingFormat:@"\n%@ : %@", key, value];
    }
  }

  // Updates the frames of custom slideup views based on the length of the message and the values within the extras.
  [self.slideupMessageLabel sizeToFit];
  self.slideupMessageLabel.center = CGPointMake(self.view.frame.size.width / 2, self.slideupMessageLabel.center.y);
  CGRect frame = self.view.frame;
  frame.size.height = self.slideupMessageLabel.frame.origin.y + self.slideupMessageLabel.frame.size.height + slideupBottomPadding;
  self.view.frame = frame;
}

- (IBAction)closeButtonTapped:(id)sender {
  // This is a method of ABKSlideupViewController, custom slideup can call it to dismiss the slideup
  [self hideSlideup:YES];
}

- (void)dealloc {
  [_slideupMessageLabel release];
  [super dealloc];
}
- (void)viewDidUnload {
  [self setSlideupMessageLabel:nil];
  [super viewDidUnload];
}
@end
