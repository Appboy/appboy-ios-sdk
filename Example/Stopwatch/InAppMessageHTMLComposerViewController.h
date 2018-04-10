#import <UIKit/UIKit.h>

@interface InAppMessageHTMLComposerViewController : UIViewController

- (void)dismissKeyboard;
- (NSURL *)remoteURL;
- (NSString *)inAppText;
- (void)setHTMLComposerBottomSpace:(CGFloat)bottomSpace;

@end
