#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "ABKStoriesView.h"

@interface ABKStoriesViewDataSource : NSObject<ABKStoriesDataSource>

@property (nonatomic) NSMutableArray *images;
@property (nonatomic) ABKStoriesView *storiesView;
@property (nonatomic) NSArray<NSDictionary *> *storyPages;
@property (nonatomic) NSString *appGroup;

- (instancetype)initWithNotification:(UNNotification *)notification
                         storiesView:(ABKStoriesView *)storiesView
                            appGroup:(NSString *)appGroup;

- (UNNotificationContentExtensionResponseOption)didReceiveNotificationResponse:(UNNotificationResponse *)response;

- (void)viewWillDisappear;

@end
