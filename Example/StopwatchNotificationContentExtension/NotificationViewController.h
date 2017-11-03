#import <UIKit/UIKit.h>
#import <AppboyPushStory/AppboyPushStory.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController : UIViewController <UNNotificationContentExtension>

@property (nonatomic) IBOutlet ABKStoriesView *storiesView;
@property (nonatomic) ABKStoriesViewDataSource *dataSource;

@end
