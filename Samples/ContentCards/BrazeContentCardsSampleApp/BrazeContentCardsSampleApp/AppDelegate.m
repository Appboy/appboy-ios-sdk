#import "AppDelegate.h"
#import "Appboy-iOS-SDK/AppboyKit.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Appboy startWithApiKey:@"84c34224-38f6-4dad-9702-f2163df080b6"
            inApplication:application
        withLaunchOptions:launchOptions];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentCardsUpdatedNotificationReceived:)
                                               name:ABKContentCardsProcessedNotification
                                             object:nil];
  
  return YES;
}

- (void)contentCardsUpdatedNotificationReceived:(NSNotification *)notification {
  BOOL updateIsSuccessful = [notification.userInfo[ABKContentCardsProcessedIsSuccessfulKey] boolValue];
  if (updateIsSuccessful) {
    NSLog(@"Content cards updated successfully", nil);
  }
}

@end
