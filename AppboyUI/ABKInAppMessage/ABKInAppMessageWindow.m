#import "ABKInAppMessageWindow.h"
#import "ABKInAppMessageView.h"
#import "ABKUIUtils.h"

@implementation ABKInAppMessageWindow

// Touches handled by ABKInAppMessageWindow:
// - all if `handleAllTouchEvents == YES`
// - in `ABKInAppMessageView` or one of its subviews
// - in `UIAlertController` or one of its previous responder so that alerts
//   presented can be interacted with (e.g. `window.alert()` in an HTML in-app
//   message)
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

  // Get the view in the hierarchy that contains the point
  UIView *hitTestResult = [super hitTest:point withEvent:event];
  
  // Handles the touch event
  if (self.handleAllTouchEvents ||
      [ABKUIUtils responderChainOf:hitTestResult hasKindOfClass:[ABKInAppMessageView class]] ||
      [ABKUIUtils responderChainOf:hitTestResult hasKindOfClass:[UIAlertController class]]) {
    return hitTestResult;
  }

  return nil;
}

@end
