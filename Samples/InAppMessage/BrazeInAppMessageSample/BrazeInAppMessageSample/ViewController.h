#import <UIKit/UIKit.h>
#import "AppboyInAppMessage.h"
#import "Appboy-iOS-SDK/AppboyKit.h"

@interface ViewController : UIViewController <ABKInAppMessageUIControlling, ABKInAppMessageUIDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *useCustomViewControllerSwitch;
@property (strong, nonatomic) IBOutlet UITextField *userIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *customEventTextField;

@end

