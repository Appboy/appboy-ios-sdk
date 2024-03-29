#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface FeedUIViewController : UIViewController <UINavigationControllerDelegate>

@property IBOutlet UINavigationController *feedNavigationController;
@property IBOutlet UILabel *unreadCardLabel;
@property IBOutlet UILabel *totalCardsLabel;
@property IBOutlet UISwitch *unReadIndicatorSwitch;
@property IBOutlet UILabel *unreadContentCardLabel;

- (IBAction)displayCategoriedNews:(id)sender;
- (IBAction)modalNewsFeedButtonTapped:(id)sender;
- (IBAction)modalContentCardsButtonTapped:(id)sender;
- (IBAction)navigationContentCardsButtonTapped:(id)sender;
- (IBAction)legacyStoryboardContentCardsButtonTapped:(id)sender;
- (IBAction)customStoryboardContentCardsButtonTapped:(id)sender;

@end
