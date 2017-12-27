#import "AppDelegate.h"
#import "Appboy-iOS-SDK/AppboyKit.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSMutableDictionary *appboyOptions = [NSMutableDictionary dictionary];
  appboyOptions[ABKMinimumTriggerTimeIntervalKey] = @(5);
  appboyOptions[ABKInAppMessageControllerDelegateKey] = self;
  
  [Appboy startWithApiKey:@"cb9b6ff1-7e79-47d4-88b0-f2a9df6fc411"
            inApplication:application
        withLaunchOptions:launchOptions
        withAppboyOptions:appboyOptions];
  
  self.keyboardIsShowing = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
  return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
  self.keyboardIsShowing = YES;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
  self.keyboardIsShowing = NO;
}

- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage {
  if (self.keyboardIsShowing && [inAppMessage isKindOfClass:[ABKInAppMessageSlideup class]]) {
    ((ABKInAppMessageSlideup *)inAppMessage).inAppMessageSlideupAnchor = ABKInAppMessageSlideupFromTop;
  }

  return ABKDisplayInAppMessageNow;
}

@end
