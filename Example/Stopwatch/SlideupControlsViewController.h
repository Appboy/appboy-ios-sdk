#import <UIKit/UIKit.h>
#import "AppboyKit.h"

@interface SlideupControlsViewController : UIViewController <ABKSlideupControllerDelegate>

@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControlForSlideupMode;
@property (retain, nonatomic) IBOutlet UIButton *displayNextAvailableSlideupButton;

- (IBAction) displayNextAvailableSlideupPressed:(id)sender;
@end
