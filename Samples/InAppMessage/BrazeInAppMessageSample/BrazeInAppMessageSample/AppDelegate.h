#import <UIKit/UIKit.h>
#import "ABKInAppMessageControllerDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ABKInAppMessageControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL keyboardIsShowing;

@end
