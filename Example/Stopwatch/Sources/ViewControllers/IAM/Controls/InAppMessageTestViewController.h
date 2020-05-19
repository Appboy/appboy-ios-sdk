#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface InAppMessageTestViewController : UIViewController <ABKInAppMessageControllerDelegate>

@property IBOutlet UISegmentedControl *segmentedControlForInAppMode;
@property IBOutlet UILabel *remainingIAMLabel;
@property BOOL shouldDisplayInAppMessage;

- (IBAction)displayNextAvailableInAppPressed:(id)sender;

@end
