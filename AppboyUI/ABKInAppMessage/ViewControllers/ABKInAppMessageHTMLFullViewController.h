#import "ABKInAppMessageHTMLViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageHTMLFullViewController : ABKInAppMessageHTMLViewController

/*
 * The constraints for top and bottom between view and the super view.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
NS_ASSUME_NONNULL_END
