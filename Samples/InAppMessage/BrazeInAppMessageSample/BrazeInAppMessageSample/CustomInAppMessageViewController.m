#import "CustomInAppMessageViewController.h"

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
  [self hideInAppMessage:YES];
}

@end
