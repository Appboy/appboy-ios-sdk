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
    // Get an array containing only cards that have the "example" feed type set in their extras.
    NSArray<ABKContentCard *> *filteredArray = [self getCardsForFeedType:@"example"];
    NSLog(@"Got filtered array of length: %lu", [filteredArray count]);
  }
}

- (NSArray<ABKContentCard *> *)getCardsForFeedType:(NSString *)type {
  NSArray<ABKContentCard *> *cards = [Appboy.sharedInstance.contentCardsController getContentCards];

  NSArray<ABKContentCard *> *filteredArray = [cards filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(ABKContentCard * card, NSDictionary *bindings) {
    NSDictionary *extras = [card extras];
    if (extras != nil && [extras objectForKey:@"feed_type"] != nil && [[extras objectForKey:@"feed_type"] isEqualToString:type]) {
      NSLog(@"Got card: %@ ", card.idString);
      return YES;
    }
    return NO;
  }]];

  return filteredArray;
}

@end
