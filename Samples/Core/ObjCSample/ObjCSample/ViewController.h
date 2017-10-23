#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UITextField *userIDTextField;
@property IBOutlet UITextField *customAttributeKeyTextField;
@property IBOutlet UITextField *customAttributeValueTextField;
@property IBOutlet UITextField *customEventTextField;
@property IBOutlet UITextField *customEventPropertyKeyTextField;
@property IBOutlet UITextField *customEventPropertyValueTextField;

- (IBAction)identifyButtonClicked:(id)sender;
- (IBAction)flushButtonClicked:(id)sender;
- (IBAction)customAttributeButtonClicked:(id)sender;
- (IBAction)trackButtonClicked:(id)sender;

@end

