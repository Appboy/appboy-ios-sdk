#import <UIKit/UIKit.h>
#import "AppboyKit.h"

@interface SlideupTestViewController : UIViewController <ABKSlideupControllerDelegate>

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControlForSlideupMode;
@property (nonatomic, retain) IBOutlet UIButton *displayNextAvailableSlideupButton;
@property (nonatomic, assign) BOOL shouldDisplaySlideup;
@property (retain, nonatomic) IBOutlet UISegmentedControl *slideupAnchorSegmentedControl;
@property (retain, nonatomic) IBOutlet UISegmentedControl *slideupDismissTypeSegmentedControl;

- (IBAction) displayNextAvailableSlideupPressed:(id)sender;
@end
