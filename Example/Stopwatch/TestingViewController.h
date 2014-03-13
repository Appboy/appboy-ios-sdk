#import <UIKit/UIKit.h>

@interface TestingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *unreadCardLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalCardsLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction) increaseCouponClaimed:(id)sender;
@end
