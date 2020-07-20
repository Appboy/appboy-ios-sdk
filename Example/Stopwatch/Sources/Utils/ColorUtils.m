#import "ColorUtils.h"

@implementation ColorUtils

+ (UIColor *)stopwatchBlueColor {
  return [UIColor colorWithRed:(14.0/255.0) green:(32.0/255.0) blue:(65.0/255.0) alpha:1.0];
}

+ (void)applyThemeToViewController:(UIViewController *)viewController {
  // No-op for iOS versions earlier than 13, haven't implemented theme support for those versions
  if (@available(iOS 13.0, *)) {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:StopwatchInAppThemeSettingsKey] == StopwatchInAppThemeDark) {
      // Force dark mode regardless of user settings in OS.
      viewController.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:StopwatchInAppThemeSettingsKey] == StopwatchInAppThemeLight) {
      // Force light mode regardless of user settings in OS.
      viewController.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
      // Default theme behavior will leave the OS settings alone.
      // This value will respect the system UI style of dark or light mode
      viewController.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
    for (UIViewController *childVC in viewController.childViewControllers) {
      [ColorUtils applyThemeToViewController:childVC];
    }
  }
}

@end
