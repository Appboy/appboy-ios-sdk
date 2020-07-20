#import "CustomThemesDataSource.h"
#import "ColorUtils.h"

@implementation CustomThemesDataSource

- (NSArray*)listOfThemes {
  return @[@"Default", @"Force Light", @"Force Dark"];
}

- (NSInteger)currentTheme {
  return [[[NSUserDefaults standardUserDefaults] valueForKey:StopwatchInAppThemeSettingsKey] integerValue];
}

- (void)setTheme:(NSInteger)theme {
  [[NSUserDefaults standardUserDefaults] setInteger:theme forKey:StopwatchInAppThemeSettingsKey];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  [self setTheme:row];
  [ColorUtils applyThemeToViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [[self listOfThemes] objectAtIndex:row];
}
@end
