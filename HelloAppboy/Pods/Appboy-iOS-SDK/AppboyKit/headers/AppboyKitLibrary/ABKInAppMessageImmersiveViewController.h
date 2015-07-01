#import "ABKInAppMessageViewController.h"

@class ABKLabel;

/*
 * Appboy Public API: ABKInAppMessageImmersiveViewController
 */
@interface ABKInAppMessageImmersiveViewController : ABKInAppMessageViewController

@property (retain, nonatomic) IBOutlet ABKLabel *inAppMessageHeaderLabel;

- (IBAction) dismissInAppMessage:(id)sender;
@end
