#import <UIKit/UIKit.h>
#import "AppboyKit.h"

@interface SlideupControlsViewController : UIViewController <ABKSlideupControllerDelegate>

@property (retain, nonatomic) IBOutlet UISegmentedControl *modeButton;
@property (retain, nonatomic) IBOutlet UISwitch *delegateButton;
@property (retain, nonatomic) IBOutlet UIButton *displayNextAvailableSlideupButton;

- (IBAction) displayNextAvailableSlideupPressed:(id)sender;
- (IBAction) modeButtonChanged:(id)sender;
- (IBAction) delegateButtonSwitched:(id)sender;
@end
