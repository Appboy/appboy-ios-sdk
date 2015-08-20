#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface InAppMessageTestViewController : UIViewController <ABKInAppMessageControllerDelegate>

@property IBOutlet UISegmentedControl *segmentedControlForInAppMode;
@property BOOL shouldDisplayInAppMessage;
@property IBOutlet UISegmentedControl *inAppMessageTypeSegmentedControl;

- (IBAction) displayNextAvailableInAppPressed:(id)sender;
- (IBAction)requestAnInApp:(id)sender;
@end
