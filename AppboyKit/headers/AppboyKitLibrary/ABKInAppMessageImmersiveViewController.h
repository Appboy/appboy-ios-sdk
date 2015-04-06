#import "ABKInAppMessageViewController.h"

@class ABKLabel;

@interface ABKInAppMessageImmersiveViewController : ABKInAppMessageViewController

@property (retain, nonatomic) IBOutlet ABKLabel *inAppMessageHeaderLabel;

- (IBAction) dismissInAppMessage:(id)sender;
@end
