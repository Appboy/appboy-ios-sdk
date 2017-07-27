#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface FeedAndFeedbackViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate, ABKFeedViewControllerModalContextDelegate>

@property IBOutlet UINavigationController *newsAndFeedbackNavigationController;
@property IBOutlet UILabel *unreadCardLabel;
@property IBOutlet UILabel *totalCardsLabel;
@property IBOutlet UISwitch *unReadIndicatorSwitch;

- (IBAction)newsAndFeedbackButtonTapped:(id)sender;
- (IBAction)displayCategoriedNews:(id)sender;
- (IBAction)modalNewsFeedButtonTapped:(id)sender;
- (IBAction)modalFeedbackButtonTapped:(id)sender;
- (IBAction)submitInstantFeedback:(id)sender;

@end
