#import <UIKit/UIKit.h>

@interface TestingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *ratedScoreLabel;
@property (retain, nonatomic) IBOutlet UISwitch *enableAppboySwitch;
@property (retain, nonatomic) IBOutlet UILabel *unreadCardLabel;
@property (retain, nonatomic) IBOutlet UIButton *flushModeButton;
@property (retain, nonatomic) IBOutlet UILabel *totalCardsLabel;
- (IBAction) FlushAppboyData:(id)sender;
- (IBAction) ratingStepperChanged:(UIStepper *)sender;
- (IBAction) changeAppboyFlushMode:(id)sender;
- (IBAction) flushAndShutDownAppboy:(id)sender;
@end
