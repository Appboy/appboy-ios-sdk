#import "ABKInAppMessageViewController.h"

@class ABKLabel;

/*
 * Appboy Public API: ABKInAppMessageImmersiveViewController
 */
NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageImmersiveViewController : ABKInAppMessageViewController

@property (weak, nonatomic) IBOutlet ABKLabel *inAppMessageHeaderLabel;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *graphicImageView;

- (IBAction)dismissInAppMessage:(id)sender;

@end
NS_ASSUME_NONNULL_END
