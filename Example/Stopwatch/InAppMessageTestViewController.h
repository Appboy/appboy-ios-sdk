#import <UIKit/UIKit.h>
#import <AppboyKit.h>

@interface InAppMessageTestViewController : UIViewController <ABKInAppMessageControllerDelegate>

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControlForInAppMode;
@property (nonatomic, assign) BOOL shouldDisplayInAppMessage;
@property (retain, nonatomic) IBOutlet UISegmentedControl *inAppMessageTypeSegmentedControl;

- (IBAction) displayNextAvailableInAppPressed:(id)sender;
- (IBAction)requestAnInApp:(id)sender;
@end
