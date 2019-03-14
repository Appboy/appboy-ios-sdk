#import "ABKInAppMessageImmersiveViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageFullViewController : ABKInAppMessageImmersiveViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textsViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textsViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeXButtonTrailingConstraint;

@end
NS_ASSUME_NONNULL_END
