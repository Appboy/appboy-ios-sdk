#import "ABKInAppMessageImmersiveViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABKInAppMessageModalViewController : ABKInAppMessageImmersiveViewController

/*!
 * The NSLayoutConstraint that specifies the height of the part of the in-app message which houses
 * the image.
 */
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *iconImageHeightConstraint;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *textsViewWidthConstraint;

@property (strong, nonatomic) IBOutlet UIView *iconImageContainerView;
@property (strong, nonatomic) IBOutlet UIView *graphicImageContainerView;

@end
NS_ASSUME_NONNULL_END
