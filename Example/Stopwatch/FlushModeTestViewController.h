#import <UIKit/UIKit.h>

@interface FlushModeTestViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *flushModeLabel;

- (IBAction) FlushAppboyData:(id)sender;
- (IBAction) changeAppboyFlushMode:(id)sender;
- (IBAction) flushAndShutDownAppboy:(id)sender;
@end
