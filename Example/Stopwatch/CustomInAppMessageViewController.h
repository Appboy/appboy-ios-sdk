#import <AppboyKit.h>
@interface CustomInAppMessageViewController : ABKInAppMessageViewController
@property IBOutlet UILabel *inAppMessageBodyTextLabel;

// dismiss the in-app message
- (IBAction)closeButtonTapped:(id)sender;

@end
