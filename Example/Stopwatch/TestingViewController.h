#import <UIKit/UIKit.h>

@interface TestingViewController : UIViewController <UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UILabel *unreadCardLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalCardsLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction) increaseCouponClaimed:(id)sender;
- (IBAction)displayCategoriedNews:(id)sender;
@end
