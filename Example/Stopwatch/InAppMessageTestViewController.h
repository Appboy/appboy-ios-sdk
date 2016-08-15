#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface InAppMessageTestViewController : UIViewController <ABKInAppMessageControllerDelegate>

@property IBOutlet UISegmentedControl *segmentedControlForInAppMode;
@property IBOutlet UISwitch *useCustomViewControllerSwitch;
@property IBOutlet UILabel *remainingIAMLabel;
@property BOOL shouldDisplayInAppMessage;

- (IBAction)displayNextAvailableInAppPressed:(id)sender;
- (IBAction)requestAnInApp:(id)sender;
@end
