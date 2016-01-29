#import "ABKInAppMessageViewController.h"

@class ABKLabel;

/*
 * Appboy Public API: ABKInAppMessageImmersiveViewController
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageImmersiveViewController : ABKInAppMessageViewController

@property IBOutlet ABKLabel *inAppMessageHeaderLabel;

- (IBAction) dismissInAppMessage:(id)sender;
@end
NS_ASSUME_NONNULL_END
