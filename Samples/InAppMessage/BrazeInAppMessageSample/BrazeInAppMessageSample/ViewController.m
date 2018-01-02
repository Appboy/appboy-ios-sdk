#import "ViewController.h"
#import "CustomInAppMessageViewController.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[Appboy sharedInstance].inAppMessageController.inAppMessageUIController setInAppMessageUIDelegate:self];
}

- (ABKInAppMessageViewController *)inAppMessageViewControllerWithInAppMessage:(ABKInAppMessage *)inAppMessage {
  if (self.useCustomViewControllerSwitch.isOn) {
    return [[CustomInAppMessageViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    return [[ABKInAppMessageSlideupViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageModal class]]) {
    return [[ABKInAppMessageModalViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageFull class]]) {
    return [[ABKInAppMessageFullViewController alloc] initWithInAppMessage:inAppMessage];
  } else if ([inAppMessage isKindOfClass:[ABKInAppMessageHTMLFull class]]) {
    return [[ABKInAppMessageHTMLFullViewController alloc] initWithInAppMessage:inAppMessage];
  } else {
    return [[CustomInAppMessageViewController alloc] initWithInAppMessage:inAppMessage];
  }
  return nil;
}

- (BOOL)onInAppMessageClicked:(ABKInAppMessage *)inAppMessage {
  NSLog(@"In-app message tapped!");
  return NO;
}

- (IBAction)changeUser:(id)sender {
  if (self.userIDTextField.text.length > 0) {
    NSString *userID = self.userIDTextField.text;
    [[Appboy sharedInstance] changeUser:userID];
  }
}

- (IBAction)logCustomEvent:(id)sender {
  if (self.customEventTextField.text.length > 0) {
    NSString *customEvent = self.customEventTextField.text;
    [[Appboy sharedInstance] logCustomEvent:customEvent];
  }
}

@end
