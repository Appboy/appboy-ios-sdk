#import <UIKit/UIKit.h>

/*
 * Example to show custom in app themes that override OS behavior in Content Cards
 * and InAppMessages.
 */
typedef NS_ENUM(NSInteger, StopwatchInAppThemes) {
  StopwatchInAppThemeDefault,
  StopwatchInAppThemeLight,
  StopwatchInAppThemeDark
};

static NSString *const StopwatchInAppThemeSettingsKey = @"custom_theme";

@interface ColorUtils : NSObject

+ (UIColor *)stopwatchBlueColor;

/*
 * Currently, this is only a custom theme for iOS13 and later with dark and light mode support.
 * Method does not implement anything for earlier iOS versions.
 */
+ (void)applyThemeToViewController:(UIViewController *)viewController;

@end
