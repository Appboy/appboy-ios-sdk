#import <AppboyKit.h>
#import "AppboyInAppMessage.h"

@interface CustomInAppMessageViewController : ABKInAppMessageViewController

@property IBOutlet UILabel *inAppMessageBodyTextLabel;

- (IBAction)closeButtonTapped:(id)sender;

@end
