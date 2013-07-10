#import "AppDelegate.h"
#import "NUISettings.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    [NUISettings init];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
