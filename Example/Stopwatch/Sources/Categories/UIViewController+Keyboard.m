#import "UIViewController+Keyboard.h"

@implementation UIViewController (Keyboard)

- (void)addDismissGestureForView:(UIView *)view {
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
  tapGesture.numberOfTapsRequired = 1;
  [view addGestureRecognizer:tapGesture];
}

- (void)dismissKeyboard {
  [self.view endEditing:YES];
}

@end
