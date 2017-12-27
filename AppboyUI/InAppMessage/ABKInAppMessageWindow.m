#import "ABKInAppMessageWindow.h"
#import "ABKInAppMessageView.h"

@implementation ABKInAppMessageWindow

// This window intercepts taps on the host app while the in-app message is visible;  that is, taps on
// the area of the screen which isn't the in-app message.  When the user taps on the host app,
// we notify the inAppMessageViewController and pass the tap along to the host app.

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

  // See if the hit is anywhere in our view hierarchy
  UIView *hitTestResult = [super hitTest:point withEvent:event];

  // Go through the view hierarchy to see if the touch event happened inside the in-app message view. If the hit view is inside
  // the in-app message view, then we should handle it
  UIView *testView = hitTestResult;

  if (self.catchClicksOutsideInAppMessage) {
    return hitTestResult;
  } else {
    // We need to check if the testView is a valid view, as when it iterates to the root view, who doesn't has a
    // superview, then the testView will become nil, and we should get out of the loop and pass the touch event to host app's
    // window at that time. Otherwise we'll be in an infinite loop.
    while (testView != nil && ![testView isKindOfClass:[ABKInAppMessageView class]]) {
      testView = testView.superview;
    }
    if ([testView isKindOfClass:[ABKInAppMessageView class]]) {
      return hitTestResult;
    }
  }

  // Returning nil means this window's hierachy doesn't handle this event. Consequently, the event
  // will be passed to the host window.
  return nil;
}

@end
