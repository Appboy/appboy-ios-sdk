#import <UIKit/UIKit.h>

@interface TestingViewController : UIViewController <UIActionSheetDelegate>

@property IBOutlet UILabel *unreadCardLabel;
@property IBOutlet UILabel *totalCardsLabel;
@property IBOutlet UILabel *versionLabel;
@property IBOutlet UISwitch *unReadIndicatorSwitch;

- (IBAction) increaseCouponClaimed:(id)sender;
- (IBAction)displayCategoriedNews:(id)sender;
@end
