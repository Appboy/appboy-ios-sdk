#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>

@implementation NotificationViewController

- (void)didReceiveNotification:(UNNotification *)notification {
  self.dataSource = [[ABKStoriesViewDataSource alloc] initWithNotification:notification
                                                               storiesView:self.storiesView
                                                                  appGroup:@"group.com.appboy.stopwatch"];
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response
                     completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion {
  UNNotificationContentExtensionResponseOption option = [self.dataSource didReceiveNotificationResponse:response];
  completion(option);
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.dataSource viewWillDisappear];
  [super viewWillDisappear:animated];
}

@end
