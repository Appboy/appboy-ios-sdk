#import <UIKit/UIKit.h>
#import "StopwatchSegmentedControl.h"

@interface InAppMessageHTMLComposerViewController : UIViewController

@property (nonatomic, weak) IBOutlet StopwatchSegmentedControl *HTMLTypeSegment;

- (void)dismissKeyboard;
- (NSURL *)remoteURL;
- (NSString *)inAppText;
- (void)setHTMLComposerBottomSpace:(CGFloat)bottomSpace;

@end
