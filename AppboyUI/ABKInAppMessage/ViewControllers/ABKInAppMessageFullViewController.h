#import "ABKInAppMessageImmersiveViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageFullViewController : ABKInAppMessageImmersiveViewController

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *textsViewLeadingConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *textsViewTrailingConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headerLeadingConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *headerTrailingConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *messageLeadingConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *messageTrailingConstraint;

@end
NS_ASSUME_NONNULL_END
