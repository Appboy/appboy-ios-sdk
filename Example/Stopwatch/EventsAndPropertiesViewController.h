#import <UIKit/UIKit.h>

@interface EventsAndPropertiesViewController : UIViewController
- (IBAction)logPurchaseWithProperties:(id)sender;
- (IBAction)logCustomEventWIthProperties:(id)sender;
- (IBAction)logAttributionData:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *customEventTextField;
@property (weak, nonatomic) IBOutlet UITextField *purchaseTextField;
@end
