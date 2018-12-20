#import "AppDelegate.h"
#import "Appboy-iOS-SDK/AppboyKit.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSMutableDictionary *appboyOptions = [NSMutableDictionary dictionary];
  appboyOptions[ABKMinimumTriggerTimeIntervalKey] = @(5);
  appboyOptions[ABKInAppMessageControllerDelegateKey] = self;
  
  [Appboy startWithApiKey:@"1be9b83a-58bd-4237-b794-7713e393a3f5"
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
