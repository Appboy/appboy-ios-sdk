#import "AppDelegate.h"
#import "NUISettings.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    // This lets us use NUI, the theming/customization package. There is also some initialization code in main.m
    // Look at NUI/NUIStyle.nss to see what's being customized.
    [NUISettings initWithStylesheet:@"StopwatchNUIStyle"];
    [NUISettings setGlobalExclusions:@[@"ColorCell", @"InAppMessageButtonCell"]];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
