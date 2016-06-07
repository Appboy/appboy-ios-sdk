#import "CustomInAppMessageViewController.h"

static CGFloat const inAppMessageBottomPadding = 10.0f;

@implementation CustomInAppMessageViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.inAppMessageBodyTextLabel.text = self.inAppMessage.message;

  // Displays the key/value pair if sent by the server.
  if (self.inAppMessage.extras != nil && self.inAppMessage.extras.count > 0) {
    for (NSString *key in [self.inAppMessage.extras allKeys]) {
      NSString *value = self.inAppMessage.extras[key];
      self.inAppMessageBodyTextLabel.text = [self.inAppMessageBodyTextLabel.text stringByAppendingFormat:@"\n%@ : %@", key, value];
    }
  }
}

- (IBAction)closeButtonTapped:(id)sender {
  // This is a method of ABKInAppMessageViewController, custom in-app message view controller can call it to dismiss the in-app message
  [self hideInAppMessage:YES];
}

// Create cutom animation for in-app message.
// You have to override moveInAppMessageViewOffScreen: and moveInAppMessageViewOnScreen: to create
// animation for in-app message's display and dismissal.
- (void)moveInAppMessageViewOffScreen:(CGRect)inAppMessageWindowFrame {
  self.view.frame = CGRectMake(0.0, 0.0, 1.0, 1.0);
  self.view.center = CGPointMake(inAppMessageWindowFrame.size.width / 2, inAppMessageWindowFrame.size.height / 2);
}

- (void)moveInAppMessageViewOnScreen:(CGRect)inAppMessageWindowFrame {
  CGRect onScreenViewFrame = inAppMessageWindowFrame;
  onScreenViewFrame.size.width = inAppMessageWindowFrame.size.width / 1.3f;
  self.view.frame = onScreenViewFrame;

  // Updates the frames of custom in-app message views based on the length of the message and the values within the extras.
  [self.inAppMessageBodyTextLabel sizeToFit];
  self.inAppMessageBodyTextLabel.center = CGPointMake(onScreenViewFrame.size.width / 2, self.inAppMessageBodyTextLabel.center.y);
  onScreenViewFrame.size.height = self.inAppMessageBodyTextLabel.frame.origin.y + self.inAppMessageBodyTextLabel.frame.size.height + inAppMessageBottomPadding;
  self.view.frame = onScreenViewFrame;
  self.view.center = CGPointMake(inAppMessageWindowFrame.size.width / 2, inAppMessageWindowFrame.size.height / 2);
}
@end
