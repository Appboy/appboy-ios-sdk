#import <AppboyKit.h>
#import "ABKInAppMessageViewController.h"

@interface CustomInAppMessageViewController : ABKInAppMessageViewController

@property IBOutlet UILabel *inAppMessageBodyTextLabel;

- (IBAction)closeButtonTapped:(id)sender;

@end
